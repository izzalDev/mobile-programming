import 'package:assignment_2/product.dart';

class ProductCatalog {
  List<Product> products = [];

  void addProduct(Product newProduct) {
    products.add(newProduct);
  }

  List<Product> getAllProducts() {
    return products;
  }

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
