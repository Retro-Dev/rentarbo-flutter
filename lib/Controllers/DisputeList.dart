import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rentarbo_flutter/Extensions/Externsions.dart';
import '../Extensions/style.dart';
import '../Models/DisputeModule.dart';
import '../Utils/Ads_services.dart';
import '../Utils/Const.dart';
import '../Utils/utils.dart';
import '../View/views.dart';
import 'DisputeDetailsMain.dart';

class DisputeList extends StatefulWidget {
  static const String route = "DisputeList";

  DisputeList({Key? key}) : super(key: key);
  GlobalKey? requestUpdate = GlobalKey();
  @override
  State<DisputeList> createState() => _DisputeListState();
}

class  _DisputeListState extends State<DisputeList> {

  List<DisputeDatum>  listDisputeBooking = [];
  List<DisputeDatum> listDisputeSell = [];
  getBookingDispute() {
    showLoading();
    Map<String, dynamic> jsonParam = {
      "type":"bookings",
    };
    getDispute(jsonData: jsonParam, onSuccess: (data) {
      if (data.isEmpty) {
        toast("Record not found.");
      }else {
        setState(() {
          listDisputeBooking = data;
        });
      }
      hideLoading();
    }, onError: (data){
      hideLoading();
      toast(data);
    });
  }

