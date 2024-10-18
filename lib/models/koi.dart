class Koi {
  final int id;
  final String name;
  final String sex;
  final double length;
  final int age;
  final double basePrice;
  final String statusName;
  final bool isDisplay;
  final String thumbnail;
  final String description;
  final int ownerId;
  final int categoryId;

  Koi({
    required this.id,
    required this.name,
    required this.sex,
    required this.length,
    required this.age,
    required this.basePrice,
    required this.statusName,
    required this.isDisplay,
    required this.thumbnail,
    required this.description,
    required this.ownerId,
    required this.categoryId,
  });

  // Factory method to create a Koi instance from a JSON object
  factory Koi.fromJson(Map<String, dynamic> json) {
    return Koi(
      id: json['id'],
      name: json['name'],
      sex: json['sex'],
      length: (json['length'] as num).toDouble(), // Convert to double
      age: json['age'],
      basePrice: (json['base_price'] as num).toDouble(), // Convert to double
      statusName: json['status_name'],
      isDisplay: json['is_display'] == 1, // Convert to bool
      thumbnail: json['thumbnail'],
      description: json['description'],
      ownerId: json['owner_id'],
      categoryId: json['category_id'],
    );
  }
}
