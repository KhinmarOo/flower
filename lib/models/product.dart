class Product {
  final int? id;
  final String name;
  final int price;
  final String image_url;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.image_url,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name']??'',
      price: json['price']??0,
      image_url: json['image_url']??'',
    );
  }
}