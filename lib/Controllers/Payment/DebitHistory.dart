import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Models/PaymentHistoryModel.dart';
import '../../Utils/BaseModel.dart';
import '../../Utils/BookingAds.dart';
import '../../Utils/Const.dart';
import '../../Utils/utils.dart';
import '../../View/views.dart';


class DebitHistory extends StatefulWidget {
  const DebitHistory({Key? key}) : super(key: key);

  @override
  State<DebitHistory> createState() => _DebitHistoryState();
}

class _DebitHistoryState extends State<DebitHistory> {

  List<PaymentHistoryModel> debitHistoryList = [];

  late ScrollController _controller;
  int currentPage = 1;
  Pagination? _pagination;
  bool _isLoadMoreRunning = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdebitHistory();

    _controller = ScrollController()
      ..addListener(_loadMore);
  }

  void _loadMore() async {
    if (currentPage - 1 == _pagination?.meta?.lastPage) {
      return;
    }
    if (
    _controller.position.extentAfter < 5 && _pagination?.links?.first != null) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      print("_loadMore()");
      print("${_pagination?.links?.first}");
      //_page += 1; // Increase _page by 1
      currentPage = currentPage + 1;
      _controller.removeListener(_loadMore);
      await  getPaymentHistoryithPagination(url: Const.Get_Payment_history + '?page=${currentPage}', params: {'type': 'debit'}, onSuccess: (List<PaymentHistoryModel> list,Pagination? pagination) {

        hideLoading();
        if (!mounted) return;

        setState((){
          debitHistoryList.addAll(list);
          _controller = ScrollController()..addListener(_loadMore);
          print("notificationListing.length ${debitHistoryList.length}");

        });
        // print(baseModel.data);

      },  onError: (error) {
        hideLoading();
        toast(error);
      });


    }
  }


  void getdebitHistory()
  {
    showLoading();
    getPaymentHistory(params: {'type':'debit'}, onSuccess: (List<PaymentHistoryModel> list) {
      hideLoading();
      if (!mounted) return;
      setState((){

        debitHistoryList.addAll(list);


      });
    },
        onError: (error) {
          hideLoading();
          toast(error);
        });
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(16),
        child: debitHistoryList.isEmpty ? showEmpty() : body(),
      ),
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
      if (debitHistoryList[currentIndex].createdAt !=debitHistoryList[currentIndex - 1]?.createdAt)
      {
        return true;
      }
      else
      {
        return false;
      }
    }
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

  // Widget body() {
  //   return Container(
  //     child: debitHistoryList.isEmpty ? showEmpty() : body(),
  //   );
  //}


  // Column showContent() {
  //   return Column(
  //     children: [  //22 127 251 \\245 175 25
  //       for (var notificationData in notificationListing)
  //         notificationListViewCardView(profileImage: "${notificationData?.actorImageUrl}", choreName: "${notificationData?.title}", choreDesc: "${notificationData?.description}", chorePrice: "${230}")
  //
  //     ],
  //   );
  // }

  Widget body() {

    return ListView.separated(
        controller: _controller,
        itemBuilder: (context, index) {

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (checkDateHeader(index))
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text('${debitHistoryList[index].createdAt}',
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
                            debitHistoryList[index].receiver?.name ?? '',
                            style: const TextStyle(
                                color: Color(0xff454f63),
                                fontFamily: Const.aventaBold,
                                fontSize: 15.0),
                            textAlign: TextAlign.left),
                      ),
                      Spacer(
                        flex: 1,
                      ),

                      Text('\$${debitHistoryList[index].chargeAmount ?? 0}',
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
        itemCount: debitHistoryList.length);
  }
}
