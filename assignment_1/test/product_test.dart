import 'package:test/test.dart';
import 'package:assignment_1/product.dart';

void main() {
  group('Product', () {
    test('should create product with default stock 0', () {
      final product = Product(name: 'Laptop', category: 'Electronics', price: 10000000);
      expect(product.name, 'laptop');
      expect(product.category, 'electronics');
      expect(product.price, 10000000);
      expect(product.stock, 0);
      expect(product.isAvailable, false);
    });

    test('create() factory should return product with correct values', () {
      final product = Product.create('mouse', 'electronics', 200000);
      expect(product.name, 'mouse');
      expect(product.category, 'electronics');
      expect(product.price, 200000);
      expect(product.stock, 0);
    });

    test('formattedPrice should return price formatted as Rp', () {
      final product = Product(name: 'keyboard', category: 'electronics', price: 150000.99);
      expect(product.formattedPrice, 'Rp 150001'); // karena toStringAsFixed(0)
    });

    test('addStock should increase stock', () {
      final product = Product(name: 'monitor', category: 'electronics', price: 3000000);
      product.addStock(5);
      expect(product.stock, 5);
      product.addStock(3);
      expect(product.stock, 8);
    });

    test('addStock should ignore zero or negative values', () {
      final product = Product(name: 'monitor', category: 'electronics', price: 3000000);
      product.addStock(-2);
      expect(product.stock, 0);
      product.addStock(0);
      expect(product.stock, 0);
    });

    test('reduceStock should reduce stock if quantity is valid', () {
      final product = Product(name: 'Hard Drive', category: 'Electronics', price: 800000);
      product.addStock(10);
      final result = product.reduceStock(4);
      expect(result, true);
      expect(product.stock, 6);
    });

    test('reduceStock should not reduce stock if quantity is invalid', () {
      final product = Product(name: 'Hard Drive', category: 'Electronics', price: 800000);
      product.addStock(5);

      expect(product.reduceStock(0), false);
      expect(product.reduceStock(-1), false);
      expect(product.reduceStock(10), false);
      expect(product.stock, 5); // stock should not change
    });

    test('toString should return formatted string', () {
      final product = Product(name: 'SSD', category: 'Electronics', price: 1200000);
      product.addStock(3);
      expect(product.toString(), 'ssd - electronics - Rp 1200000 (Stock: 3)');
    });
  });
}
