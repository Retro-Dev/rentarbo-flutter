import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Extensions/colors_utils.dart';
import 'Const.dart';

class SimpleEditText extends StatefulWidget {
  Function(String?)? onChange, onSaved;
  String? Function(String?)? validator;
  final String? hintText, errorText, prefixIcon, suffixIcon, fontFamily;
  IconData? icon, prefixiconData;
  bool setEnable, showBorder;
  bool obscure;
  bool isDropDown, isPassword, isFilled, isLabelHidden, readOnly;
  Color filledColor, borderColor;
  TextInputAction? textInputAction;
  TextInputType? textInputType;
  List<TextInputFormatter>? inputFormatter;
  FocusNode? currentFocus, nextFocus;
  BuildContext context;
  Function(String)? onFieldSubmitted;
  TextEditingController? controller;
  VoidCallback? suffixClick;
  int? maxLines, maxLength;
  String? value;
  VoidCallback? ONTAP;

  SimpleEditText({
    required this.context,
    this.value,
    this.onChange,
    this.hintText,
    this.errorText,
    this.icon,
    this.prefixiconData,
    this.prefixIcon,
    this.suffixIcon,
    this.fontFamily,
    this.onSaved,
    this.validator,
    this.setEnable = true,
    this.obscure = false,
    this.isDropDown = false,
    this.isPassword = false,
    this.showBorder = true,
    this.isFilled = false,
    this.isLabelHidden = false,
    this.filledColor = const Color(0x0f0a3746),
    this.borderColor = const Color(0x0f0a3746),
    this.currentFocus,
    this.nextFocus,
    this.textInputAction,
    this.textInputType,
    this.inputFormatter,
    this.onFieldSubmitted,
    this.controller,
    this.suffixClick,
    this.maxLength,
    this.maxLines = 1,
    this.ONTAP,
    this.readOnly = false,
  });

  @override
  State<SimpleEditText> createState() => _SimpleEditTextState();
}

class _SimpleEditTextState extends State<SimpleEditText> {
  @override
  Widget build(BuildContext context) {
    //this.context = context;
    return TextFormField(
      validator: widget.validator,
//      autovalidate: true,
      controller: widget.controller,
      enabled: widget.setEnable,
      onChanged: (val) {
        setState(() {
          if (val != null && val.length > 0) {
            widget.value = val;
            if (widget.onChange != null) widget.onChange!(val);
          } else
            widget.value = null;
        });
      },
      onSaved: widget.onSaved,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
//      autofocus: true,
      focusNode: widget.currentFocus,
      textInputAction: widget.textInputAction,
      keyboardType: widget.textInputType,
      inputFormatters: widget.inputFormatter,
      obscureText: widget.obscure,
      readOnly: widget.readOnly,
//      cursorColor: accentColor,
      style: TextStyle(
        height: 1.2,
        fontSize: 16,
        color: Colors.black,
        fontFamily: Const.aventaBold,
      ),
      textAlignVertical: TextAlignVertical.center,
      onTap: widget.ONTAP,
      //textAlign: TextAlign.justify,
      onFieldSubmitted: widget.onFieldSubmitted ??
              (value) {
            _fieldFocusChange(widget.currentFocus, widget.nextFocus);
          },
      decoration: InputDecoration(
        isCollapsed: widget.prefixIcon != null ||
            widget.prefixiconData != null ||
            widget.suffixIcon != null,
        contentPadding: EdgeInsets.all(10),
        hintText: widget.hintText,
        // filled: this.widget.isFilled,
        // fillColor: this.widget.filledColor,
        filled: true,
        fillColor: Color(0x0f0a3746),
        // prefixStyle: TextStyle(color: Colors.blue, fontSize: 16),
        labelStyle: TextStyle(
            fontFamily: Const.aventaBold,
            color: Color.fromARGB(255, 69, 79, 99),
            fontSize: 16,
            height: 1.2),
        // labelText: this.widget.isLabelHidden ? null : this.widget.hintText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        // labelStyle: TextStyle(color: Colors.black),
        hintStyle: TextStyle(
            fontFamily: Const.aventaBold,
            color: ColorUtils.slate.withOpacity(0.5),
            fontSize: 16.sp),
        suffixIcon: widget.isPassword
            ? IconButton(
          splashColor: Colors.transparent,
          icon: Icon(widget.icon),
          color: Color(0xff7c849c),
          onPressed: widget.suffixClick,
        )
            : widget.isDropDown
            ? SizedBox(
          width: 0,
          height: 15,
          child: Image.asset(
            widget.suffixIcon!,
            scale: 2.5,
          ),
        )
            : widget.suffixIcon != null
            ? GestureDetector(
          onTap: widget.suffixClick,
          child: Image.asset(
            widget.suffixIcon!,
            scale: 2.5,
            color: Colors.black,
          ),
        )
            : null,
        prefixIcon: widget.prefixiconData != null
            ? Icon(
          widget.prefixiconData,
          color: Color(0xff838EA9),
          size: 20,
        )
            : widget.prefixIcon != null
            ? Image.asset(
          widget.prefixIcon!,
          scale: 2.5,
        )
            : null,
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: this.widget.borderColor),
            borderRadius: BorderRadius.circular(18)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: this.widget.borderColor),
            borderRadius: BorderRadius.circular(18)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: this.widget.borderColor),
            borderRadius: BorderRadius.circular(18)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: this.widget.borderColor),
            borderRadius: BorderRadius.circular(18)),
      ),
    );
  }

  _fieldFocusChange(
      /*BuildContext context,*/ FocusNode? currentFocus, FocusNode? nextFocus) {
    currentFocus?.unfocus();
    if (nextFocus != null)
      FocusScope.of(widget.context).requestFocus(nextFocus);
  }
}
