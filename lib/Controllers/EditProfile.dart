import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Utils/Prefs.dart';
import '../View/views.dart';

import '../Extensions/style.dart';
import '../Models/User.dart';
import '../Utils/Const.dart';
import '../Utils/user_services.dart';
import '../Utils/utils.dart';
import '../component/custom_button.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  static const String route = "EditProfile";

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  User? userObj;
  File? image;
  String? email, fname , lname,location,phone,lat,long;
  FocusNode fNameFocus = FocusNode(),
      lNameFocus = FocusNode(),
      phoneFocus = FocusNode(),
      emailFocus = FocusNode(),
      passFocus = FocusNode(),
      comfrmPassFocus = FocusNode();

  TextEditingController fNameTextController = TextEditingController(),
      lNameTextController = TextEditingController(),
      phoneTextController = TextEditingController(),
      emailTextController = TextEditingController(),
      passTextController = TextEditingController(),
      confirmPassTextController = TextEditingController();



 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }

  load() async {
    Prefs.getUser((User? user){
      if(mounted) {
        setState(() {
          this.userObj = user;
          loadDataFromUser();
        });
      }
    });

  }

  loadDataFromUser() {
   this.fNameTextController.text = userObj?.firstName ?? "";
   this.lNameTextController.text = userObj?.lastName ?? "";
   this.phoneTextController.text = userObj?.mobileNo ?? "";
   this.emailTextController.text = userObj?.email ?? "";

  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>(debugLabel: '_EditProfile');

  bool autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          "Edit Profile",
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
      body: _EditAccountBodyView(),
    );
  }

  Widget _EditAccountBodyView()
  {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: autoValidate
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Center(
                          child: SizedBox(
                            width: 90.w,
                            height: 90.w,
                            child: Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 150.0,
                                  height: 150.0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child:FadeInImage(
                                      // height: 50,
                                      // width: 50,
                                        fadeInDuration: const Duration(milliseconds: 500),
                                        fadeInCurve: Curves.easeInExpo,
                                        fadeOutCurve: Curves.easeOutExpo,
                                        placeholder: AssetImage("src/placeholder.png"),
                                        image: image != null ?   Image.file(
                                          image!,
                                          fit: BoxFit.cover,
                                        ).image :  NetworkImage(userObj?.imageUrl ?? Const.IMG_DEFUALT , scale: 3.5),
                                        imageErrorBuilder: (context, error, stackTrace) {
                                          return Container(child: Image.asset("src/placeholder.png"));
                                        },
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                Positioned(
                                  right: -10.w,
                                  top: 20.w,
                                  child: SizedBox(
                                    width: 26.w,
                                    height: 26.w,
                                    child: GestureDetector(
                                      onTap: () async {
                                        showImageSelectOption(context,false, (image , isVideo , imagethump) async {
                                          if (image != null)

                                            if(mounted) {
                                              setState(() {
                                                this.image = image;
                                              });
                                            }
                                        });
                                      },
                                      child: Image.asset(
                                          Style.getIconImage("add-dp-icon@2x.png")),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 36.h),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "First Name",
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
                            controller: fNameTextController,
                            validator: validateName,
                            onSaved: (text){
                              fname = text;
                            },
                            onChanged: (text){
                              fname = text;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              contentPadding: const EdgeInsets.all(10),
                              fillColor: const Color(0xFFF7F7F7),
                              hintText: userObj?.firstName ?? "",
                              focusedBorder: Style.outlineInputBorder,
                              enabledBorder: Style.outlineInputBorder,
                            )),
                        SizedBox(height: 16.h),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Last Name",
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
                            controller: lNameTextController,
                            validator: validateName,
                            onSaved: (text){
                              lname = text;
                            },
                            onChanged: (text){
                              lname = text;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              contentPadding: const EdgeInsets.all(10),
                              fillColor: const Color(0xFFF7F7F7),
                              hintText: "Last Name",
                              focusedBorder: Style.outlineInputBorder,
                              enabledBorder: Style.outlineInputBorder,
                            )),
                        SizedBox(height: 16.h),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Phone Number",
                            textAlign: TextAlign.start,
                            style: Style.getSemiBoldFont(14.sp,
                                color: Style.textBlackColorOpacity80),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        EditText(
                          context: context,
                            textInputType : TextInputType.name,
                            textInputAction: TextInputAction.next,
                            // autocorrect: false,
                            setEnable: false,
                            filledColor: const Color(0xFFF7F7F7),
                            borderColor: Color(0xFFF7F7F7),
                            controller: phoneTextController,
                            onSaved: (text){
                              phone = text;
                            },
                            onChange: (text){
                              phone = text;
                            },
                            validator: validateMobile,
                            ),
                        SizedBox(height: 16.h),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
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
                            textInputType : TextInputType.name,
                            textInputAction: TextInputAction.next,
                            setEnable: false,
                            filledColor: const Color(0xFFF7F7F7),
                            borderColor: Color(0xFFF7F7F7),
                            isFilled: true,
                            controller: emailTextController,
                            onSaved: (text){
                              email = text;
                            },
                            onChange: (text){
                              email = text;
                            },
                            validator: validateEmail,
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child:
                      CustomButton(
                          btnText: "Save",
                          radius: 25.w,
                          height: 50.w,
                          width: MediaQuery.of(context).size.width,
                          fontSize: 12.sp,
                          fontstyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontFamily: Const.aventa,
                            fontStyle: FontStyle.normal,
                            fontSize: 18.sp,
                          ),
                          onPressed: () {

                              if (_validateInputs())
                              {
                                editProfile();
                              }
                          }),
                    ),
                    //        SizedBox(height: 120.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );


  }


  editProfile()
  {
    showLoading();
    var jsonData = {'first_name':'${fname}','last_name':'${lname}','mobile_no':'$phone','_method':'PUT'};
    var urlString = 'user/${userObj?.slug}';
    if (image != null)
    {

      editProfileApi(jsonData: jsonData, url: urlString, image: image!.path, onSuccess: (userData){
        hideLoading();
        Prefs.setUser(userData);
        Navigator.pop(context , userData);

      }, onError: (error)
      {
        hideLoading();
        toast(error);

      });
    }
    else
    {
      editProfileWithOutImage(jsonData: jsonData, url: urlString, onSuccess: (userData){
        hideLoading();
        Navigator.pop(context , userData);

      }, onError: (error)
      {
        hideLoading();
        toast(error);

      });
    }
    //

  }

  bool _validateInputs() {
    if (_formKey.currentState!.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState!.save();
      return true;
    } else {
//    If all data are not valid then start auto validation.
    if(mounted){
      setState(() {
        autoValidate = true;
      });
    }

      return false;
    }
  }

}
