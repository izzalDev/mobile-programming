import 'package:assignment_2/product.dart';

class ProductCatalog {
  List<Product> products = [];

  void addProduct(Product product) {
    products.add(product);
    print('Product "${product.name}" berhasil ditambahkan');
  }

  List<Product> getAllProducts() {
    return products;
  }

  List<Product> getProductsByCategory(String category) {
    return products
        .where((product) =>
            product.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  List<Product> getAvailableProducts() {
    return products.where((product) => product.isAvailable).toList();
  }

  List<Product> searchProducts(String keyword) {
    return products
        .where((product) =>
            product.name.toLowerCase().contains(keyword.toLowerCase()) ||
            product.category.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }

  List<String> getCategories() {
    Set<String> categorySet = {};
    for (Product product in products) {
      categorySet.add(product.category);
    }
    return categorySet.toList()..sort();
  }

	void displayAllProducts(){}

  void displayAllProducts() {
    if (products.isEmpty) {
      print("Belum ada produk ditambahkan");
      return;
    }

    print("Tampilkan Semua Product");
    for (Product product in products) {
      print(product);
    }
  }
}
