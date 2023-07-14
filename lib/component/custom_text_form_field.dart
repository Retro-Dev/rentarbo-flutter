import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Extensions/style.dart';

class CustomTextField extends StatefulWidget {
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final TextEditingController controller;
  final bool? enabled;
  final FocusNode? node;
  final String? hint;
  final double? width;
  final bool? isPass;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? initialValue;

  final FormFieldValidator? validatorFtn;
  final Function? onEditComplete;
  final Function(String)? onFieldSubmit;
  final String? errorText;
  final String Function(String?)? onChangeFtn;

  const CustomTextField({
    Key? key,
    this.enabled,
    this.initialValue,
    this.validatorFtn,
    this.onEditComplete,
    this.onChangeFtn,
    this.onFieldSubmit,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPass = false,
    this.width = double.infinity,
    this.textInputAction = TextInputAction.done,
    this.node,
    required this.controller,
    required this.hint,
    required this.textInputType,
  }) : super(key: key);

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool showPass = true;
  _showPass() {
    setState(() {
      showPass = !showPass;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        enabled: widget.enabled ?? true,
        initialValue: widget.initialValue,
        controller: widget.controller,
        autofocus: false,
        obscureText: widget.isPass! ? showPass : false,
        textInputAction: widget.textInputAction,
        keyboardType: widget.textInputType,
        autocorrect: false,
        focusNode: widget.node,
        decoration: InputDecoration(
          errorText: widget.errorText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: Padding(
            padding: const EdgeInsets.all(6.0),
            child: SizedBox(
              height: 12.h,
              width: 12.w,
              child: widget.suffixIcon),
          ),
          filled: true,
          contentPadding: const EdgeInsets.all(8.0),
          hintText: widget.hint,
          hintStyle: Style.getRegularFont(14.sp,color: Style.textBlackColor),
          enabledBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Color(0xFFF7F7F7),
            ),
          ),
          focusedBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Color(0xFFF7F7F7),
            ),
          ),
          errorBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Color(0xFFF7F7F7),
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Color(0xFFF7F7F7),
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color:  Color(0xFFF7F7F7),
            ),
          ),
        ),
        validator: widget.validatorFtn,
        onChanged: widget.onChangeFtn,
      ),
    );
  }
}