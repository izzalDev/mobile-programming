import 'package:assignment_1/product.dart';
import 'package:assignment_1/product_catalog.dart';
import 'package:test/test.dart';

void main() {
  group('ProductCatalog', () {
    late ProductCatalog catalog;
    final p1 = Product(
      name: 'Laptop',
      category: 'Electronics',
      price: 20_000_000,
    );
    final p2 = Product(name: 'Mouse', category: 'Electronics', price: 15_000);
    final p3 = Product(
      name: 'Buku Dart',
      category: 'Buku',
      price: 150_000,
      stock: 50,
    );
    setUp(() {
      catalog = ProductCatalog();
    });

    test("should add a product to the catalog", () {
      catalog.addProduct(p1);
      expect(catalog.products.length, 1);
      expect(catalog.products[0], p1);
    });

    test("getProductsByCategory should return correct filtered list", () {
      catalog
        ..addProduct(p1)
        ..addProduct(p2)
        ..addProduct(p3);
      final result = catalog.getProductsByCategory(p1.category);
      expect(result.length, 2);
    });

    test("getAllProducts should return all added products", () {
      catalog
        ..addProduct(p1)
        ..addProduct(p2);
      final all = catalog.getAllProducts();
      expect(all.length, 2);
    });

    test("getAvailableProducts should return only products with stock > 0", () {
      catalog
        ..addProduct(p1)
        ..addProduct(p2)
        ..addProduct(p3);
      final availableProducts = catalog.getAvailableProducts();
      expect(availableProducts.length, 1);
      expect(availableProducts.first.name, p3.name);
    });

    test("searchProducts should find products by name or category", () {
      catalog
        ..addProduct(p1)
        ..addProduct(p2)
        ..addProduct(p3);
      final resultByName = catalog.searchProducts(p2.name);
      final resultByCategory = catalog.searchProducts(p2.category);
      expect(resultByName.length, 1);
      expect(resultByCategory.length, 2);
    });

    test("getCategories should return list of categories", () {
      catalog
        ..addProduct(p1)
        ..addProduct(p2)
        ..addProduct(p3);
      final categories = catalog.getCategories();
      expect(categories.length, 2);
      expect(categories, containsAll(['electronics', 'buku']));
    });

    test('display methods should not throw errors', () {
      expect(() => catalog.displayAllProducts(), returnsNormally);
      catalog
        ..addProduct(p1)
        ..addProduct(p2)
        ..addProduct(p3);
      expect(() => catalog.displayAllProducts(), returnsNormally);
      expect(() => catalog.displayByCategory(), returnsNormally);
      expect(() => catalog.displaySummary(), returnsNormally);
    });
  });
}
