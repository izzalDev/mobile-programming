import 'package:assignment_1/cart_item.dart';
import 'package:assignment_1/discount_type.dart';
import 'package:assignment_1/product.dart';
import 'package:assignment_1/product_catalog.dart';

class ShoppingCart {
  final List<CartItem> _items = [];

  ShoppingCart addProduct(Product product, {int quantity = 1}) {
    if (quantity < 1) {
      throw ArgumentError("quantity cannot be less than 1");
    }

    final newProduct = Product(
      name: product.name.toLowerCase(),
      category: product.category.toLowerCase(),
      price: product.price,
    );

    _items.add(CartItem(product: newProduct, quantity: quantity));
    return this;
  }

  ShoppingCart removeProduct(String productName) {
    _items.removeWhere(
      (item) => item.product.name == productName.toLowerCase(),
    );
    return this;
  }

  ShoppingCart updateQuantity(String productName, int newQuantity) {
    if (newQuantity < 1) {
      throw ArgumentError("newQuantity cannot be less than 1");
    }

    final item = _items.firstWhere(
      (item) => item.product.name == productName.toLowerCase(),
      orElse: () => throw ArgumentError("Product not found in the cart"),
    );

    item.quantity = newQuantity;
    return this;
  }

  ShoppingCart clearCart() {
    _items.clear();
    return this;
  }

  List<CartItem> getItems() {
    return _items;
  }

  List<CartItem> getItemsByCategory(String category) {
    return _items
        .where((item) => item.product.category == category.toLowerCase())
        .toList();
  }

  Map<String, List<CartItem>> groupItemsByCategory() {
    final Map<String, List<CartItem>> groupedItems = {};
    for (CartItem item in _items) {
      final category = item.product.category;
      groupedItems.putIfAbsent(category, () => []).add(item);
    }
    return groupedItems;
  }

  double calculateSubtotal() {
    final prices = _items.map((item) => item.product.price * item.quantity);
    return prices.fold(0, (sum, price) => sum + price);
  }

  double calculateDiscount(
    DiscountType discountType,
    double discountValue, {
    String category = "",
  }) {
    switch (discountType) {
      case DiscountType.category:
        final items = getItemsByCategory(category);
        final total = items.fold(0.0, (sum, item) => sum + item.totalPrice);
        return total * discountValue;

      case DiscountType.percentage:
        return calculateSubtotal() * discountValue;

      case DiscountType.bulk:
        final totalQuantity = _items.fold(
          0,
          (sum, item) => sum + item.quantity,
        );
        return totalQuantity > 5 ? discountValue * calculateSubtotal() : 0;

      case DiscountType.fixed:
        return discountValue;
    }
  }

  double calculateTotal(
    DiscountType discountType,
    double discountValue, {
    String category = "",
  }) {
    final discount = calculateDiscount(
      discountType,
      discountValue,
      category: category,
    );
    return calculateSubtotal() - discount;
  }

  bool validateCart(ProductCatalog catalog) {
    for (CartItem item in _items) {
      try {
        final product = catalog.products.firstWhere(
          (product) => product.name == item.product.name,
        );

        if (product.stock < item.quantity) {
          return false;
        }
      } catch (e) {
        if (e is StateError) {
          return false;
        } else {
          rethrow;
        }
      }
    }

    return true;
  }

  List<String> getValidationErrors(ProductCatalog catalog) {
    final List<String> errors = [];
    final Map<String, Product> productMap = {
      for (Product product in catalog.products) product.name: product,
    };

    for (CartItem item in _items) {
      Product? productInCatalog = productMap[item.product.name];

      if (productInCatalog == null) {
        errors.add('Produk "${item.product.name}" tidak ditemukan di katalog.');
        continue;
      }

      if (item.quantity > productInCatalog.stock) {
        errors.add(
          'Stok untuk "${item.product.name}" tidak mencukupi (diminta: ${item.quantity}, tersedia: ${productInCatalog.stock}).',
        );
      }
    }

    return errors;
  }

  void displayCart() {
    print("=== ISI KERANJANG BELANJA ===");
    for (int i = 0; i < _items.length; i++) {
      final item = _items[i];
      final quantity = item.quantity;
      final product = item.product;
      print(
        '${i + 1}. ${product.name} - ${product.category} - ${product.formattedPrice} x$quantity = Rp ${item.totalPrice.toStringAsFixed(0)}',
      );
    }
    print('Total Items: ${_items.length}');
    print('Subtotal: ${calculateSubtotal().toStringAsFixed(0)}');
  }

  void displayCartByCategory() {
    final grouped = groupItemsByCategory();
    print("=== ISI KERANJANG BELANJA BERDASARKAN KATEGORI ===");

    grouped.forEach((category, items) {
      print('Kategori: $category');
      for (int i = 0; i < items.length; i++) {
        final item = items[i];
        final product = item.product;
        final quantity = item.quantity;
        print(
          '  ${i + 1}. ${product.name} - ${product.formattedPrice} x$quantity = Rp ${item.totalPrice.toStringAsFixed(0)}',
        );
      }
      print('---');
    });

    print('Total Items: ${_items.length}');
    print('Subtotal: ${calculateSubtotal().toStringAsFixed(0)}');
  }

  String exportToText() {
    final buffer = StringBuffer();
    buffer.writeln('=== ISI KERANJANG BELANJA ===');

    for (int i = 0; i < _items.length; i++) {
      final item = _items[i];
      final product = item.product;
      final quantity = item.quantity;
      buffer.writeln(
        '${i + 1}. ${product.name} (${product.category}) - ${product.formattedPrice} x$quantity = Rp ${item.totalPrice.toStringAsFixed(0)}',
      );
    }

    buffer.writeln('Total Items: ${_items.length}');
    buffer.writeln('Subtotal: Rp ${calculateSubtotal().toStringAsFixed(0)}');

    return buffer.toString();
  }

  Map<String, dynamic> exportToJson() {
    return {
      'items': _items
          .map(
            (item) => {
              'product': {
                'name': item.product.name,
                'category': item.product.category,
                'price': item.product.price,
              },
              'quantity': item.quantity,
              'totalPrice': item.totalPrice,
            },
          )
          .toList(),
      'totalItems': _items.length,
      'subtotal': calculateSubtotal(),
    };
  }
}
