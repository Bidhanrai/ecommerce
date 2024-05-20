import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:shoes_ecommerce/features/review/widget/review_card.dart';
import '../../constants/app_colors.dart';
import 'model/review.dart';

class ReviewView extends StatefulWidget {
  final List<Review> allReview;

  const ReviewView({
    super.key,
    required this.allReview,
  });

  @override
  State<ReviewView> createState() => _ReviewViewState();
}

class _ReviewViewState extends State<ReviewView> {


  List<Review> selectedReview = [];
  int _currentIndex = 0;
  selectTab(int reviewStar) {
    _currentIndex = reviewStar;
    setState(() {
      if(reviewStar == 0) {
        selectedReview = widget.allReview;
      } else {
        selectedReview = widget.allReview.where((element) => element.reviewStar == reviewStar).toList();
      }
    });
  }


  @override
  void initState() {
    selectTab(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Review (${widget.allReview.length})"),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColor.yellow),
                      const SizedBox(width: 4),
                      Text("$averageRatings", style: const TextStyle(fontWeight: FontWeight.w700),),
                    ],
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 40,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    children: [
                      _tab("All", 0),
                      _tab("5 Stars", 5),
                      _tab("4 Stars", 4),
                      _tab("3 Stars", 3),
                      _tab("2 Stars", 2),
                      _tab("1 Stars", 1),
                    ],
                  ),
                ),
                Expanded(child: _reviewList()),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _tab(String title, int reviewStar) {
    return InkWell(
      onTap: () {
        selectTab(reviewStar);
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: reviewStar == _currentIndex
                  ? AppColor.black
                  : AppColor.lightGrey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _reviewList() {
    return selectedReview.isNotEmpty
        ? ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            separatorBuilder: (context, index) => const SizedBox(height: 32),
            itemCount: selectedReview.length,
            itemBuilder: (context, index) {
              return ReviewCard(
                review: selectedReview[index],
              );
            },
          )
        : const Center(
            child: Text(
              "No ratings!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
  }

  double get averageRatings {
    List<int> ratings = widget.allReview.map((e) => e.reviewStar).toList();
    return ratings.sum/ratings.length;
  }
}
