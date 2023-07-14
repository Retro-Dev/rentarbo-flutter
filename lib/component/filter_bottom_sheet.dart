import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../component/custom_text_form_field.dart';

import '../Extensions/style.dart';
import 'custom_button.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({Key? key}) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: openBottomSheet(context));
  }

  openBottomSheet(BuildContext context) {
    final categoryTextEditing = TextEditingController();
    final radiusTextEditing = TextEditingController();
    final rentTypeTextEditing = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 150,
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Image.asset(Style.getIconImage("ic_cancel@2x.png")),
                    Text(
                      "Filters",
                      style: Style.getSemiBoldFont(16.sp),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6.w),
                    child: Text(
                      "Category",
                      textAlign: TextAlign.start,
                      style: Style.getSemiBoldFont(14.sp,
                          color: Style.textBlackColorOpacity80),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                SizedBox(
                    height: 45,
                    child: CustomTextField(
                      controller: categoryTextEditing,
                      hint: "Boat",
                      textInputType: TextInputType.none,
                      suffixIcon: IconButton(
                        icon: Image.asset(
                          Style.getIconImage("ic_dropdown.png"),
                        ),
                        onPressed: () {},
                      ),
                      textInputAction: TextInputAction.next,
                    )),
                SizedBox(height: 16.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6.w),
                    child: Text(
                      "Radius",
                      textAlign: TextAlign.start,
                      style: Style.getSemiBoldFont(14.sp,
                          color: Style.textBlackColorOpacity80),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                SizedBox(
                    height: 45,
                    child: CustomTextField(
                      controller: radiusTextEditing,
                      hint: "5 Mile",
                      textInputType: TextInputType.none,
                      suffixIcon: IconButton(
                        icon: Image.asset(
                          Style.getIconImage("ic_dropdown.png"),
                        ),
                        onPressed: () {},
                      ),
                      textInputAction: TextInputAction.next,
                    )),
                SizedBox(height: 16.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6.w),
                    child: Text(
                      "Rent Type",
                      textAlign: TextAlign.start,
                      style: Style.getSemiBoldFont(14.sp,
                          color: Style.textBlackColorOpacity80),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                SizedBox(
                    height: 45,
                    child: CustomTextField(
                      controller: rentTypeTextEditing,
                      hint: "Per Hour",
                      textInputType: TextInputType.none,
                      suffixIcon: IconButton(
                        icon: Image.asset(
                          Style.getIconImage("ic_dropdown.png"),
                        ),
                        onPressed: () {},
                      ),
                      textInputAction: TextInputAction.next,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                        btnText: "RESET",
                        fontSize: 12.sp,
                        width: 170,
                        radius: 50,
                        color: Style.btnGreyColor,
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    CustomButton(
                        btnText: "APPLY",
                        fontSize: 12.sp,
                        radius: 50,
                        width: 170,
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
