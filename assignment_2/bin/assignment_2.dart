import 'package:assignment_2/product.dart';

void main(List<String> arguments) {
  print("Selamat datang di pemrograman dart");
  Product product1 = Product(
    id: "1",
    name: "Asus ROG",
    categories: ["Laptop"],
    price: 20000000,
    imageUrl: "http:/image.url",
  );

  print(product1);
  print("Apakah ${product1.name} tersedia: ${product1.isAvailable}");
}
