class Flower {
  final String id;
  final String name;
  final double price;
  final String imagePath;
  final String description;
  final String category;

  Flower({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.description,
    required this.category,
  });

  factory Flower.fromJson(Map<String, dynamic> json) {
    return Flower(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      imagePath: json['imagePath'],
      description: json['description'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imagePath': imagePath,
      'description': description,
      'category': category,
    };
  }
}
