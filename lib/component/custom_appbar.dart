import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Extensions/style.dart';

class CustomAppBar extends StatelessWidget {
  final String appBarTitle;
  const CustomAppBar({Key? key, required this.appBarTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 30,
      titleSpacing: 10,
      centerTitle: false,
      title: Text(
        appBarTitle,
        style: Style.getBoldFont(
          18.sp,
        ),
      ),
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            height: 24.h,
            width: 24.w,
            child: Image.asset(
              "src/backimg@3x.png",
            ),
          ),
        ),
      ),
    );
  }
}
