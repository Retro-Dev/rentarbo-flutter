import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rentarbo_flutter/View/views.dart';
import '../Crypto/Crypto.dart';
import '../Extensions/style.dart';
import '../Models/SettingModel.dart';
import '../Models/User.dart';
import '../Utils/Prefs.dart';
import '../Utils/user_services.dart';
import '../Utils/utils.dart';
import 'ChangePassword.dart';
import 'selectCategory.dart';

class Setting extends StatefulWidget {

  static const String route = "Setting";

  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  List<SettingsModel> _settingModels = [
    SettingsModel(
        title: "Change Password",
        iconName: "chevron-icon.png",
        type: SettingType.changePassword),
    SettingsModel(
        title: "Change Category",
        iconName: "chevron-icon.png",
        type: SettingType.changeCategory),
    SettingsModel(
        title: "Notification",
        iconName: "switch-on-icon.png",
        type: SettingType.notification)
  ];

  bool _value = false;

  bool _notificationEnabled = true;

  User? userObj;

  load() async {
    Prefs.getUser((User? user) {
      setState(() {
        this.userObj = user;
        if (userObj?.isNotification == 1) {
          setState((){
            _value = true;
          });

        }else {
          setState((){
            _value = false;
          });

        }
      });
    });
  }



  int getSettingsCount() {
    return _settingModels.length;
  }

  String getTitleFor(int index) {
    return _settingModels[index].title;
  }

  SettingType getTypeFor(int index) {
    return _settingModels[index].type;
  }

  bool getNotificationEnabled() {
    return _notificationEnabled;
  }

  setNotificationEnabled(bool enabled) {
    _notificationEnabled = enabled;

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
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
          "Settings",
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
      body: SettingsViewBody(),
    );
  }

  Widget SettingsViewBody()
  {
    return ListView.separated(
        itemBuilder: (context, index) {
          if (index == getSettingsCount()) {
            return Container();
          }
          return Padding(
            padding: EdgeInsets.all(16.w),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (getTypeFor(index) ==
                    SettingType.notification) {
                  setNotificationEnabled(
                      !getNotificationEnabled());
                } else if (getTypeFor(index) ==
                    SettingType.changePassword) {
                  Navigator.of(context).pushNamed(ChangePassword.route);
                } else if (getTypeFor(index) == SettingType.changeCategory) {
                  Navigator.of(context).pushNamed(SelectCategory.route, arguments: {'isCommingFromSignUp' : false});
                }
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 34.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getTitleFor(index),
                      style: Style.getSemiBoldFont(14.sp,
                          color: Style.textBlackColorOpacity80),
                    ),
                    if (getTypeFor(index) ==
                        SettingType.changePassword || getTypeFor(index) ==  SettingType.changeCategory)
                      SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: Image.asset(
                            Style.getIconImage("chevron-icon@2x.png")),
                      ),
                    if (getTypeFor(index) ==
                        SettingType.notification)
                        Switch.adaptive(
                        value: _value,
                        onChanged: (newValue) {
                          var value = 0;
                          if (_value) {
                            value = 0;
                          }else {
                            value = 1;
                          }
                          setState(() {
                            _value = newValue;
                            showLoading();
                             notificationUpdate(notification: value , onSuccess: (data) {
                               toast("Settings updated successfully.");
                               User user = User.fromJson({
                                 "id": userObj?.id,
                                 "name": userObj?.name,
                                 "first_name": userObj?.firstName,
                                 "last_name": userObj?.lastName,
                                 "slug": userObj?.slug,
                                 "email": userObj?.email,
                                 "mobile_no": userObj?.mobileNo,
                                 "image_url": userObj?.imageUrl,
                                 "blur_image": userObj?.blurImage,
                                 "status": userObj?.status,
                                 "is_email_verify": userObj?.isEmailVerify,
                                 "is_mobile_verify": userObj?.isMobileVerify,
                                 "country": userObj?.country,
                                 "state": userObj?.state,
                                 "city": userObj?.city,
                                 "zipcode": userObj?.zipcode,
                                 "address": userObj?.address,
                                 "latitude": userObj?.latitude,
                                 "longitude": userObj?.longitude,
                                 "api_token":  CryptoAES.decryptAESCryptoJS(userObj?.apiToken ?? "")  == null ? null : CryptoAES.decryptAESCryptoJS(userObj?.apiToken ?? "" ?? ""),
                                 "device_type": userObj?.deviceType,
                                 "device_token": userObj?.deviceToken,
                                 "platform_type": userObj?.platformType,
                                 "platform_id": userObj?.platformId,
                                 "created_at": userObj?.createdAt?.toIso8601String(),
                                 "is_card_info": userObj?.isCardInfo,
                                 "is_payout_info": userObj?.isPayoutInfo,
                                 "is_notification":  data?.notiSetting?.all ?? 0,
                               });

                               Prefs.setUser(user);
                               hideLoading();
                             }, onError: (error) {
                               hideLoading();
                               toast(error);
                             });

                          });
                        }
                          )
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 1.w,
            color: const Color(0xFF707070).withOpacity(0.1),
          );
        },
        itemCount: getSettingsCount() + 1);
  }
}
