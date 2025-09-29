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

  T capturePrintOutput<T>(T Function() body, StringBuffer output) {
    final spec = ZoneSpecification(print: (_, __, ___, String msg) {
      output.writeln(msg);
    });
    return Zone.current.fork(specification: spec).run(body);
  }

  setUp(() {
    cart = ShoppingCart();
  });

  test('addProduct', () {
    cart.addProduct(produk1, quantity: 2);
    final items = cart.getItems();
    expect(items.length, 1);
    expect(items.first.product.name, 'Laptop Gaming');
    expect(items.first.quantity, 2);
  });

  test('addProduct throws if quantity < 1', () {
    expect(() => cart.addProduct(produk1, quantity: 0), throwsA(isA<ArgumentError>()));
  });

  test('removeProduct', () {
    cart.addProduct(produk1).removeProduct('Laptop Gaming');
    expect(cart.getItems(), isEmpty);
  });

  test('updateQuantity', () {
    cart.addProduct(produk1, quantity: 2).updateQuantity('Laptop Gaming', 5);
    expect(cart.getItems().first.quantity, 5);
  });

  test('updateQuantity throws if quantity < 1', () {
    cart.addProduct(produk1);
    expect(() => cart.updateQuantity('Laptop Gaming', 0), throwsA(isA<ArgumentError>()));
  });

  test('updateQuantity throws if product not in cart', () {
    expect(() => cart.updateQuantity('Produk Tidak Ada', 1), throwsA(isA<ArgumentError>()));
  });

  test('clearCart', () {
    cart.addProduct(produk1).clearCart();
    expect(cart.getItems(), isEmpty);
  });

  test('getItemsByCategory', () {
    cart.addProduct(produk1).addProduct(produk3);
    final elektronik = cart.getItemsByCategory('Elektronik');
    expect(elektronik.length, 1);
    expect(elektronik.first.product.name, 'Laptop Gaming');
  });

  test('groupItemsByCategory', () {
    final grouped = cart
        .addProduct(produk1)
        .addProduct(produk2)
        .addProduct(produk3)
        .groupItemsByCategory();
    expect(grouped['Elektronik']!.length, 2);
    expect(grouped['Pakaian']!.length, 1);
  });

  test('calculateSubtotal', () {
    final subtotal = cart.addProduct(produk1, quantity: 2).addProduct(produk2).calculateSubtotal();
    expect(subtotal, 15_000_000 * 2 + 350_000);
  });

  test('calculateDiscount - percentage', () {
    final discount = cart.addProduct(produk1, quantity: 2).calculateDiscount(DiscountType.percentage, 0.1);
    expect(discount, 15_000_000 * 2 * 0.1);
  });

  test('calculateDiscount - fixed', () {
    final discount = cart.calculateDiscount(DiscountType.fixed, 500_000);
    expect(discount, 500_000);
  });

  test('calculateDiscount - category', () {
    final discount = cart
        .addProduct(produk1, quantity: 2)
        .addProduct(produk3)
        .calculateDiscount(DiscountType.category, 0.1, category: 'Elektronik');
    expect(discount, 15_000_000 * 2 * 0.1);
  });

  test('calculateDiscount - bulk applied', () {
    final discount = cart.addProduct(produk1, quantity: 6).calculateDiscount(DiscountType.bulk, 0.2);
    expect(discount, 15_000_000 * 6 * 0.2);
  });

  test('calculateDiscount - bulk not applied', () {
    final discount = cart.addProduct(produk1, quantity: 5).calculateDiscount(DiscountType.bulk, 0.2);
    expect(discount, 0);
  });

  test('calculateTotal', () {
    final total = cart.addProduct(produk1, quantity: 3).calculateTotal(DiscountType.fixed, 500_000);
    expect(total, 15_000_000 * 3 - 500_000);
  });

  test('validateCart true', () {
    final valid = cart.addProduct(produk1, quantity: 2).validateCart(katalog);
    expect(valid, true);
  });

  test('validateCart false for stock', () {
    final valid = cart.addProduct(produk1, quantity: 100).validateCart(katalog);
    expect(valid, false);
  });

  test('validateCart false for missing product', () {
    final valid = cart.addProduct(produk4).validateCart(katalog);
    expect(valid, false);
  });

  test('getValidationErrors', () {
    final errors = cart.addProduct(produk1, quantity: 100).addProduct(produk4).getValidationErrors(katalog);
    expect(errors.length, 2);
    expect(errors[0], contains('Stok untuk "Laptop Gaming" tidak mencukupi'));
    expect(errors[1], contains('Produk "Celana Jeans" tidak ditemukan'));
  });

  test('exportToText', () {
    final text = cart.addProduct(produk1, quantity: 2).addProduct(produk2).exportToText();
    expect(text, equals('''
=== ISI KERANJANG BELANJA ===
1. Laptop Gaming (Elektronik) - Rp 15000000 x2 = Rp 30000000
2. Mouse Wireless (Elektronik) - Rp 350000 x1 = Rp 350000
Total Items: 2
Subtotal: Rp 30350000
'''));
  });

  test('exportToJson', () {
    final json = cart.addProduct(produk1, quantity: 2).exportToJson();
    expect(json['totalItems'], 1);
    expect(json['subtotal'], 30_000_000);
    expect(json['items'], isA<List>());
    expect(json['items'].first['product']['name'], 'Laptop Gaming');
  });

  test('displayCart', () {
    final buffer = StringBuffer();
    capturePrintOutput(
      () => cart.addProduct(produk1, quantity: 2).addProduct(produk2, quantity: 1).displayCart(),
      buffer,
    );
    expect(buffer.toString(), equals('''
=== ISI KERANJANG BELANJA ===
1. Laptop Gaming - Elektronik - Rp 15000000 x2 = Rp 30000000
2. Mouse Wireless - Elektronik - Rp 350000 x1 = Rp 350000
Total Items: 2
Subtotal: 30350000
'''));
  });

  test('displayCartByCategory', () {
    final buffer = StringBuffer();
    capturePrintOutput(
      () => cart.addProduct(produk1).addProduct(produk2).addProduct(produk3).displayCartByCategory(),
      buffer,
    );
    expect(buffer.toString(), equals('''
=== ISI KERANJANG BELANJA BERDASARKAN KATEGORI ===
Kategori: Elektronik
  1. Laptop Gaming - Rp 15000000 x1 = Rp 15000000
  2. Mouse Wireless - Rp 350000 x1 = Rp 350000
---
Kategori: Pakaian
  1. Kemeja Batik - Rp 250000 x1 = Rp 250000
---
Total Items: 3
Subtotal: 15600000
'''));
  });
}
