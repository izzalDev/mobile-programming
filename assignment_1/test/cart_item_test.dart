import 'package:assignment_1/cart_item.dart';
import 'package:assignment_1/product.dart';
import 'package:test/test.dart';

void main() {
  group('CartItem', () {
    final p1 = Product(
      name: "Laptop",
      category: "Electronics",
      price: 20_000_000,
    );

    test("totalPrice should return price*quantity", () {
      final cartItem = CartItem(product: p1, quantity: 2);
      expect(cartItem.totalPrice, 40_000_000);
    });
  });
}
