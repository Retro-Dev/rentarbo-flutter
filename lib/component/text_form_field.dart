import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../utils/style.dart';

class CustomTextFormField extends StatelessWidget {
  String hintText;
  double hintFontSize = 16;
  TextInputType keyboardType = TextInputType.none;
  TextInputAction textInputAction = TextInputAction.done;
  TextEditingController? editingController; // = TextEditingController();
  void Function()? onEditingComplete;
  void Function(String)? onFieldSubmitted;
  String? Function(String?)? validator;
  String value = "";
  FocusNode focusNode;
  bool isSecure = false;
  bool isCentered = false;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  CustomTextFormField({
    Key? key,
    required this.hintText,
    required this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.hintFontSize = 16,
    this.isSecure = false,
    this.isCentered = false,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.editingController,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
        return CustomTextFormFieldProvided(
          hintText: hintText,
          hintFontSize: hintFontSize,
          keyboardType: keyboardType,
          focusNode: focusNode,
          isSecure: isSecure,
          isCentered: isCentered,
          textInputAction: textInputAction,
          onEditingComplete: onEditingComplete,
          editingController: editingController,
          //validator: validator,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        );
  }
}

class CustomTextFormFieldProvided extends StatelessWidget {
  String hintText;
  double hintFontSize = 16;
  TextInputType keyboardType = TextInputType.none;
  TextInputAction textInputAction = TextInputAction.done;
  TextEditingController? editingController; // = TextEditingController();
  void Function()? onEditingComplete;
  void Function(String)? onFieldSubmitted;
  String? Function(String?)? validator;
  CustomTextFormFieldManager? manager;
  String value = "";
  FocusNode focusNode;
  bool isSecure = false;
  bool isCentered = false;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  CustomTextFormFieldProvided({
    Key? key,
    required this.hintText,
    this.hintFontSize = 16,
    required this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.isSecure = false,
    this.isCentered = false,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.editingController,
    this.validator,
  }) : super(key: key) {
    editingController?.addListener(onTextEdit);
    focusNode.addListener(() {
      manager!.setFocused(focusNode.hasFocus);
    });
  }

  void onTextEdit() {
    value = editingController?.text ?? "";
    value == "" ? manager!.setEmpty() : manager!.setFilled();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // ignore: prefer_const_constructors
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(14.0)),
          color: const Color(0xFFF7F7F7)
        // border: Border.all(
        //     width: manager!.focused == true ? 0 : 1,
        //     color: manager!.focused == true
        //         ? const Color(0x42465D81)
        //         : const Color(0xFF42465D))
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 2.w),
        child: SizedBox(
          height: 40.w,
          child: TextFormField(
            focusNode: focusNode,
            //autovalidateMode: AutovalidateMode.always,
            textAlign: isCentered ? TextAlign.center : TextAlign.start,
            style: Style.getSemiBoldFont(
              16.sp,
            ),
            decoration: InputDecoration(
              errorStyle: const TextStyle(
                fontSize: 11.0,
              ),
              filled: false,
              border: InputBorder.none,
              //                focusedBorder: InputBorder.none,
              //         disabledBorder: InputBorder.none,
              hintText: hintText,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: prefixIcon,
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: suffixIcon,
              ),
              hintStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: hintFontSize,
                  textBaseline: TextBaseline.ideographic,
                  color: const Color(0xFF42465D)),
              // suffixIcon:  GestureDetector(
              //         behavior: HitTestBehavior.opaque,
              //         onTap: () {
              //           manager!.setObscure(!manager!.obscure);
              //         },
              //         child: Icon(
              //             manager!.obscure
              //                 ? Icons.visibility_off
              //                 : Icons.visibility,
              //             color: Colors.white38),
              //       )
            ),
            obscureText: manager!.obscure,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            controller: editingController,
            validator: validator,
            onFieldSubmitted: onFieldSubmitted,
            onEditingComplete: onEditingComplete,
          ),
        ),
      ),
    );
  }
}

class CustomTextFormFieldManager extends ChangeNotifier {
  bool focused = false;
  bool empty = true;
  bool obscure = false;

  CustomTextFormFieldManager(this.obscure);

  setEmpty() {
    empty = true;
    notifyListeners();
  }

  setFilled() {
    empty = false;
    notifyListeners();
  }

  setFocused(focus) {
    focused = focus;
    notifyListeners();
  }

  setObscure(obs) {
    obscure = obs;
    notifyListeners();
  }
}
