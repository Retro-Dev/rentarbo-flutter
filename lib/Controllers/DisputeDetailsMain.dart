import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rentarbo_flutter/Extensions/Externsions.dart';

import '../Extensions/style.dart';
import '../Models/DisputeModule.dart';
import '../Models/Disputes.dart';
import '../Utils/Ads_services.dart';
import '../Utils/utils.dart';
import '../View/views.dart';
import 'ImagePreviewer.dart';

class DisputeDetailsMain extends StatefulWidget {
  static const String route = "DisputeDetailsMain";
  String? slug;
  String? type;

  DisputeDetailsMain({this.slug , this.type});
  GlobalKey? requestUpdate = GlobalKey();
  @override
  State<DisputeDetailsMain> createState() => _DisputeDetailsMainState();
}

class  _DisputeDetailsMainState extends State<DisputeDetailsMain> {

  DisputeData? listDispute;

  getDisputeDetailsApi() {
    showLoading();
    Map<String, dynamic> jsonParam = {
      "type": widget.type,

    };
    getDisputeDetails(jsonData: jsonParam, onSuccess: (data) {

        setState(() {
          listDispute = data;
        });

      hideLoading();

    }, onError: (data){
      hideLoading();
      toast(data);


    }, slug: widget.slug!);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDisputeDetailsApi();
  }

  Widget circularImageView(
      {required String image, double size = 50, bool profile = true}) {
    return CachedNetworkImage(
      // imageUrl: "http://via.placeholder.com/350x150",
      imageUrl: image,
      fit: BoxFit.cover,
      placeholder: (context, url) => FittedBox(
        fit: BoxFit.cover,
        child: Image.asset('src/placeholder.png' , height: 60.h , width: 60.h , fit: BoxFit.cover,),
      ),
      errorWidget: (context, url, error) => FittedBox(
          child: Image.asset(
            profile ? 'src/placeholder.png' : 'src/placeholder.png',
            height: 60.h , width: 60.h ,fit: BoxFit.cover,
          )),
      height: 60.w,
      width: size.w,
      memCacheHeight: 600 ,
      memCacheWidth: 600,
      maxHeightDiskCache: 800,
      maxWidthDiskCache: 800,
    );
  }

  Widget showImages(int index) {

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new ImagePreviewer(urlString: listDispute?.images![index]!.fileUrl!,
                ))).then((value) {
          setState(() {});
        });
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      offset: Offset(0, 10),
                      blurRadius: 10)
                ]),
            height: 68.h,
            width: 82.w,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  topRight: Radius.circular(4.0),
                  bottomRight: Radius.circular(4.0),
                  bottomLeft: Radius.circular(4.0)),
              child: ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withAlpha(200)],
                  ).createShader(Rect.fromLTRB(300, 10, 10, 350));
                },
                blendMode: BlendMode.srcOver,
                child: FadeInImage(
                    width: 200.w,
                    height: 94.w,
                    fadeInDuration: const Duration(milliseconds: 500),
                    fadeInCurve: Curves.easeInExpo,
                    fadeOutCurve: Curves.easeOutExpo,
                    placeholder: AssetImage("src/placeholder.png"),
                    image:listDispute!.images!.isNotEmpty!
                        ? NetworkImage(listDispute!.images![index]!.fileUrl!)
                        : Image.asset("src/placeholder.png").image,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Container(
                          child: Image.asset("src/placeholder.png"));
                    },
                    fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }


  String getFormattedDate(DateTime date) {
    return  DateFormat.yMMMd().add_jm().format(date.toLocal());
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          "Dispute Details",
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
      body: Padding(
        padding:  EdgeInsets.only(left: 16.w , right: 16.w),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_month),
                    SizedBox(width: 10.w,),
                    Text("${getFormattedDate(listDispute!.createdAt!)}",),
                    SizedBox(width: 3.w,),
                    Spacer(),
            Text("${listDispute?.disputeStatus?.capitalize()}" ,style: TextStyle(color:listDispute?.disputeStatus?.capitalize() == "Pending" ? Color.fromRGBO(255, 127, 0, 1.0) : Color.fromRGBO(64, 216, 0, 1.0)  ),),

                  ],
                ),
                SizedBox(height: 15.h,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${ listDispute?.module == null ?  "" : listDispute?.module?.capitalize()} ID",
                      textAlign: TextAlign.start,
                      style: Style.getBoldFont(16.sp, color: Style.textBlackColor),
                    ),
                    SizedBox(height: 5.h,),
                    Text(
                      "${listDispute?.moduleId ?? 0}",
                      textAlign: TextAlign.start,
                      style: Style.getRegularFont(12.sp, color: Style.textBlackColor),
                    ),
                  ],
                ),
                SizedBox(height: 15.h,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Message",
                      textAlign: TextAlign.start,
                      style: Style.getBoldFont(16.sp, color: Style.textBlackColor),
                    ),
                    Text(
                      "${listDispute?.descripton ?? "-"}",
                      textAlign: TextAlign.start,
                      style: Style.getBoldFont(12.sp, color: Style.textBlackColor),
                      maxLines: 6,
                    ),



                  ],
                ),
                SizedBox(height: 80.h,),
                Text(
                  "Your return item pictures of product",
                  textAlign: TextAlign.start,
                  style: Style.getRegularFont(14.sp, color: Style.textBlackColor),
                ),
                SizedBox(height: 5.h,),
                SizedBox(
                  height: 70.h,
                  child: ListView.separated(
                    // physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: listDispute?.images?.length ?? 0,
                    itemBuilder: (context, index) =>
                        showImages(index),

                    separatorBuilder: (context, index) => SizedBox(
                      width: 8.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}