import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Extensions/style.dart';
import '../Utils/Const.dart';

class CustomOutlineButton extends StatelessWidget {
  final String btnText;
  final VoidCallback onPressed;
  final double? radius;
  final double? width;
  final Color color;
  final double? height;
  final double?fontSize;
  final TextStyle? fontstyle;
   CustomOutlineButton(
      {Key? key,
      required this.btnText,
      this.radius = 25,
      this.width = 160,
      this.height = 55,
      this.fontSize = 18,
      this.color = Style.redColor,
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
      child: DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(color: color),
            borderRadius:  BorderRadius.all(Radius.circular(radius ?? 0)),
            color: Colors.transparent),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius!))),
            onPressed: onPressed,
            child: Text(btnText,
                style: fontstyle)),
      ),
    );
  }
}
