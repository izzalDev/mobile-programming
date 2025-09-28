class Product {
  String name;
  String category;
  double price;
  int stock;

  Product({
    required String name,
    required String category,
    required this.price,
    this.stock = 0,
  }) : name = name.toLowerCase(),
       category = category.toLowerCase();

  factory Product.create(String name, String category, double price) {
    return Product(
      name: name,
      category: category,
      price: price,
    );
  }

  bool get isAvailable => stock > 0;

  String get formattedPrice => 'Rp ${price.toStringAsFixed(0)}';

  void addStock(int quantity) {
    if (quantity > 0) {
      stock += quantity;
    }
  }

  bool reduceStock(int quantity) {
    if (quantity > 0 && quantity <= stock) {
      stock -= quantity;
      return true;
    }
    return false;
  }

  @override
  String toString() {
    return '$name - $category - $formattedPrice (Stock: $stock)';
  }
}
