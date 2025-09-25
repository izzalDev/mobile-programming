class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final List<String> categories;
  final bool isAvailable;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.categories = const [],
    this.isAvailable = true,
  });

  String getDisplayPrice() {
    return 'Rp ${price.toStringAsFixed(0)}';
  }

	bool isInCategory(String category){
		return categories.contains(category.toLowerCase());
	}
}
