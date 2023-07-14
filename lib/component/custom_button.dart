import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Extensions/style.dart';
import '../Utils/Const.dart';

class CustomButton extends StatelessWidget {
  final String btnText;
  final Color color;
  final VoidCallback onPressed;
  final double? radius;
  final double? width;
  final double? height;
  final double? fontSize;
  final Color fontColor;
  final TextStyle? fontstyle;
   CustomButton(
      {Key? key,
      required this.btnText,
      this.color = Style.redColor,
      this.radius = 20,
      this.width = 160,
      this.height = 55,
      this.fontSize = 18,
      this.fontColor = Colors.white,
        this.fontstyle =  const TextStyle(
          color:  Colors.white,
          fontWeight: FontWeight.w800,
          fontFamily: Const.aventaBold,
          fontStyle:  FontStyle.normal,
          fontSize: 15,
        ),
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: color,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius!))),
          onPressed: onPressed,
          child: Text(btnText,
              style: fontstyle,)
    ));
  }
}


double getFileSize(File file){
  int sizeInBytes = file.lengthSync();
  double sizeInMb = sizeInBytes / (1024 * 1024);
  return sizeInMb;
}

//Alternatively for extension:

extension FileUtils on File {
  get size {
    int sizeInBytes = this.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    return sizeInMb;
  }
}
