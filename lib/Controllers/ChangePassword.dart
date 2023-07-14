
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import '../Utils/Const.dart';
import '../Utils/utils.dart';
import '../View/views.dart';

import '../Extensions/style.dart';
import '../Utils/BaseModel.dart';
import '../Utils/user_services.dart';
import '../component/custom_button.dart';

class ChangePassword extends StatefulWidget {
  static const String route = "ChangePassword";

  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  bool _oldPasswordVisible = true;
  bool _newPasswordVisible = true;
  bool _confirmPasswordVisible = true;


  FocusNode newPassFocus = FocusNode(), ConfpassFocus = FocusNode(), passFocus = FocusNode();

  String? newPass, Confpass, password;

  GlobalKey<FormState> _formKey =
  GlobalKey<FormState>(debugLabel: '_Login');

  bool autoValidate = false, Pobsure = true,CPobsure = true, NPobsure = true , passObsure = false , newPassObsure = false , confirmPassObsure = false ;

  bool getOldPasswordVisiblity() {
    return _oldPasswordVisible;
  }

  setOldPasswordVisiblity(bool visible) {
    _oldPasswordVisible = visible;
    setState(()
    {

    });
  }

  bool getNewPasswordVisiblity() {
    return _newPasswordVisible;
  }

  setNewPasswordVisiblity(bool visible) {
    _newPasswordVisible = visible;
    setState(()
    {

    });
  }

  bool getConfirmPasswordVisiblity() {
    return _confirmPasswordVisible;
  }

  setConfirmPasswordVisiblity(bool visible) {
    _confirmPasswordVisible = visible;
    setState(()
    {

    });
  }


  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsItem(focusNode: passFocus),
        KeyboardActionsItem(focusNode: newPassFocus),
        KeyboardActionsItem(focusNode: ConfpassFocus)

      ],
    );
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
          "Change Password",
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
      body: ChangePasswordViewBody(),
    );
  }

  Widget ChangePasswordViewBody()
  {
    return KeyboardActions(
      config: _buildConfig(context),
      child: Form(
        key: _formKey,
        autovalidateMode: autoValidate ? AutovalidateMode.onUserInteraction
            :AutovalidateMode.disabled,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Old Password",
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
                  hintText: "Old Password",
                  obscure: passObsure,
                  currentFocus: passFocus,
                  nextFocus: newPassFocus,
                  validator: validatePassword,
                  isPassword: true,

                  icon: passObsure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  suffixClick: () {
                    setState(() {
                      passObsure = !passObsure;
                    });
                  },
                  onChange: (text) {
                    password = text;
                  },

                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "New Password",
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
                  hintText: "New Password",
                  obscure: newPassObsure,
                  currentFocus: newPassFocus,
                  nextFocus: ConfpassFocus,
                  validator: validatePassword,
                  isPassword: true,

                  icon: newPassObsure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  suffixClick: () {
                    setState(() {
                      newPassObsure = !newPassObsure;
                    });
                  },
                  onChange: (text) {
                    newPass = text;
                  },

                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Confirm Password",
                    textAlign: TextAlign.start,
                    style: Style.getSemiBoldFont(14.sp,
                        color: Style.textBlackColorOpacity80),
                  ),
                ),
                SizedBox(height: 6.h),
                EditText(

                  context: context,
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  filledColor: const Color(0xFFF7F7F7),
                  borderColor: Color(0xFFF7F7F7),
                  isFilled: true,
                  hintText: "Confirm Password",
                  obscure: confirmPassObsure,
                  currentFocus: ConfpassFocus,
                  validator: validatePassword,
                  isPassword: true,

                  icon: confirmPassObsure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  suffixClick: () {
                    setState(() {
                      confirmPassObsure = !confirmPassObsure;
                    });
                  },
                  onChange: (text) {
                    Confpass = text;
                  },

                ),
                SizedBox(height: 60.h,),
                CustomButton(btnText: "Save" , radius: 25.w,height: 50.w, width: MediaQuery.of(context).size.width, fontSize : 12.sp ,fontstyle: TextStyle(
                  color:  Colors.white,
                  fontWeight: FontWeight.w300,
                  fontFamily: Const.aventa,
                  fontStyle:  FontStyle.normal,
                  fontSize: 18.sp,
                ),onPressed: () {
                  if (_validateInputs())
                  {
                    if (password == null || newPass == null || Confpass == null) {
                      toast('All fields are required');
                    }
                    else
                    {
                      if (newPass != Confpass)
                      {
                        toast('New Password and Confirm Password does not match.');

                      }
                      else
                      {
                        showLoading();
                        ChangePasswordAPI(old_password: '$password', new_password: '$newPass', confirm_password: '$Confpass',   onSuccess: (BaseModel baseModel) {
                          hideLoading();
                          toast(baseModel.message);
                          Navigator.pop(context);
                        },
                            onError: (error) {
                              hideLoading();
                              toast(error);
                            });
                      }

                      // toast("testing mode");
                      // Navigator.pop(context);
                    }
                  }
                }),
                SizedBox(
                  height: 24.w,
                )
              ],
            ),
          ),
        ),
      ),
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
}
