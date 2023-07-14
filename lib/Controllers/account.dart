import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rentarbo_flutter/Controllers/DisputeList.dart';
import '../Utils/Prefs.dart';
import '../Utils/utils.dart';

import '../Extensions/style.dart';
import '../Models/AccountItemModel.dart';
import '../Models/User.dart';
import '../Utils/Const.dart';
import '../Utils/user_services.dart';
import '../View/views.dart';
import '../component/custom_button.dart';
import '../component/custom_outline_button.dart';
import 'DisputeManagement.dart';
import 'EditProfile.dart';
import 'MyAds.dart';
import 'MyEarning.dart';
import 'MyRendtalPosted.dart';
import 'Payment/PaymentDetails.dart';
import 'Payment/Payout.dart';
import 'RentalRequests.dart';
import 'RentalStatus.dart';
import 'Setting.dart';
import 'login.dart';

class AccountTab extends StatefulWidget {
  static const String route = "AccountTab";

  const AccountTab({Key? key}) : super(key: key);

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  final List<AccountItemModel> _accountItemModels = [
    AccountItemModel(
        title: "My Ads",
        iconName: "chevron-icon.png",
        type: AccountItemType.myAds),
    AccountItemModel(
        title: "Send Requests",
        iconName: "chevron-icon.png",
        type: AccountItemType.rentalRequests),
    AccountItemModel(
        title: "Received Requests",
        iconName: "chevron-icon.png",
        type: AccountItemType.myRentalPosted),
    AccountItemModel(
        title: "Return Status",
        iconName: "chevron-icon.png",
        type: AccountItemType.returnStatus),
    AccountItemModel(
        title: "My Earning",
        iconName: "chevron-icon.png",
        type: AccountItemType.myEarning),
    AccountItemModel(
        title: "Payment Details",
        iconName: "chevron-icon.png",
        type: AccountItemType.paymentDetails),
    AccountItemModel(
        title: "Payout",
        iconName: "chevron-icon.png",
        type: AccountItemType.payout),
    AccountItemModel(
        title: "Dispute Management",
        iconName: "chevron-icon.png",
        type: AccountItemType.disputeManagement),
    AccountItemModel(
        title: "Settings",
        iconName: "chevron-icon.png",
        type: AccountItemType.settings),
    // AccountItemModel(
    //     title: "Dispute Management",
    //     iconName: "chevron-icon.png",
    //     type: AccountItemType.disputeManagement),
    AccountItemModel(
        title: "Logout",
        iconName: "chevron-icon.png",
        type: AccountItemType.logout),
  ];

  int getMoreItemsCount() {
    return _accountItemModels.length;
  }

  String getTitleFor(int index) {
    return _accountItemModels[index].title;
  }

  AccountItemType getTypeFor(int index) {
    return _accountItemModels[index].type;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }

  User? userObj;

