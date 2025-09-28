import 'dart:convert';
import 'package:assignment_1/assignment_1.dart';

void main() {
  final product1 = Product(
    name: 'Laptop',
    category: 'Electronics',
    price: 10000,
    stock: 10,
  );
  final product2 = Product(
    name: 'Mouse',
    category: 'Electronics',
    price: 500,
    stock: 20,
  );
  final product3 = Product(
    name: 'Shirt',
    category: 'Clothing',
    price: 1500,
    stock: 5,
  );

  final catalog = ProductCatalog()
    ..addProduct(product1)
    ..addProduct(product2)
    ..addProduct(product3);

  final cart = ShoppingCart()
    ..addProduct(product1, quantity: 2)
    ..addProduct(product2)
    ..addProduct(product3, quantity: 3);

  print('\n================= KERANJANG AWAL =================');
  cart.displayCart();

  cart.updateQuantity('mouse', 5);
  print('\n============= SETELAH UPDATE QTY MOUSE =============');
  cart.displayCart();

  cart.removeProduct('shirt');
  print('\n============= SETELAH REMOVE PRODUK SHIRT =============');
  cart.displayCart();

  print('\n============= PRODUK KATEGORI: Electronics =============');
  final electronics = cart.getItemsByCategory('electronics');
  for (var item in electronics) {
    print('${item.product.name} - Qty: ${item.quantity}');
  }

  print('\n========= KELOMPOK PRODUK BERDASARKAN KATEGORI =========');
  final grouped = cart.groupItemsByCategory();
  grouped.forEach((category, items) {
    print('\nKategori: $category');
    for (var item in items) {
      print(' - ${item.product.name} x${item.quantity}');
    }
  });

  final subtotal = cart.calculateSubtotal();
  print('\n==================== SUBTOTAL ====================');
  print('Subtotal: Rp $subtotal');

  print('\n=================== DISKON ===================');
  print(
    'Diskon kategori Electronics (10%): Rp ${cart.calculateDiscount(DiscountType.category, 0.10, category: 'electronics')}',
  );
  print(
    'Diskon persentase (5%): Rp ${cart.calculateDiscount(DiscountType.percentage, 0.05)}',
  );
  print(
    'Diskon bulk (qty > 5, 20%): Rp ${cart.calculateDiscount(DiscountType.bulk, 0.20)}',
  );
  print(
    'Diskon fixed (Rp 500): Rp ${cart.calculateDiscount(DiscountType.fixed, 500)}',
  );

  print('\n============= TOTAL SETELAH DISKON 5% =============');
  print('Total: Rp ${cart.calculateTotal(DiscountType.percentage, 0.05)}');

  bool isValid = cart.validateCart(catalog);
  print('\n================= VALIDASI KERANJANG =================');
  print('Valid: $isValid');

  final errors = cart.getValidationErrors(catalog);
  if (errors.isEmpty) {
    print('Tidak ada error.');
  } else {
    print('Error:');
		print(errors);
  }

  print('\n========= TAMPILKAN KERANJANG BERDASARKAN KATEGORI =========');
  cart.displayCartByCategory();

  print('\n================= EXPORT KE TEXT =================');
  print(cart.exportToText());

  print('\n================= EXPORT KE JSON =================');
  print(const JsonEncoder.withIndent('  ').convert(cart.exportToJson()));

  cart.clearCart();
  print('\n============= KERANJANG TELAH DIKOSONGKAN =============');
}
