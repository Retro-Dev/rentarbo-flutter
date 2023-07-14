import 'package:flutter/material.dart';

class Style {
  static getRegularFont(double fontSize, {Color color = Style.textBlackColor}) {
    return TextStyle(fontSize: fontSize, color: color);
  }

  static getMediumFont(double fontSize, {Color color = Style.textBlackColor}) {
    return TextStyle(
        fontSize: fontSize, color: color, fontWeight: FontWeight.w500);
  }

  static getSemiBoldFont(double fontSize,
      {Color color = Style.textBlackColor}) {
    return TextStyle(
        fontSize: fontSize, color: color, fontWeight: FontWeight.w600);
  }

  static getBoldFont(double fontSize, {Color color = Style.textBlackColor}) {
    return TextStyle(
        fontSize: fontSize, color: color, fontWeight: FontWeight.bold);
  }

  static getIconImage(String imageName, {ImageSize size = ImageSize.oneX}) {
    switch (size) {
      case ImageSize.oneX:
        return "assets/images/icons/$imageName";
      case ImageSize.twoX:
        return "assets/images/icons/2.0.x/$imageName";
      case ImageSize.threeX:
        return "assets/images/icons/3.0.x/$imageName";
    }
  }

  static getLogoImage(String imageName, {ImageSize size = ImageSize.oneX}) {
    switch (size) {
      case ImageSize.oneX:
        return "assets/images/logos/$imageName";
      case ImageSize.twoX:
        return "assets/images/logos/2.0.x/$imageName";
      case ImageSize.threeX:
        return "assets/images/logos/3.0.x/$imageName";
    }
  }

  static getCommonImage(String imageName, {ImageSize size = ImageSize.oneX}) {
    switch (size) {
      case ImageSize.oneX:
        return "assets/images/common/$imageName";
      case ImageSize.twoX:
        return "assets/images/common/2.0.x/$imageName";
      case ImageSize.threeX:
        return "assets/images/common/3.0.x/$imageName";
    }
  }

  static getTempImage(String imageName) {
    return "assets/images/temp/$imageName";
  }

  static const textBlackColor = Color(0xFF1F1F1F);
  static final textBlackColorOpacity80 = Color(0xFF1F1F1F).withOpacity(0.8);
  static const redColor = Color(0xFFFF0037);
  static const textWhiteColor = Color(0xFFFFFFFF);
  static const btnGreyColor = Color(0xFF78849E);
  static final thankYouBaclgroundColor = Color(0xFF363E51).withOpacity(0.9);
  static const blueColor = Color(0xFF408BF9);
  static const lightGreenColor = Color(0xFF70CE01);

 static OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: const BorderSide(
      color: Color(0xFFF7F7F7),
    ),
  );
}

enum ImageSize { oneX, twoX, threeX }
