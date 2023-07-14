import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Extensions/colors_utils.dart';
import '../Extensions/font_utils.dart';
import '../Utils/Const.dart';

Widget getSenderView(
    {CustomClipper? clipper, BuildContext? context, String? text}) =>
    ChatBubble(
      clipper: clipper,
      alignment: Alignment.topRight,
      margin: EdgeInsets.only(top: 20.h),
      backGroundColor: ColorUtils.slate.withOpacity(0.5),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context!).size.width * 0.7,
        ),
        child: Text(
          text.toString(),
          style: TextStyle(
              color: Colors.white,
              fontFamily: FontUtils.aventaSemiBold,
              fontSize: 12.sp,
              height: 1.5.h),
          textAlign: TextAlign.right,
        ),
      ),
    );

Widget getReceiverView(
    {CustomClipper? clipper, BuildContext? context, String? text}) =>
    ChatBubble(
      clipper: clipper,
      backGroundColor: Color(0xffE7E7ED),
      margin: EdgeInsets.only(top: 20.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context!).size.width * 0.7,
        ),
        child: Text(
          text.toString(),
          style: TextStyle(
              color: ColorUtils.txtColor,
              fontFamily: Const.aventaBold,
              fontSize: 12.sp,
              height: 1.5.h),
        ),
      ),
    );
