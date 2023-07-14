import 'package:flutter/material.dart';
import '../Models/HomeCategoryModel.dart';


import 'HomeCategoryModel.dart';

class HomeViewModel {
  late  List<HomeCategoryModel> _categoryModels = [
    HomeCategoryModel(label: "All", isSelected: true),
    HomeCategoryModel(label: "Boats", isSelected: false),
    HomeCategoryModel(label: "Jetski", isSelected: false),
    HomeCategoryModel(label: "Cars", isSelected: false),
    HomeCategoryModel(label: "Cycle", isSelected: false),
    HomeCategoryModel(label: "Motorcycle", isSelected: false),
    HomeCategoryModel(label: "Drone", isSelected: false),
    HomeCategoryModel(label: "Camera", isSelected: false),
  ];

 setData() {
   _categoryModels = [
     HomeCategoryModel(label: "All", isSelected: true),
     HomeCategoryModel(label: "Boats", isSelected: false),
     HomeCategoryModel(label: "Jetski", isSelected: false),
     HomeCategoryModel(label: "Cars", isSelected: false),
     HomeCategoryModel(label: "Cycle", isSelected: false),
     HomeCategoryModel(label: "Motorcycle", isSelected: false),
     HomeCategoryModel(label: "Drone", isSelected: false),
     HomeCategoryModel(label: "Camera", isSelected: false),
   ];
 }

  int getHomeCategoriesCount() {
    return _categoryModels.length;
  }

  String getHomeCategoryLabelFor(int index) {
    return _categoryModels[index].label;
  }

  bool getHomeCategorySelectedFor(int index) {
    return _categoryModels[index].isSelected;
  }

  setHomeCategorySelectedFor(int index, bool selected) {
    _categoryModels[index].isSelected = selected;
  }
}
