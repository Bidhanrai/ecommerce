import 'package:flutter/material.dart';
import 'package:shoes_ecommerce/features/review/model/review.dart';
import '../../../constants/app_colors.dart';
import '../../../utils/time_ago.dart';
import 'ratings_widget.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      review.userId,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    formatToTimeAgo(DateTime.now()),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColor.lightGrey,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: RatingsWidget(
                  ratings: review.reviewStar,
                ),
              ),
              Text(
                review.reviewText,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
