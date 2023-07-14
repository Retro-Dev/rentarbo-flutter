import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Utils/Const.dart';
import '../Extensions/style.dart';
import '../component/custom_button.dart';


class DisputeManagement extends StatefulWidget {
  const DisputeManagement({Key? key}) : super(key: key);

  static const String route = "DisputeManagement";

  @override
  State<DisputeManagement> createState() => _DisputeManagementState();
}

class _DisputeManagementState extends State<DisputeManagement> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          "Dispute Management",
          textAlign: TextAlign.start,
          style: Style.getBoldFont(18.sp, color: Style.textBlackColor),
        ),
        leading: IconButton(
          icon: SizedBox(
              width: 24.w,
              height: 24.w,
              child: Image.asset(
                "src/backimg@3x.png",
                fit: BoxFit.cover,
              )),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body:  _DisputeManagementBodyView(),
    );
  }

  Widget _DisputeManagementBodyView()
  {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                        width: 188.w,
                        height: 188.w,
                        child: Image.asset(
                            Style.getLogoImage("dispute-logo@2x.png"),
                            fit: BoxFit.cover)),
                  ),
                  SizedBox(height: 30.h),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Drop us a line if you are having any dispute with the rentee",
                      textAlign: TextAlign.start,
                      style: Style.getRegularFont(16.sp,
                          color: Style.textBlackColor.withOpacity(0.6)),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Transaction ID",
                      textAlign: TextAlign.start,
                      style: Style.getSemiBoldFont(14.sp,
                          color: Style.textBlackColorOpacity80),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  TextFormField(
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      style: Style.getRegularFont(14.sp,
                          color: Style.textBlackColor),
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: const EdgeInsets.all(10),
                        fillColor: const Color(0xFFF7F7F7),
                        hintText: "Transaction ID",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.w),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                      )),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Message",
                      textAlign: TextAlign.start,
                      style: Style.getSemiBoldFont(14.sp,
                          color: Style.textBlackColorOpacity80),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  TextFormField(
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      maxLines: null,
                      minLines: 4,
                      style: Style.getRegularFont(14.sp,
                          color: Style.textBlackColor),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF7F7F7),
                        hintText: "Message",
                        // focusedBorder: InputBorder.none,
                        // enabledBorder: InputBorder.none,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.w),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                      )),
                  SizedBox(height: 40.h),
                  CustomButton(btnText: "Post Dispute" , radius: 25.w,height: 50.w, width: MediaQuery.of(context).size.width, fontSize : 12.sp ,fontstyle: TextStyle(
                    color:  Colors.white,
                    fontWeight: FontWeight.w300,
                    fontFamily: Const.aventa,
                    fontStyle:  FontStyle.normal,
                    fontSize: 18.sp,
                  ),onPressed: () {
                    Navigator.of(context).pop();
                  }),
                  SizedBox(height: 40.h)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
