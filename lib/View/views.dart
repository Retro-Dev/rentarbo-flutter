import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import '../Utils/Const.dart';

import '../Extensions/style.dart';

class MyButtonWithgradient extends StatelessWidget {
  String text;
  Color? color;
  VoidCallback onPress;
  double height, circularRadius, width, fontsize;
  Widget? child;
  Color? startColor, endColor , textColor;

  MyButtonWithgradient({
    this.text = "No text given",
    required this.onPress,
    this.color,
    this.height = 52,
    this.width = 100,
    this.circularRadius = 15,
    this.child,
    this.fontsize = 16,
    this.startColor = const Color.fromARGB(255, 245, 175, 25),
    this.endColor = const Color.fromARGB(255, 241, 3, 17),
    this.textColor = const Color.fromRGBO(255, 255, 255, 1.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularRadius),
          // side: BorderSide(color: color ?? Theme.of(context).primaryColor),
        ),
        gradient: LinearGradient(
          colors: [startColor!, endColor!],

          //Color.fromARGB(255, 245, 175, 25)
          //Color.fromARGB(255, 241, 3, 17)
        ),
      ),
      child: MaterialButton(
        // color: color ?? Theme.of(context).primaryColor,
        height: height,
        minWidth: width,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularRadius),
          // side: BorderSide(color: color ?? Theme.of(context).primaryColor),
        ),
        onPressed: onPress,
        child: child ??
            Text(
              text,
              style: TextStyle(
                  fontFamily: "Avanta-LightItalic",
                  color: textColor,
                  fontSize: 14,
                  ),
            ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  String text;
  Color? color;
  Color? textcolor;
  Color? bordercolor;
  VoidCallback onPress;
  double height, circularRadius, width;
  Widget? child;

  MyButton(
      {this.text = "No text given",
        required this.onPress,
        this.color = const Color(0xffff0037),
        this.height = 52,
        this.width = 200,
        this.circularRadius = 15,
        this.textcolor = Colors.white,
        this.bordercolor = Colors.grey,
        this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
       color: color ?? Theme.of(context).primaryColor,

      minWidth: width,
      height: height,
     // color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(circularRadius),
        side: BorderSide(color: bordercolor!),
      ),
      onPressed: onPress,
      child: child ??
          Text(
            text,
            style: TextStyle(
              fontFamily: Const.aventa,
              color: textcolor,
              fontSize: 19,
            ),
          ),
    );
  }
}

void toast(message) {
  if (message != null) {
    showToast(
      message,
      duration: Duration(seconds: 2),
      position: ToastPosition.bottom,
      backgroundColor: Colors.grey[800],
      radius: 5.0,
      textStyle: TextStyle(fontSize: 16.0, color: Colors.white),
    );
  }
}

void NotImplemented() {
  toast('Not Implemented Yet');
}

class EditText extends StatefulWidget {
  Function(String?)? onChange, onSaved;
  String? Function(String?)? validator;
  final String? hintText, errorText, prefixIcon, suffixIcon, fontFamily;
  IconData? icon, prefixiconData;
  bool setEnable, showBorder;
  bool obscure;
  bool isDropDown, isPassword, isFilled, isLabelHidden;
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
  double? width;

  EditText({
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
    this.isFilled = true,
    this.isLabelHidden = false,
    this.filledColor = const Color(0xFFF7F7F7),
    this.borderColor = const Color(0xFFF7F7F7),
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
    this.width,
  });

