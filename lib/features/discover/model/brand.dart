import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Brand extends Equatable {
  final String id;
  final String name;
  final String image;

  const Brand({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Brand.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Brand(
      id: doc.id,
      name: doc.data()!["name"],
      image: doc.data()!["imageUrl"],
    );
  }

  @override
  List<Object?> get props => [id, name, image];
}
