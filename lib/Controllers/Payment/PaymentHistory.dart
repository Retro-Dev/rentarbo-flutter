import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



import '../../Utils/Const.dart';
import '../../Utils/DecoratedTabbar.dart';
import 'CreateHistory.dart';
import 'DebitHistory.dart';

class PaymentHistory extends StatefulWidget {
  static const route = 'PaymentHistory';

  const PaymentHistory({Key? key}) : super(key: key);

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {


  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          bottom: DecoratedTabBar(
            leftRightPadding: 16.0,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: ColorsConstant.slate.withOpacity(0.50),
                  width: 1,
                ),
              ),
            ),
            tabBar: TabBar(
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontFamily: Const.aventaBold,
              ),
              labelColor: ColorsConstant.vermillion,
              unselectedLabelColor: ColorsConstant.slate.withOpacity(0.50),
              indicatorColor: ColorsConstant.tomato,
              indicatorSize: TabBarIndicatorSize.tab,

              tabs: [
                Tab(
                  text: 'Debit',
                ),
                Tab(
                  text: 'Credit',
                ),
              ],
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text('Payment History',style: TextStyle(color: Colors.black , fontFamily: Const.aventaBold),),
          centerTitle: false,
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
        body: TabBarView(
          children: [
            DebitHistory(),
            CreateHistory(),
          ],
        ),
      ),
    );
  }
}
