import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Utils/Const.dart';

class Spinner extends StatefulWidget {
  var array, hint;
  String? value;
  String? icon, dropdownValue;
  Function onChange;
  Color borderColor, filledColor, placeholderTextColor;
  IconData arrowIcon;
  bool? width;

  Spinner(
      {this.hint,
        this.value,
        this.array,
        this.icon,
        this.dropdownValue,
        this.borderColor = const Color(0x34454f63),
        this.filledColor = Colors.transparent,
        this.placeholderTextColor = const Color(0xff78849e),
        this.arrowIcon = Icons.arrow_drop_down,
        required this.onChange,
        this.width});

  @override
  _SpinnerState createState() => _SpinnerState();
}

class _SpinnerState extends State<Spinner> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      width:  widget?.width ?? false ?  MediaQuery.of(context).size.width / 2 - 25 :  MediaQuery.of(context).size.width ,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: widget.borderColor),
        color: widget.value != null ? Colors.transparent :Color(0x0f0a3746),
        // boxShadow: Colors.grey,
      ),
      child: DropdownButton<String>(

        hint: Row(
          children: <Widget>[
            if (widget.icon != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 0, left: 4),
                child: Image.asset(
                  widget.icon!,
                  scale: 4.5,
                ),
              ),
            SizedBox(
              width: widget.icon != null ? 13 : 0,
            ),
            Text(
              widget.hint,
              style: TextStyle(
                  fontSize: 16,
                  color: widget.placeholderTextColor,
                  fontFamily: "Aventa"),
            ),
          ],
        ),
        isExpanded: true,
        value: widget.dropdownValue,
        iconEnabledColor: Colors.black,
        icon: Icon(
          widget.arrowIcon,
          color: ColorsConstant.slate,
        ),
        elevation: 16,
        style: const TextStyle(color: Colors.black),
        underline: Container(
          height: 1,
          color: Colors.transparent,
        ),
        onChanged: (String? newValue) {
          setState(() {
            widget.dropdownValue = newValue;
            widget.value = newValue;
            widget.onChange(newValue);
          });
        },
        items: widget.array.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Row(
              children: <Widget>[
                if (widget.icon != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0, left: 4),
                    child: Image.asset(
                      widget.icon!,
                      scale: 4.5,
                    ),
                  ),
                SizedBox(
                  width: (widget.icon != null) ? 13 : 0,
                ),
                Text(
                  value,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: "Aventa"),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}