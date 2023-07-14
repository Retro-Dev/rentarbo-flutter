import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Models/BankInfo.dart';
import '../../Models/User.dart';
import '../../Utils/BankAndCardServices.dart';
import '../../Utils/Const.dart';
import '../../Utils/Prefs.dart';
import '../../Utils/user_services.dart';
import '../../Utils/utils.dart';
import '../../View/views.dart';
import '../../Extensions/Externsions.dart';
import 'Add Bank Account.dart';
import 'AddPersonalDetails.dart';



class Payout extends StatefulWidget {
  const Payout({Key? key}) : super(key: key);
  static const route = 'Payout';
  @override
  State<Payout> createState() => _PayoutState();
}

class _PayoutState extends State<Payout> {
  bool agree = false;
  CheckAccountStatusModel? accountInfoModelData ;
  String? date;
  User? userSavedData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
    getPersonalInfo();
  }

  load() async {
    Prefs.getUser((User? user){
      setState(() {
        this.userSavedData = user;
        // print('user?.isPayoutInfo ${user?.isPayoutInfo}');
        // print('user?.isCardInfo  ${user?.isCardInfo}');
        //print(userSavedData?.imageUrl);
      });
    });
  }
  void getPersonalInfo()
  {
    showLoading();

    BankAndCardServices.getPayoutStatus(apiUrl: Const.Bank_payout_check_status, onSuccess: (personalData ){
      hideLoading();
      print(personalData);

      accountInfoModelData = personalData as CheckAccountStatusModel?;

      if (accountInfoModelData?.personalInfo == null && accountInfoModelData?.bankInfo == null)
      {
        showToast("Please Add  Bank Account and Personal Info",position:ToastPosition.bottom );
        return;
      }
      if (accountInfoModelData?.personalInfo == null )
      {
        showToast("Please Add Personal Info",position:ToastPosition.bottom);
        return;
      }

      if (accountInfoModelData?.bankInfo == null )
      {
        showToast("Please Add Bank Account",position:ToastPosition.bottom);
        return;
      }


      var urlString = 'user/${userSavedData?.slug}';
      showLoading();
      getUserProfile(url: urlString, onSuccess: (userData){
        hideLoading();
        // print('userData.isPayoutInfo ${userData.isPayoutInfo}');


      }, onError: (error)
      {
        hideLoading();
        toast(error);

      });

      setState(()
      {

      });
    }, onError: (error)
    {
      hideLoading();
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Payout' , style: TextStyle(color: Colors.black , fontFamily: Const.aventaBold),),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: Colors.black),

        leading: IconButton(
          icon: SizedBox(
              width: 30.w,
              height: 30.w,
              child: Image.asset(
                "src/backimg@3x.png",
                fit: BoxFit.cover,
              )),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: body(),

      ),
    );
  }

  Column showEmpty() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 100,),
        Align(
            alignment: Alignment.center,
            child: Image.asset(
              'src/emptyBank.png',
              height: 200,
              width: 200,
            )),
        SizedBox(
          height: 3.2,
        ),
        Text(
          'No data found',
          style: TextStyle(
              fontFamily: Const.aventaBold,
              fontSize: 20,
              color: ColorsConstant.grayishColor),
          textAlign: TextAlign.center,
        ),

      ],
    );
  }

  Widget body() {
    return Column(
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child:
              MyButtonWithgradient(
                fontsize: 12,
                text: accountInfoModelData?.bankInfo == null ? 'ADD BANK ACCOUNT':'VIEW BANK ACCOUNT',
                startColor: Color.fromARGB(255, 83, 204, 55),
                endColor: Color.fromARGB(255, 76, 185, 51),
                onPress: () {
                  //  Navigator.pushNamed(context, AddBankAccount.route,arguments: );

                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddBankAccount(accountData: accountInfoModelData,))).then((value) {
                    getPersonalInfo();
                  });

                },
              ),

            ),
            SizedBox(
              width: 9,
            ),
            Expanded(
              flex: 1,
              child: MyButtonWithgradient(
                fontsize: 12,
                text: accountInfoModelData?.personalInfo == null ? 'ADD PERSONAL DETAIL':'VIEW PERSONAL DETAIL',
                // 22 127 251
                startColor: Color.fromARGB(255, 22, 127, 251),
                endColor: Color.fromARGB(255, 22, 127, 251),
                width: 167,
                onPress: () {
                  // Navigator.pushNamed(context, AddPersonalDetails.route);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddPersonalDetails(accountData: accountInfoModelData,))).then((value) {
                    getPersonalInfo();
                  });

                },
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        if(accountInfoModelData == null)
          showEmpty(),
        if(accountInfoModelData != null)
          CardMenuItem(
              'payment_bank', '****  ****  **** ${accountInfoModelData?.bankInfo?.last4Digit}', 'Added ${accountInfoModelData?.bankInfo?.createdAt?.substring(0, 10)}'),


        // SizedBox(height: 5,),
        // CardMenuItem('payment_visa', '****  ****  **** 0817', 'Added 15-02-2017'),
        // SizedBox(height: 5,),
        // CardMenuItem('payment_master', '****  ****  **** 2356', 'Added 15-02-2017'),
      ],
    );
  }

  Widget CardMenuItem(image, cardnumber, date, {bool isSelected = false}) {
    return Container(
      child: Card(
        // shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.grey[50],
        child: Padding(
          padding: const EdgeInsets.only(left: 20,right: 10,top: 10,bottom: 10),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'src/$image.png',
                    scale: 3.5,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('$cardnumber',
                    style: TextStyle(
                      fontFamily: Const.aventaBold,
                      fontSize: 15,
                      color: Color.fromARGB(255, 69, 79, 99),

                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('$date',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: Const.aventaBold,
                        //178 185 200
                        color: Color.fromARGB(255, 178, 185, 200)
                    ),),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  SizedBox(height: 20,),
                  Container(
                    // width: int(status.length ) ,
                    height: 20,
                    padding: EdgeInsets.only(left: 15,right: 15,top: 3,bottom: 3),
                    decoration: new BoxDecoration(
                      color: Color.fromRGBO(22, 127, 251, 1.0),
                      borderRadius: BorderRadius.all(
                          Radius.circular(10.0)),
                    ),
                    child: Center(
                      child: Text(
                        "${accountInfoModelData?.personalInfo?.status?.capitalize()}",
                        //"${""}",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: Const.aventaBold,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // Checkbox(
                  //   checkColor: Colors.white,
                  //   fillColor: MaterialStateProperty.all(Colors.green),
                  //   activeColor: Colors.grey,
                  //   focusColor: Colors.transparent,
                  //   hoverColor: Colors.transparent,
                  //   splashRadius: 0.0,
                  //   value: agree,
                  //   shape: CircleBorder(),
                  //   onChanged: (bool? value) {
                  //     setState(() {
                  //       agree = value ?? false;
                  //     });
                  //   },
                  // ),
                  SizedBox(
                    height: 40,
                  ),
                  // IconButton(
                  //   icon: Image.asset(
                  //     'src/payment_delete.png',
                  //     scale: 3.5,
                  //   ),
                  //   onPressed: () {
                  //     print('Hellow world');
                  //   },
                  //   hoverColor: Colors.transparent,
                  //   highlightColor: Colors.transparent,
                  //   focusColor: Colors.transparent,
                  //   splashColor: Colors.transparent,
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
