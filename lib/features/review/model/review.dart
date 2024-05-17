import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String id;
  final int reviewStar;
  final String reviewText;
  final DateTime createdDate;
  final String userId;
  final String productId;

  const Review({
    required this.id,
    required this.reviewStar,
    required this.reviewText,
    required this.createdDate,
    required this.productId,
    required this.userId,
  });

  factory Review.fromJson(Map<String, dynamic> doc) {
    return Review(
      id: doc["id"],
      productId: doc["productId"],
      createdDate: (doc["createdDate"] as Timestamp).toDate(),
      reviewStar: doc["reviewStar"],
      reviewText: doc["reviewText"],
      userId: doc["userId"],
    );
  }

  @override
  List<Object?> get props => [id, userId, productId, reviewText, reviewStar, createdDate];
}