  getSellDispute() {
    showLoading();
    Map<String, dynamic> jsonParam = {
      "type":"sell",
    };
    getDispute(jsonData: jsonParam, onSuccess: (data) {
      if (data.isEmpty) {
        toast("Record not found.");
      }else {
        setState(() {
          listDisputeSell = data;
        });
      }
      hideLoading();
    }, onError: (data){
      hideLoading();
      toast(data);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBookingDispute();
  }


  String getFormattedDate(DateTime date) {
   return  DateFormat.yMMMd().add_jm().format(date.toLocal());
  }

  Color? colorTapOne;
  Color? colorTapTwo;
  DateTime? createTime;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          bottom: PreferredSize(child: Padding(
            padding: EdgeInsets.only(left: 16.w , right: 16.w),
            child: ClipRRect(

              borderRadius: BorderRadius.circular(50.0),

              child: Container(
                padding: EdgeInsets.all(2.w),
                color: Color(0xffe7e7e7),
                child: TabBar(onTap: (index) {
                  if (index == 0) {
                    setState((){
                      colorTapOne = Colors.white;
                      colorTapTwo = Colors.black;
                      // listRentatBooking = [];
                      listDisputeBooking = [];
                        getBookingDispute();
                    });

                  }else if (index == 1) {
                    setState((){

                      colorTapOne = Colors.black;
                      colorTapTwo = Colors.white;
                         listDisputeSell = [];
                       getSellDispute();

                    });

                  }
                },
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50), // Creates border
                      color: Color(0xff78849e)), //Change background color from here
                  tabs: [ Tab(child: Text("Rental" , style: TextStyle(fontFamily: Const.aventaBold, color: colorTapOne ?? Colors.black , fontSize: 16.sp) ,)),
                    Tab(child: Text("Purchase" , style: TextStyle(fontFamily: Const.aventaBold ,color: colorTapTwo ?? Colors.black , fontSize: 16.sp),),),],

                ),
              ),
            ),
          ), preferredSize: Size(MediaQuery.of(context).size.width, 80)),
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
        body: TabBarView(
          children: [
           listDisputeBooking.isNotEmpty ?
           ListView(

              children: [

                SizedBox(height: 10.h,),
                ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, DisputeDetailsMain.route , arguments: {'slug' : listDisputeBooking[index].slug , 'type' : listDisputeBooking[index].module});
                        },
                        child: Container(
                            margin: EdgeInsets.only(left: 15.w  ,right: 16.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F7F7),
                              border: Border.all(color: Colors.white , width: 1.0),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)
                              ),
                            ),
                            child: Padding(
                              padding:  EdgeInsets.only(left: 10.w , right: 10.w, top: 10.h),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10.h,),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Booking ID"),
                                          Text( listDisputeBooking.isNotEmpty ?  "${listDisputeBooking[index].moduleId ?? 0 }" : "" , style: TextStyle(fontFamily: Const.aventaBold , fontSize: 14.sp , fontWeight: FontWeight.w600),),
                                          SizedBox(height: 20.h,),
                                          Row(
                                            children: [
                                              Icon(Icons.calendar_month),
                                              SizedBox(width: 10.w,),
                                              Text( listDisputeBooking.isNotEmpty ?  "${getFormattedDate(listDisputeBooking[index].createdAt! )} " : ""),
                                              SizedBox(width: 3.w,),
                                              // Text( listDisputeBooking.isNotEmpty ? "${DateFormat('HH:mm').format(listDisputeBooking[index].createdAt ?? DateTime(DateTime.april))}" : ""),
                                              SizedBox(height: 15.h,),

                                            ],
                                          )
                                        ],
                                      ),
                                      Spacer(),
                                      Text(listDisputeBooking.isNotEmpty ?  "${listDisputeBooking[index].disputeStatus?.capitalize()}" : "" ,style: TextStyle(color:listDisputeBooking[index].disputeStatus?.capitalize() == "Pending" ? Color.fromRGBO(255, 127, 0, 1.0) : Color.fromRGBO(64, 216, 0, 1.0)  ),),
                                    ],
                                  ),
                                  SizedBox(height: 10.h,),
                                ],
                              ),
                            )
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                      height: 15.h,
                    ),
                    itemCount: listDisputeBooking.isNotEmpty ? listDisputeBooking.length : 0),
                SizedBox(height: 10.h,),
              ],
            ) :
            SizedBox()
            ,

           listDisputeSell.isNotEmpty ?
           ListView(
              children: [
                SizedBox(height: 10.h,),
                ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, DisputeDetailsMain.route , arguments: {'slug' : listDisputeSell[index].slug , 'type' : listDisputeSell[index].module});
                        },
                        child: Container(
                            margin: EdgeInsets.only(left: 15.w  ,right: 16.w),
                            // 200pt × 148pt

                            // height: 80.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F7F7),
                              border: Border.all(color: Colors.white , width: 1.0),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)
                              ),
                            ),
                            child: Padding(
                              padding:  EdgeInsets.only(left: 10.w , right: 10.w, top: 10.h),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10.h,),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Booking ID"),
                                          Text( listDisputeSell.isNotEmpty ?  "${listDisputeSell[index].moduleId ?? 0 }" : "" , style: TextStyle(fontFamily: Const.aventaBold , fontSize: 14.sp , fontWeight: FontWeight.w600),),
                                          SizedBox(height: 20.h,),
                                          Row(
                                            children: [
                                              Icon(Icons.calendar_month),
                                              SizedBox(width: 10.w,),
                                              Text( listDisputeBooking.isNotEmpty ?  "${getFormattedDate(listDisputeBooking[index].createdAt!)} " : ""),
                                              SizedBox(width: 3.w,),
                                              // Text( listDisputeSell.isNotEmpty ? "${DateFormat('HH:mm').format(listDisputeSell[index].createdAt ?? DateTime(DateTime.april))}" : ""),
                                              SizedBox(height: 15.h,),

                                            ],
                                          )
                                        ],
                                      ),
                                      Spacer(),
                                      Text(listDisputeSell.isNotEmpty ?  "${listDisputeSell[index].disputeStatus?.capitalize()}" : "",style: TextStyle(color:listDisputeSell[index].disputeStatus?.capitalize() == "Pending" ? Color.fromRGBO(255, 127, 0, 1.0) : Color.fromRGBO(64, 216, 0, 1.0) )),
                                    ],
                                  ),
                                  SizedBox(height: 10.h,),
                                ],
                              ),
                            )
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                      height: 15.h,
                    ),
                    itemCount: listDisputeSell.isNotEmpty ? listDisputeSell.length : 0),
                SizedBox(height: 10.h,),
              ],
            ) :
            SizedBox(),

          ],
        ),
      ),
    );
  }

}