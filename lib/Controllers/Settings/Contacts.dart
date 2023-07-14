import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:rentarbo_flutter/Utils/user_services.dart';
import 'package:rentarbo_flutter/Utils/utils.dart';
import '../../Utils/Const.dart';
import '../../View/views.dart';

import '../../Extensions/style.dart';
import '../../component/custom_button.dart';



class ContactUs extends StatefulWidget {

  static const String route = "ContactUs";
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {

  FocusNode nameFocus = FocusNode(),
      emailFocus = FocusNode() ,
      messageFocus = FocusNode();

  String? name, email, message;

  bool autoValidate = false,
      obsure = true;
  TextEditingController? mobilenumber;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>(debugLabel: '_Login');


  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsItem(focusNode: nameFocus),
        KeyboardActionsItem(focusNode: emailFocus),
        KeyboardActionsItem(focusNode: messageFocus),

      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          "Contact Us",
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
      body:  ContactViewBody(),
    );
  }


  bool _validateInputs() {
    if (_formKey.currentState!.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState!.save();
      return true;
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        autoValidate = true;
      });
      return false;
    }
  }

  Widget ContactViewBody() {
    return KeyboardActions(
      config: _buildConfig(context),
      child: Form(
        key: _formKey,
        autovalidateMode: autoValidate
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Email us with any question or inquiries. We would be happy to answer your questions and setup a meeting with you. Let us know your feedback so that we can do our best to serve you.",
                  style:
                  Style.getMediumFont(12.sp, color: Style.textBlackColor),
                ),
                SizedBox(height: 24.h),
                Text(
                  "Call",
                  style: Style.getSemiBoldFont(14.sp, color: Style.redColor),
                ),
                SizedBox(height: 16.h),
                Text("+1 (469) 751-4052",
                    style: Style.getRegularFont(14.sp,
                        color: Style.textBlackColor)),
                SizedBox(height: 12.h),
                Text("+1 (214) 247-7153",
                    style: Style.getRegularFont(14.sp,
                        color: Style.textBlackColor)),
                SizedBox(height: 24.h),
                Text(
                  "Email",
                  style: Style.getSemiBoldFont(14.sp, color: Style.redColor),
                ),
                SizedBox(height: 16.h),
                Text("care@researchhound.com",
                    style: Style.getRegularFont(14.sp,
                        color: Style.textBlackColor)),
                SizedBox(height: 24.h),
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Text(
                    "Name",
                    textAlign: TextAlign.start,
                    style: Style.getSemiBoldFont(14.sp,
                        color: Style.textBlackColorOpacity80),
                  ),
                ),
                SizedBox(height: 6.h),
                EditText(
                  context: context,
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  filledColor: const Color(0xFFF7F7F7),
                  borderColor: Color(0xFFF7F7F7),
                  isFilled: true,
                  hintText: "Name",
                  currentFocus: nameFocus,
                  nextFocus: emailFocus,
                  validator: validateName,
                  onChange: (text) {
                    name = text;
                  },

                  onSaved: (text) {
                    name = text;
                  },

                  // icon: Image.asset(
                  //     obsure ? "password-visible-icon@2x.png" : "password-invisible-icon@2x.png"),

                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Text(
                    "Email Address",
                    textAlign: TextAlign.start,
                    style: Style.getSemiBoldFont(14.sp,
                        color: Style.textBlackColorOpacity80),
                  ),
                ),
                SizedBox(height: 6.h),
                EditText(
                  context: context,
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  filledColor: const Color(0xFFF7F7F7),
                  borderColor: Color(0xFFF7F7F7),
                  isFilled: true,
                  hintText: "Email Address",
                  currentFocus: emailFocus,
                  nextFocus: messageFocus,
                  validator: validateEmail,
                  onChange: (text) {
                    email = text;
                  },

                  onSaved: (text) {
                    email = text;
                  },

                  // icon: Image.asset(
                  //     obsure ? "password-visible-icon@2x.png" : "password-invisible-icon@2x.png"),

                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Text(
                    "Message",
                    textAlign: TextAlign.start,
                    style: Style.getSemiBoldFont(14.sp,
                        color: Style.textBlackColorOpacity80),
                  ),
                ),
                SizedBox(height: 6.h),
                EditText(
                  context: context,
                  textInputAction: TextInputAction.newline,
                  textInputType: TextInputType.name,
                  hintText: "Message",
                  maxLines: 4,
                  // controller: productDescription,
                  validator: validateField,
                  currentFocus: messageFocus,
                  onSaved: (text) {
                    message = text;
                  },
                  onChange: (text) {
                    message = text;
                  },
                ),
                SizedBox(height: 55.h),
                // CustomButton(
                //   btnText: "Submit",
                //   width: MediaQuery.of(context).size.width,
                //   height: 54.w,
                //   radius: 30.w,
                //   fontSize: 18.sp,
                //   onPressed: () {},
                // ),

                CustomButton(btnText: "Submit" , radius: 25.w,height: 50.w, width: MediaQuery.of(context).size.width, fontSize : 12.sp ,fontstyle: TextStyle(
                  color:  Colors.white,
                  fontWeight: FontWeight.w300,
                  fontFamily: Const.aventa,
                  fontStyle:  FontStyle.normal,
                  fontSize: 18.sp,
                ),onPressed: () {
                  if (_validateInputs()) {
                    showLoading();
                    contactUs(name: name ?? "",
                        email: email ?? "",
                        message: message ?? "",
                        onSuccess: (data) {
                          hideLoading();
                          toast(data.message);
                          Navigator.of(context).pop();
                        },
                        onError: (error) {
                          hideLoading();
                          toast(error);
                        });
                  }
                }),
                // MyButton(onPress: () {
                //   if (_validateInputs()) {
                //     showLoading();
                //     contactUs(name: name ?? "",
                //         email: email ?? "",
                //         message: message ?? "",
                //         onSuccess: (data) {
                //           hideLoading();
                //           toast(data.message);
                //         },
                //         onError: (error) {
                //           hideLoading();
                //           toast(error);
                //         });
                //   }
                // },
                //   text: 'Submit',
                //   height: 54.w,
                //   width: MediaQuery
                //       .of(context)
                //       .size
                //       .width,
                //   circularRadius: 30.w,
                //
                // )
              ],
            ),
          ),

        ),
      ),
    );
  }
}
