import 'package:test/test.dart';
import 'package:assignment_1/shopping_cart.dart';
import 'package:assignment_1/product.dart';
import 'package:assignment_1/product_catalog.dart';
import 'package:assignment_1/discount_type.dart';
import 'dart:async';

void main() {
  final p1 = Product(
    name: 'Laptop',
    category: 'Electronics',
    price: 10000,
    stock: 10,
  );
  final p2 = Product(
    name: 'Mouse',
    category: 'Electronics',
    price: 500,
    stock: 20,
  );
  final p3 = Product(
    name: 'Shirt',
    category: 'Clothing',
    price: 1500,
    stock: 5,
  );
  final p4 = Product(
    name: 'Pants',
    category: 'Clothing',
    price: 1500,
    stock: 5,
  );
  final catalog = ProductCatalog()
    ..addProduct(p1)
    ..addProduct(p2)
    ..addProduct(p3);

  late ShoppingCart cart;

  // Helper untuk menangkap output print
  Future<String> capturePrintOutput(FutureOr<void> Function() body) async {
    final output = StringBuffer();
    final spec = ZoneSpecification(print: (_, __, ___, String msg) {
      output.writeln(msg);
    });

    await Zone.current.fork(specification: spec).run(body);

    return output.toString();
  }

  setUp(() {
    cart = ShoppingCart();
  });

  test('Add products and validate cart', () {
    cart.addProduct(p1, quantity: 2);
    cart.addProduct(p2);
    cart.addProduct(p3, quantity: 3);

    expect(cart.getItems().length, 3);
    expect(cart.validateCart(catalog), true);
    expect(
      () => cart.addProduct(p1, quantity: 0),
      throwsA(isA<ArgumentError>()),
    );
    cart.addProduct(p4);
    expect(cart.validateCart(catalog), false);
  });

  test('Update quantity and recalc subtotal', () {
    cart.addProduct(p1);
    cart.updateQuantity(p1.name, 5);
    final item = cart.getItems().firstWhere((i) => i.product.name == p1.name);
    expect(item.quantity, 5);
    expect(cart.calculateSubtotal(), p1.price * 5);
    expect(
      () => cart.updateQuantity(p1.name, 0),
      throwsA(isA<ArgumentError>()),
    );
    expect(
      () => cart.updateQuantity(p2.name, 1),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('Remove product', () {
    cart.addProduct(p3);
    cart.removeProduct(p3.name);

    expect(cart.getItems().isEmpty, true);
  });

  test('Calculate discount', () {
    cart.addProduct(p1, quantity: 2);
    cart.addProduct(p3);

    final discountCategory = cart.calculateDiscount(
      DiscountType.category,
      0.10,
      category: 'electronics',
    );
    final discountPercentage = cart.calculateDiscount(
      DiscountType.percentage,
      0.10,
    );
    expect(discountCategory, 10000 * 2 * 0.10);
    expect(discountPercentage, 21500 * 0.10);
    cart.updateQuantity(p3.name, 5);
    final discountBulk = cart.calculateDiscount(DiscountType.bulk, 0.20);
    expect(discountBulk, cart.calculateSubtotal() * 0.20);
    final discountFixed = cart.calculateDiscount(DiscountType.fixed, 20000);
    expect(discountFixed, 20000);
  });

  test('calculateTotal should return subtotal minus discount', () {
    cart.addProduct(p1, quantity: 10);
    final total = cart.calculateTotal(DiscountType.fixed, 10000);
    expect(total, 100000 - 10000);
  });

  test('Validation errors on invalid stock', () {
    cart.addProduct(p1, quantity: 20);
    cart.addProduct(p4);
    final errors = cart.getValidationErrors(catalog);
    expect(errors.length, 2);
    expect(
      errors,
      containsAll([
        'Stok untuk "laptop" tidak mencukupi (diminta: 20, tersedia: 10).',
        'Produk "pants" tidak ditemukan di katalog.',
      ]),
    );
  });

  test('clearCart should work', () {
    cart.addProduct(p1);
    cart.clearCart();
    expect(cart.getItems().length, 0);
  });

  test("groupItemByCategory should return Map<categories, groupedItems>", () {
    final groupedCart = cart
        .addProduct(p1)
        .addProduct(p2)
        .addProduct(p3)
        .groupItemsByCategory();

    expect(groupedCart.length, 2);
    expect(groupedCart[p1.category]!.length, 2);
    expect(groupedCart[p3.category]!.length, 1);
  });

  test('exportToText returns formatted string', () {
    cart
      ..addProduct(p1, quantity: 2)
      ..addProduct(p2, quantity: 1)
      ..addProduct(p3, quantity: 1);

    final text = cart.exportToText();

    expect(text, contains('1. laptop (electronics) - Rp 10000 x2 = Rp 20000'));
    expect(text, contains('2. mouse (electronics) - Rp 500 x1 = Rp 500'));
    expect(text, contains('3. shirt (clothing) - Rp 1500 x1 = Rp 1500'));
    expect(text, contains('Total Items: 3'));
    expect(text, contains('Subtotal: Rp 22000'));
  });

  test('exportToJson returns valid structure', () {
    cart.addProduct(p1, quantity: 2);
    final json = cart.exportToJson();

    expect(json['totalItems'], 1);
    expect(json['subtotal'], 20000);
    expect(json['items'], isA<List>());
    expect(json['items'].first['product']['name'], equals('laptop'));
  });

  test('displayCart prints correct output', () async {
    cart
      ..addProduct(p1, quantity: 2)
      ..addProduct(p2, quantity: 1);

    final output = await capturePrintOutput(() => cart.displayCart());

    expect(output, contains('=== ISI KERANJANG BELANJA ==='));
    expect(output, contains('1. laptop - electronics - Rp 10000 x2 = Rp 20000'));
    expect(output, contains('2. mouse - electronics - Rp 500 x1 = Rp 500'));
    expect(output, contains('Subtotal: 20500'));
  });

  test('displayCartByCategory prints grouped output', () async {
    cart
      ..addProduct(p1)
      ..addProduct(p3);

    final output = await capturePrintOutput(() => cart.displayCartByCategory());

    expect(output, contains('=== ISI KERANJANG BELANJA BERDASARKAN KATEGORI ==='));
    expect(output, contains('Kategori: electronics'));
    expect(output, contains('1. laptop - Rp 10000 x1 = Rp 10000'));
    expect(output, contains('Kategori: clothing'));
    expect(output, contains('1. shirt - Rp 1500 x1 = Rp 1500'));
    expect(output, contains('Total Items: 2'));
    expect(output, contains('Subtotal: 11500'));
  });
}
