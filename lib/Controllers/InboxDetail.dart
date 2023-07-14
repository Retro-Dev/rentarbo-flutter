import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Controllers/Chat.dart';
import '../Models/InboxDetailViewModel.dart';

import '../Extensions/style.dart';
import '../Models/NotificationModel.dart';
// import 'package:grouped_list/grouped_list.dart';

class InboxDetail extends StatefulWidget {
  static const String route = "InboxDetail";

  const InboxDetail({Key? key}) : super(key: key);

  @override
  State<InboxDetail> createState() => _InboxDetailState();
}

class _InboxDetailState extends State<InboxDetail> {

  InboxDetailItemViewModel inboxDetailViewModel = InboxDetailItemViewModel();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
     extendBody: true,
     extendBodyBehindAppBar: true,
     backgroundColor: Colors.white,
     appBar: AppBar(
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
     body: _InboxDetailBodyView(),
   );
  }

  Widget _InboxDetailBodyView() {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 260.w,
          child: Image.asset(
            Style.getTempImage("slider-img-4.png"),
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(context).pushNamed(Chat.route);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: const Color(0xFFF7F7F7),
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                SizedBox(
                                  width: 50.w,
                                  height: 50.w,
                                  child: Image.asset(Style.getTempImage(
                                      inboxDetailViewModel.getUserDpFor(index))),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            inboxDetailViewModel
                                                .getUserNameFor(index),
                                            style: Style.getSemiBoldFont(14.sp,
                                                color: const Color(0xFF363E51)),
                                          ),
                                          Visibility(
                                            visible: !inboxDetailViewModel
                                                .getSeenStatusFor(index),
                                            child: Container(
                                                height: 8.w,
                                                width: 8.w,
                                                decoration: BoxDecoration(
                                                    color: Style.redColor,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(16.w)))),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        inboxDetailViewModel.getTitleFor(index),
                                        style: Style.getMediumFont(14.sp,
                                            color: const Color(0xFF363E51)
                                                .withOpacity(0.8)),
                                      )
                                    ],
                                  ),
                                )
                              ]),
                              SizedBox(height: 8.h),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  inboxDetailViewModel.getDisplayTimeFor(index),
                                  textAlign: TextAlign.end,
                                  style: Style.getMediumFont(12.sp,
                                      color:
                                      const Color(0xFF1F1F1F).withOpacity(0.8)),
                                ),
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
                      height: 8.w,
                      color: Colors.white,
                    );
                  },
                  itemCount: inboxDetailViewModel.getInboxDetailItemsCount()),
            ))
      ],
    );
  }



}