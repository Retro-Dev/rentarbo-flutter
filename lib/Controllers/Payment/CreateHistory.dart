import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Models/PaymentHistoryModel.dart';
import '../../Utils/BookingAds.dart';
import '../../Utils/Const.dart';
import '../../Utils/utils.dart';
import '../../View/views.dart';




class CreateHistory extends StatefulWidget {
  const CreateHistory({Key? key}) : super(key: key);

  @override
  State<CreateHistory> createState() => _CreateHistoryState();
}

class _CreateHistoryState extends State<CreateHistory> {

  List<PaymentHistoryModel> creditHistoryList = [];
  String? historyDate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcreditHistory();

  }


  void getcreditHistory()
  {
    showLoading();
    getPaymentHistory(params: {'type':'credit'}, onSuccess: (List<PaymentHistoryModel> list) {
      hideLoading();
      if (!mounted) return;
      setState((){

        creditHistoryList.addAll(list);


      });
    },
        onError: (error) {
          hideLoading();
          toast(error);
        });
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(16),
        child: creditHistoryList.isEmpty ? showEmpty() : body(),
      ),

    );
  }
  Column showEmpty() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: 120,
        ),
        Align(
            alignment: Alignment.center,
            child: Image.asset(
              'src/emptyrequest@3x.png',
              height: 149,
              width: 145,
            )),
        SizedBox(
          height: 16.2,
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

  bool checkDateHeader(int currentIndex)
  {
    if (currentIndex == 0)
    {
      return true;
    }
    else
    {
      if (creditHistoryList?[currentIndex].createdAt != creditHistoryList[currentIndex - 1].createdAt)
      {
        return true;
      }
      else
      {
        return false;
      }
    }
  }
  Widget body() {

    return ListView.separated(
      // padding: EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (checkDateHeader(index))
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text('${creditHistoryList[index]?.createdAt}',
                      style: const TextStyle(
                          color: const Color(0x4d454f63),
                          fontWeight: FontWeight.w600,
                          fontFamily: Const.aventaBold,
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
                          height: 1),
                      textAlign: TextAlign.left),
                ),

              Card(
                color: Colors.white,
                shadowColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10,bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Text(
                            creditHistoryList[index].receiver?.name ?? '',
                            style: const TextStyle(
                                color: Color(0xff454f63),
                                fontFamily: Const.aventaBold,
                                fontSize: 15.0),
                            textAlign: TextAlign.left),
                      ),
                      Spacer(
                        flex: 1,
                      ),

                      Text('${creditHistoryList[index]?.netAmount ?? 0}',
                          style: const TextStyle(
                              color: Color(0xff454f63),
                              fontFamily: Const.aventaBold,
                              fontSize: 14.0),
                          textAlign: TextAlign.left),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 0.5,
            // color: Colors.green,
          );
        },
        itemCount: creditHistoryList.length);
  }
}
