import 'package:assignment_1/product.dart';

class ProductCatalog {
  List<Product> products = [];

  void addProduct(Product product) {
    products.add(product);
  }

  List<Product> getAllProducts() {
    return products;
  }

  List<Product> getProductsByCategory(String category) {
    return products.where((product) {
      return product.category.toLowerCase() == category.toLowerCase();
    }).toList();
  }

  List<Product> getAvailableProducts() {
    return products.where((product) => product.isAvailable).toList();
  }

  List<Product> searchProducts(String keyword) {
    final searchKeyword = keyword.toLowerCase();
    return products.where((product) {
      final productName = product.name.toLowerCase();
      final productCategory = product.category.toLowerCase();
      final isNameMatch = productName.contains(searchKeyword);
      final isCategoryMatch = productCategory.contains(searchKeyword);
      return isNameMatch || isCategoryMatch;
    }).toList();
  }

  List<String> getCategories() {
    Set<String> categorySet = {};
    for (Product product in products) {
      categorySet.add(product.category);
    }
    return categorySet.toList()..sort();
  }

  void displayAllProducts() {
    print('\n=== SEMUA PRODUK ===');
    if (products.isEmpty) {
      print('Tidak ada produk tersedia');
      return;
    }

    for (int i = 0; i < products.length; i++) {
      print('${i + 1}. ${products[i]}');
    }
  }

  void displayByCategory() {
    print('\n=== PRODUK BY KATEGORI ===');
    List<String> categories = getCategories();
    for (String category in categories) {
      print('\n$category:');
      List<Product> categoryProducts = getProductsByCategory(category);
      for (Product product in categoryProducts) {
        String status = product.isAvailable ? 'Tersedia' : 'Habis';
        print('  - ${product.name} - ${product.formattedPrice} - $status');
      }
    }
  }

  void displaySummary() {
    print('\n=== RINGKASAN INVENTORI ===');
    print('Total Produk: ${products.length}');
    print('Total Kategori: ${getCategories().length}');
    print('Produk Tersedia: ${getAllProducts().length}');
    print('Produk Habis: ${products.length - getAvailableProducts().length}');
  }
}
