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
  final String gender;
  final DateTime createdDate;

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
  });


  factory Product.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Product(
      id: doc.id,
      name: doc.data()!["name"],
      imageUrl: doc.data()!["imageUrl"],
      description: doc.data()!["description"],
      brand: doc.data()!["brand"],
      size: (doc.data()!["size"] as List).map((e) => int.parse("$e")).toList(),
      createdDate: (doc.data()!["createdDate"] as Timestamp).toDate(),
      gender: doc.data()!["gender"],
      price: doc.data()!["price"],
      color: (doc.data()!["color"] as List).map((e) => "$e").toList(),
    );
  }

  @override
  List<Object?> get props => [id, name, description, brand, createdDate, gender, price, color, size, imageUrl];
}
