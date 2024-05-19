import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable{
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final String brand;
  final List<int> size;
  final List<String> color;
  final int price;
  final Gender gender;
  final DateTime createdDate;
  final int averageStar;
  final int totalReviewCount;

  const Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.brand,
    required this.size,
    required this.color,
    required this.price,
    required this.gender,
    required this.createdDate,
    this.averageStar = 0,
    this.totalReviewCount = 0,
  });


  factory Product.fromJson(Map<dynamic, dynamic> doc) {
    return Product(
      id: doc["id"],
      name: doc["name"],
      imageUrl: doc["imageUrl"],
      description: doc["description"],
      brand: doc["brand"],
      size: (doc["size"] as List).map((e) => int.parse("$e")).toList(),
      createdDate: DateTime.parse(doc["createdDate"]),
      gender: doc["gender"] == "M"
          ? Gender.m
          : doc["gender"] == "F"
          ? Gender.f
          : Gender.u,
      price: doc["price"],
      color: (doc["color"] as List).map((e) => "$e").toList(),
      averageStar: doc["averageStar"]??0,
      totalReviewCount: doc["totalReviewCount"]??0,
    );
  }

  factory Product.fromDocumentSnapshot(DocumentSnapshot<Map<dynamic, dynamic>> doc) {
    return Product(
      id: doc.data()!["id"],
      name: doc.data()!["name"],
      imageUrl: doc.data()!["imageUrl"],
      description: doc.data()!["description"],
      brand: doc.data()!["brand"],
      size: (doc.data()!["size"] as List).map((e) => int.parse("$e")).toList(),
      createdDate: DateTime.parse(doc.data()!["createdDate"]),
      gender: doc.data()!["gender"] == "M"
          ? Gender.m
          : doc.data()!["gender"] == "F"
              ? Gender.f
              : Gender.u,
      price: doc.data()!["price"],
      color: (doc.data()!["color"] as List).map((e) => "$e").toList(),
      averageStar: doc.data()!["averageStar"]??0,
      totalReviewCount: doc.data()!["totalReviewCount"]??0,
    );
  }

  @override
  List<Object?> get props => [id, name, description, brand, createdDate, gender, price, color, size, imageUrl, averageStar, totalReviewCount];
}

enum Gender {
  m("Male"),
  f("Female"),
  u("Unisex");

  final String value;
  const Gender(this.value);
}