  @override
  State<EditText> createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  @override
  Widget build(BuildContext context) {
    //this.context = context;
    if (widget.width == null)
      widget.width =  MediaQuery.of(context).size.width;
    return Container(
      width: widget.width,
      child: TextFormField(
        validator: widget.validator,
//      autovalidate: true,
        controller: widget.controller,
        enabled: widget.setEnable,
        onChanged:  (val) {
          setState(() {
            if(val!=null && val.length>0){
              widget.value = val;
              if (widget.onChange != null) widget.onChange!(val);
            }else
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
//      cursorColor: accentColor,
        style: Style.getRegularFont(14.sp, color: Style.textBlackColor),
        textAlignVertical: TextAlignVertical.center,
        //textAlign: TextAlign.justify,
        onFieldSubmitted: widget.onFieldSubmitted ??
                (value) {
              _fieldFocusChange(widget.currentFocus, widget.nextFocus);
            },
        decoration: InputDecoration(
          isCollapsed:
          widget.prefixIcon != null || widget.prefixiconData != null || widget.suffixIcon != null,
          contentPadding: EdgeInsets.all(20),
          hintText: widget.hintText,
           filled: this.widget.isFilled,
           fillColor: this.widget.filledColor,
          //filled: widget.value==null,
          //fillColor: Color(0x0f0a3746),
          // prefixStyle: TextStyle(color: Colors.blue, fontSize: 16),
          labelStyle: TextStyle(
              fontFamily: 'Gibson-Regular',
              color: Color.fromARGB(255, 69, 79, 99),
              fontSize: 16,
              height: 1.2),
          // labelText: this.widget.isLabelHidden ? null : this.widget.hintText,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          // labelStyle: TextStyle(color: Colors.black),
          hintStyle: TextStyle(
              fontFamily: Const.aventaRegular,
              color: Color.fromARGB(255, 69, 79, 99),
              fontSize: 16),
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
              color: Color(0xff78849e),
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
      ),
    );
  }

  _fieldFocusChange(
      /*BuildContext context,*/ FocusNode? currentFocus, FocusNode? nextFocus) {
    currentFocus?.unfocus();
    if (nextFocus != null) FocusScope.of(widget.context).requestFocus(nextFocus);
  }
}

class LabeledEditText extends StatelessWidget {
  Function(String?)? onChange, onSaved;
  String? Function(String?)? validator;
  final String? labelText, hintText, value, prefixText;
  Widget? prefixIcon;
  bool setEnable, obscure;
  TextInputAction? textInputAction;
  TextInputType? textInputType;
  List<TextInputFormatter>? inputFormatter;
  FocusNode? currentFocus, nextFocus;
  BuildContext context;
  Function(String)? onFieldSubmitted;
  TextEditingController? controller;
  int? maxLength;
  TextAlign textAlign;
  bool autoValidate;
  Widget? prefix;

  // IconData icon, prefixiconData;

  LabeledEditText({
    required this.context,
    this.onChange,
    this.labelText,
    this.hintText,
    this.value,
    this.prefixText,
    this.onSaved,
    this.validator,
    this.obscure = false,
    this.setEnable = true,
    this.autoValidate = false,
    this.currentFocus,
    this.nextFocus,
    this.textInputAction,
    this.textInputType,
    this.inputFormatter,
    this.maxLength,
    this.textAlign = TextAlign.start,
    this.prefix,
    this.onFieldSubmitted,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    context = context;
    return TextFormField(
      validator: validator,
      autovalidateMode: autoValidate
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      // autovalidate: autoValidate,
      controller: controller,
      enabled: setEnable,
      onChanged: onChange,
      onSaved: onSaved,
      obscureText: obscure,
//      maxLines: 1,
//      autofocus: true,
      focusNode: currentFocus,
      textInputAction: textInputAction,
      keyboardType: textInputType,
      inputFormatters: inputFormatter,
      textAlign: textAlign,
      maxLength: maxLength,
//      cursorColor: accentColor,
      style: TextStyle(
//        color: Colors.white,
        fontSize: 16,
        fontFamily: 'Gibson',
      ),
      onFieldSubmitted: onFieldSubmitted ??
              (value) {
            _fieldFocusChange(currentFocus, nextFocus);
          },
      initialValue: value,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefix,
        prefixText: prefixText,
        filled: false,
        fillColor: Color(0xffffffff),
        prefixStyle: TextStyle(color: Colors.blue, fontSize: 16),
        labelStyle: TextStyle(color: Colors.black, fontSize: 16, height: 1.2),
        hintStyle: TextStyle(color: Color(0xff010713), fontSize: 16),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xfff7f9ff)),
            borderRadius: BorderRadius.circular(18)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xfff7f9ff)),
            borderRadius: BorderRadius.circular(18)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0x5454f63)),
            borderRadius: BorderRadius.circular(18)),
      ),
    );
  }

  _fieldFocusChange(
      /*BuildContext context,*/ FocusNode? currentFocus, FocusNode? nextFocus) {
    currentFocus?.unfocus();
    if (nextFocus != null) FocusScope.of(context).requestFocus(nextFocus);
  }
}

class RadioGroup extends StatefulWidget {
  String? title;
  List<String> list;
  Color color;
  String? initValue;
  Function(String)? onChanged;

  RadioGroup(
      {this.title,
        required this.list,
        this.initValue,
        this.color = Colors.black,
        this.onChanged});

  @override
  _RadioGroupState createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (String item in widget.list)
          _myRadioButton(
            title: item,
            value: item,
//          selected: item==_groupValue?true:false,
            onChanged: (newValue) =>
            newValue ??
                setState(() {
                  widget.initValue = newValue;
                  widget.onChanged ?? widget.onChanged!(newValue!);
                }),
          ),
      ],
    );
  }

  Widget _myRadioButton(
      {required String title,
        required String value,
        bool selected = false,
        Function(String?)? onChanged}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Colors.black, width: 2, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(15),
          ),
          color: Colors.black),
      child: RadioListTile(
        activeColor: widget.color,
        value: value,
        groupValue: widget.initValue,
        selected: selected,
        onChanged: onChanged,
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: ChoiceChip(
        label: Text(
          isSelected ? "Interested" : "Not Interested",
          style: TextStyle(color: Colors.white),
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            isSelected = selected;
          });
        },
      ),
    );
  }
}


