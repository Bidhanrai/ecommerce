import 'package:flutter/material.dart';
import 'package:shoes_ecommerce/widgets/svg_widget.dart';
import '../constants/app_colors.dart';
import '../widgets/primary_button.dart';
import 'discover/model/brand.dart';


class FilterView extends StatefulWidget {
  const FilterView({super.key});

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  
  List<Brand> brands = [
    const Brand(name: "Nike", image: "assets/icons/brands/Nike.svg", id: "1"),
    const Brand(name: "Puma", image: "assets/icons/brands/Nike.svg", id: "1"),
    const Brand(name: "Adidas", image: "assets/icons/brands/adidas.svg", id: "1"),
    const Brand(name: "Reebok", image: "assets/icons/brands/reebok.svg", id: "1"),
  ];

  List<String> sortByList = [
    "Most recent",
    "Lowest price",
    "Highest price",
  ];

  List<String> genderList = [
    "Main",
    "Woman",
    "Unisex",
  ];

  List<Color> colorList = [
    AppColor.black,
    Colors.white,
    AppColor.red,
  ];
  getColorText(Color color) {
    switch(color) {
      case AppColor.black:
        return "Black";
      case AppColor.red:
        return "Red";
      case Colors.white:
        return "White";
    }
  }

  var selectedRange = const RangeValues(100, 2000);

  Brand? selectedBrand;
  selectBrand(Brand brand) {
    setState(() {
      selectedBrand = brand;
    });
  }

  String? selectedSortBy;
  selectSortBy(String value) {
    setState(() {
      selectedSortBy = value;
    });
  }

  String? genderSelected;
  selectGender(String value) {
    setState(() {
      genderSelected = value;
    });
  }

  Color? selectedColor;
  selectColor(Color value) {
    setState(() {
      selectedColor = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12).copyWith(bottom: 100),
        children: [
          _title("Brands"),
          _brandFilter(),

          const SizedBox(height: 28),

          _title("Price Range"),
          _priceRangeFilter(),

          const SizedBox(height: 28),

          _title("Sort By"),
          _sortByFilter(),

          const SizedBox(height: 28),

          _title("Gender"),
          _genderFilter(),

          const SizedBox(height: 28),

          _title("Color"),
          _colorFilter(),

          const SizedBox(height: 28),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _actionButton(),
    );
  }


  Widget _title(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _brandFilter() {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(width: 32),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: brands.length,
        itemBuilder: (context, index) {
          Brand brand = brands[index];
          return GestureDetector(
            onTap: () {
              selectBrand(brand);
            },
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      height: 54,
                      width: 54,
                      margin: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: AppColor.lightGrey2,
                        shape: BoxShape.circle,
                      ),
                      child: SvgWidget(svgPath: brand.image),
                    ),
                    selectedBrand == brand
                        ? Container(
                      height: 20,
                      width: 20,
                      decoration: const BoxDecoration(
                        color: AppColor.black,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 16,
                      ),
                    )
                        : const SizedBox(),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  brand.name.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text("100 items", style: TextStyle(color: AppColor.lightGrey, fontSize: 11),),

              ],
            ),
          );
        },),
    );
  }

  Widget _priceRangeFilter() {
    return RangeSlider(
      values: selectedRange,
      onChanged: (RangeValues rangeValue) {
        setState(() {
          selectedRange = rangeValue;
        });
      },
      min: 0,
      max: 2500,
      labels: RangeLabels("${selectedRange.start}", "${{selectedRange.end}}"),
      activeColor: AppColor.black,
    );
  }

  Widget _sortByFilter() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        scrollDirection: Axis.horizontal,
        itemCount: sortByList.length,
        itemBuilder: (context, index) {
          String sortBy = sortByList[index];
          bool isSelected = sortBy == selectedSortBy;
          return GestureDetector(
            onTap: () {
              selectSortBy(sortBy);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColor.black
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
                border: isSelected
                    ? null
                    : Border.all(color: AppColor.grey),
              ),
              alignment: Alignment.center,
              child: Text(
                sortBy,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: isSelected
                        ? Colors.white
                        : AppColor.black
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _genderFilter() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: genderList.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          String gender = genderList[index];
          bool isSelected = gender == genderSelected;
          return GestureDetector(
            onTap: () {
              selectGender(gender);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColor.black
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
                border: isSelected
                    ? null
                    : Border.all(color: AppColor.grey),
              ),
              alignment: Alignment.center,
              child: Text(
                gender,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: isSelected
                      ? Colors.white
                      : AppColor.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _colorFilter() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: colorList.length,
        separatorBuilder: (context, index)=> const SizedBox(width: 16),
        itemBuilder: (context, index) {
          Color color = colorList[index];
          bool isSelected = color == selectedColor;
          return GestureDetector(
            onTap: () {
              selectColor(color);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: isSelected
                    ? AppColor.black
                    : AppColor.grey,
                ),
              ),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: color == Colors.white
                          ? Border.all(
                        color: AppColor.grey,
                      )
                          : null,
                    ),
                  ),
                  Text(
                    getColorText(color),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _actionButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(-1, -1),
            spreadRadius: 0.1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Button.outlined(
              label: "RESET",
              onTap: () {},
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Button.primary(
              label: "APPLY",
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
