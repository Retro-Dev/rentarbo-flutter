import 'package:flutter/material.dart';
import '../utils/style.dart';

class RentalCategoryModel {
  String categoryName;
  String cateoryPrice;
  String categoryRating;
  String categoryImage;

  RentalCategoryModel(
      {required this.categoryImage,
        required this.categoryName,
        required this.cateoryPrice,
        required this.categoryRating});
}


class RentalCategoryViewModel  {
  final List<RentalCategoryModel> _categoriesList = [
    RentalCategoryModel(
        categoryImage: Style.getTempImage("rental_img_1.png"),
        categoryName: "Speedboat",
        cateoryPrice: "\$16/hr",
        categoryRating: "(4.4)"),
    RentalCategoryModel(
        categoryImage: Style.getTempImage("rental_img_2.png"),
        categoryName: "Jet Ski",
        cateoryPrice: "\$16/hr",
        categoryRating: "(4.4)"),
    RentalCategoryModel(
        categoryImage: Style.getTempImage("rental_img_3.png"),
        categoryName: "Jet Boat",
        cateoryPrice: "\$16/hr",
        categoryRating: "(4.4)"),
    RentalCategoryModel(
        categoryImage: Style.getTempImage("rental_img_4.png"),
        categoryName: "Jet Boat",
        cateoryPrice: "\$16/hr",
        categoryRating: "(4.4)"),
    RentalCategoryModel(
        categoryImage: Style.getTempImage("rental_img_1.png"),
        categoryName: "Speedboat",
        cateoryPrice: "\$16/hr",
        categoryRating: "(4.4)"),
    RentalCategoryModel(
        categoryImage: Style.getTempImage("rental_img_2.png"),
        categoryName: "Jet Ski",
        cateoryPrice: "\$16/hr",
        categoryRating: "(4.4)"),
    RentalCategoryModel(
        categoryImage: Style.getTempImage("rental_img_3.png"),
        categoryName: "Jet Boat",
        cateoryPrice: "\$16/hr",
        categoryRating: "(4.4)"),
    RentalCategoryModel(
        categoryImage: Style.getTempImage("rental_img_4.png"),
        categoryName: "Jet Boat",
        cateoryPrice: "\$16/hr",
        categoryRating: "(4.4)"),

  ];


  int getCategoriesCount() {
    return _categoriesList.length;
  }

  String getTitleForCategoryFor(int index) {
    return _categoriesList[index].categoryName;
  }

  String getImageForCategoryFor(int index) {
    return _categoriesList[index].categoryImage;
  }
  String getPriceForCategoryFor(int index) {
    return _categoriesList[index].cateoryPrice;
  }

  String getRatingForCategoryFor(int index) {
    return _categoriesList[index].categoryRating;
  }



// bool getSelectionForCategoryFor(int index) {
//   return _categoriesList[index].isSelected;
// }

// void setSelectionForCategoryFor(int index, bool selected) {
//   _categoriesList[index].isSelected = selected;
//   notifyListeners();
// }


}