  load() async {
    Prefs.getUser((User? user) {
      setState(() {
        this.userObj = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              width: 44.0,
              height: 44.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: FadeInImage(
                    // height: 50,
                    // width: 50,
                    fadeInDuration: const Duration(milliseconds: 500),
                    fadeInCurve: Curves.easeInExpo,
                    fadeOutCurve: Curves.easeOutExpo,
                    placeholder: AssetImage("src/placeholder.png"),
                    image: NetworkImage(userObj?.imageUrl ?? Const.IMG_DEFUALT,
                        scale: 3.5),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Container(
                          child: Image.asset("src/placeholder.png"));
                    },
                    fit: BoxFit.cover),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${userObj?.name ?? ""}",
                  textAlign: TextAlign.start,
                  style: Style.getSemiBoldFont(16, color: Style.textBlackColor),
                ),
                Text(
                  "${userObj?.email ?? ""}",
                  textAlign: TextAlign.start,
                  style:
                      Style.getRegularFont(12, color: const Color(0xFF408BF9)),
                ),
              ],
            ),
          ],
        ),
        actions: [
          
          IconButton(
              onPressed: () {
                //  Navigator.of(context).pushNamed(Constants.editAccount);
                Navigator.of(context).pushNamed(EditProfile.route).then((value) {

                  setState((){

                    load();

                  });
                });
              },
              icon: SizedBox(
                width: 34,
                height: 34,
                child: Image.asset(Style.getIconImage("edit-icon@2x.png")),
              ))
        ],
      ),
      body: _AccountViewBody(),
    );
  }

  Widget _AccountViewBody() {
    return ListView.separated(
        itemBuilder: (context, index) {
          if (index == getMoreItemsCount()) {
            return Container();
          }
          return Padding(
            padding: EdgeInsets.all(16),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                switch (getTypeFor(index)) {
                  case AccountItemType.myAds:
                    Navigator.of(context).pushNamed(MyAds.route);
                    break;
                  case AccountItemType.rentalRequests:
                    Navigator.of(context).pushNamed(RentalRequest.route);
                    break;
                  case AccountItemType.myRentalPosted:
                    Navigator.of(context).pushNamed(MyRentalPosted.route);
                    break;
                  case AccountItemType.returnStatus:
                    Navigator.of(context).pushNamed(RentalStatus.route);
                    break;
                  case AccountItemType.myEarning:
                    Navigator.of(context).pushNamed(MyEarning.route);
                    break;
                  case AccountItemType.paymentDetails:
                    Navigator.of(context).pushNamed(PaymentDetails.route);
                    break;
                  case AccountItemType.payout:
                    Navigator.of(context).pushNamed(Payout.route);
                    break;
                  case AccountItemType.disputeManagement:
                    Navigator.of(context).pushNamed(DisputeList.route);
                    break;
                  case AccountItemType.settings:
                    Navigator.of(context).pushNamed(Setting.route);
                    break;
                  case AccountItemType.logout:
                    // Navigator.pushNamedAndRemoveUntil(context, Login.route, (route) => false);

                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) => Logout()
                        //thankYouDialog(navigationViewModel,context)
                        );
                    //

                    break;
                }
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 22,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getTitleFor(index),
                      style: Style.getSemiBoldFont(14,
                          color: Style.textBlackColorOpacity80),
                    ),
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Image.asset(
                          Style.getIconImage("chevron-icon@2x.png")),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: const Color(0xFF707070).withOpacity(0.1),
          );
        },
        itemCount: getMoreItemsCount() + 1);
  }

  Widget showLogout(BuildContext context) {
    return AlertDialog(
        title: Text('Do you want to exit this application?'),
        content: Text('We hate to see you leave...'),
        actions: <Widget>[
        ]);
  }

  Widget Logout() {
    return Dialog(

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        height: 180.w,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Logout",
                style: Style.getBoldFont(
                  22.sp,
                ),
              ),
              SizedBox(
                height: 22.h,
              ),
              Text(
                "Do you want to logout?",
                textAlign: TextAlign.center,
                style: Style.getMediumFont(
                  16.sp,
                ),
              ),
              SizedBox(
                height: 22.h,
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomOutlineButton(
                        btnText: "No",
                        radius: 25.w,
                        height: 50.w,
                        width: 110.w,
                        fontSize: 12.sp,
                        fontstyle: TextStyle(
                          color: Style.redColor,
                          fontWeight: FontWeight.w300,
                          fontFamily: Const.aventa,
                          fontStyle: FontStyle.normal,
                          fontSize: 18.sp,
                        ),
                        onPressed: () {
                         Navigator.of(context).pop();
                        }),
                    SizedBox(
                      width: 25,
                    ),
                    CustomButton(
                        btnText: "Yes",
                        radius: 25.w,
                        height: 50.w,
                        width: 110.w,
                        fontSize: 12.sp,
                        fontstyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontFamily: Const.aventa,
                          fontStyle: FontStyle.normal,
                          fontSize: 18.sp,
                        ),
                        onPressed: () {
                          showLoading();
                          logOutUser(onSuccess: (user) {
                            Prefs.removeUser();
                            hideLoading();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                Login.route, (route) => false);
                          }, onError: (error) {
                            hideLoading();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                Login.route, (route) => false);
                            toast(error);
                          });
                        }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
