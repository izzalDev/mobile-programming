import 'dart:async';
import 'package:test/test.dart';
import 'package:assignment_1/shopping_cart.dart';
import 'package:assignment_1/product.dart';
import 'package:assignment_1/product_catalog.dart';
import 'package:assignment_1/discount_type.dart';

void main() {
  late ShoppingCart cart;

  final produk1 = Product(
    name: 'Laptop Gaming',
    category: 'Elektronik',
    price: 15_000_000,
    stock: 10,
  );
  final produk2 = Product(
    name: 'Mouse Wireless',
    category: 'Elektronik',
    price: 350_000,
    stock: 25,
  );
  final produk3 = Product(
    name: 'Kemeja Batik',
    category: 'Pakaian',
    price: 250_000,
    stock: 10,
  );
  final produk4 = Product(
    name: 'Celana Jeans',
    category: 'Pakaian',
    price: 300_000,
    stock: 8,
  );

  final katalog = ProductCatalog()
    ..addProduct(produk1)
    ..addProduct(produk2)
    ..addProduct(produk3);

  T capturePrintOutput<T>(T Function() body, [StringBuffer? output]) {
    final spec = ZoneSpecification(
      print: (_, __, ___, String msg) {
        if (output != null) {
          output.writeln(msg);
        }
      },
    );
    return Zone.current.fork(specification: spec).run(body);
  }

  setUp(() {
    cart = ShoppingCart();
  });

  test('addProduct', () {
    cart = capturePrintOutput(() => cart.addProduct(produk1, quantity: 2));
    final items = cart.getItems();
    expect(items.length, 1);
    expect(items.first.product.name, 'Laptop Gaming');
    expect(items.first.quantity, 2);
  });

  test('addProduct throws if quantity < 1', () {
    expect(
      () => capturePrintOutput(() => cart.addProduct(produk1, quantity: 0)),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('removeProduct', () {
    cart = capturePrintOutput(() => cart.addProduct(produk1));
    cart.removeProduct('Laptop Gaming');
    expect(cart.getItems(), isEmpty);
  });

  test('updateQuantity', () {
    cart = capturePrintOutput(() => cart.addProduct(produk1, quantity: 2));
    cart.updateQuantity('Laptop Gaming', 5);
    expect(cart.getItems().first.quantity, 5);
  });

  test('updateQuantity throws if quantity < 1', () {
    cart = capturePrintOutput(() => cart.addProduct(produk1));
    expect(
      () => cart.updateQuantity('Laptop Gaming', 0),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('updateQuantity throws if product not in cart', () {
    expect(
      () => cart.updateQuantity('Produk Tidak Ada', 1),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('clearCart', () {
    cart = capturePrintOutput(() => cart.addProduct(produk1));
    cart.clearCart();
    expect(cart.getItems(), isEmpty);
  });

  test('getItemsByCategory', () {
    cart = capturePrintOutput(() => cart.addProduct(produk1));
    cart = capturePrintOutput(() => cart.addProduct(produk3));
    final elektronik = cart.getItemsByCategory('Elektronik');
    expect(elektronik.length, 1);
    expect(elektronik.first.product.name, 'Laptop Gaming');
  });

  test('groupItemsByCategory', () {
    cart = capturePrintOutput(() => cart.addProduct(produk1));
    cart = capturePrintOutput(() => cart.addProduct(produk2));
    cart = capturePrintOutput(() => cart.addProduct(produk3));
    final grouped = cart.groupItemsByCategory();
    expect(grouped['Elektronik']!.length, 2);
    expect(grouped['Pakaian']!.length, 1);
  });

  test('calculateSubtotal', () {
    cart = capturePrintOutput(() => cart.addProduct(produk1, quantity: 2));
    cart = capturePrintOutput(() => cart.addProduct(produk2));
    final subtotal = cart.calculateSubtotal();
    expect(subtotal, 15_000_000 * 2 + 350_000);
  });

  test('calculateDiscount - percentage', () {
    cart = capturePrintOutput(() => cart.addProduct(produk1, quantity: 2));
    final discount = cart.calculateDiscount(DiscountType.percentage, 0.1);
    expect(discount, 15_000_000 * 2 * 0.1);
  });

  test('calculateDiscount - fixed', () {
    final discount = cart.calculateDiscount(DiscountType.fixed, 500_000);
    expect(discount, 500_000);
  });

  test('calculateDiscount - category', () {
    cart = capturePrintOutput(() => cart.addProduct(produk1, quantity: 2));
    cart = capturePrintOutput(() => cart.addProduct(produk3));
    final discount = cart.calculateDiscount(DiscountType.category, 0.1, category: 'Elektronik');
    expect(discount, 15_000_000 * 2 * 0.1);
  });

  test('calculateDiscount - bulk applied', () {
    cart = capturePrintOutput(() => cart.addProduct(produk1, quantity: 6));
    final discount = cart.calculateDiscount(DiscountType.bulk, 0.2);
    expect(discount, 15_000_000 * 6 * 0.2);
  });

  test('calculateDiscount - bulk not applied', () {
    cart = capturePrintOutput(() => cart.addProduct(produk1, quantity: 5));
    final discount = cart.calculateDiscount(DiscountType.bulk, 0.2);
    expect(discount, 0);
  });

  test('calculateTotal', () {
    cart = capturePrintOutput(() => cart.addProduct(produk1, quantity: 3));
    final total = cart.calculateTotal(DiscountType.fixed, 500_000);
    expect(total, 15_000_000 * 3 - 500_000);
  });

  test('validateCart true', () {
    cart = capturePrintOutput(() => cart.addProduct(produk1, quantity: 2));
    final valid = cart.validateCart(katalog);
    expect(valid, true);
  });

  test('validateCart false for stock', () {
    cart = capturePrintOutput(() => cart.addProduct(produk1, quantity: 100));
    final valid = cart.validateCart(katalog);
    expect(valid, false);
  });

  test('validateCart false for missing product', () {
    cart = capturePrintOutput(() => cart.addProduct(produk4));
    final valid = cart.validateCart(katalog);
    expect(valid, false);
  });

  test('getValidationErrors', () {
    cart = capturePrintOutput(() => cart.addProduct(produk1, quantity: 100));
    cart = capturePrintOutput(() => cart.addProduct(produk4));
    final errors = cart.getValidationErrors(katalog);
    expect(errors.length, 2);
    expect(errors[0], contains('Stok untuk "Laptop Gaming" tidak mencukupi'));
    expect(errors[1], contains('Produk "Celana Jeans" tidak ditemukan'));
  });

  test('exportToText', () {
    cart = capturePrintOutput(() => cart.addProduct(produk1, quantity: 2));
    cart = capturePrintOutput(() => cart.addProduct(produk2));
    final text = cart.exportToText();
    expect(
      text,
      equals('''
=== ISI KERANJANG BELANJA ===
1. Laptop Gaming (Elektronik) - Rp 15000000 x2 = Rp 30000000
2. Mouse Wireless (Elektronik) - Rp 350000 x1 = Rp 350000
Total Items: 2
Subtotal: Rp 30350000
'''),
    );
  });

  test('exportToJson', () {
    cart = capturePrintOutput(() => cart.addProduct(produk1, quantity: 2));
    final json = cart.exportToJson();
    expect(json['totalItems'], 1);
    expect(json['subtotal'], 30_000_000);
    expect(json['items'], isA<List>());
    expect(json['items'].first['product']['name'], 'Laptop Gaming');
  });

  test('displayCart', () {
    final buffer = StringBuffer();
    cart = capturePrintOutput(() => cart.addProduct(produk1, quantity: 2));
    cart = capturePrintOutput(() => cart.addProduct(produk2, quantity: 1));
    capturePrintOutput(() => cart.displayCart(), buffer);
    expect(
      buffer.toString(),
      equals('''
=== ISI KERANJANG BELANJA ===
1. Laptop Gaming - Elektronik - Rp 15000000 x2 = Rp 30000000
2. Mouse Wireless - Elektronik - Rp 350000 x1 = Rp 350000
Total Items: 2
Subtotal: Rp 30350000
'''),
    );
  });

  test('displayCartByCategory', () {
    final buffer = StringBuffer();
    cart = capturePrintOutput(() => cart.addProduct(produk1));
    cart = capturePrintOutput(() => cart.addProduct(produk2));
    cart = capturePrintOutput(() => cart.addProduct(produk3));
    capturePrintOutput(() => cart.displayCartByCategory(), buffer);
    expect(
      buffer.toString(),
      equals('''
=== KERANJANG PER KATEGORI ===
Elektronik (2 items):
  • Laptop Gaming - Rp 15000000 x1 = Rp 15000000
  • Mouse Wireless - Rp 350000 x1 = Rp 350000
Pakaian (1 items):
  • Kemeja Batik - Rp 250000 x1 = Rp 250000
'''),
    );
  });
}
