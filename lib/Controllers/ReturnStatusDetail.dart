import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rentarbo_flutter/Models/Ads.dart';
import '../Extensions/style.dart';
import '../Models/ReturnStatus.dart';
import '../Utils/Const.dart';
import 'ImagePreviewer.dart';
import 'VideoViewScreen.dart';

class ReturnStatusDetail extends StatefulWidget {
  static const String route = "ReturnStatusDetail";
  ReturnDatum product;
  AdsObj? adsObj;
  ReturnStatusDetail({required this.product});
  @override
  _ReturnStatusDetailState createState() => _ReturnStatusDetailState();
}

class _ReturnStatusDetailState extends State<ReturnStatusDetail> {


  int _current = 0;
  final CarouselController _controller = CarouselController();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  Widget carouselWidget(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
      CarouselSlider(
        carouselController: _controller,
        options: CarouselOptions(
          height: 300.h,
          enlargeCenterPage: false,
          viewportFraction: 1,
          onPageChanged: (position, reason) {
            _current = position;
            if (this.mounted) {
              setState(() {});
            }
          },
          enableInfiniteScroll: false,
        ),

        items: widget.product.product!.media!.map<Widget>((i) {
          return Builder(
            builder: (BuildContext context) {
              return Stack(children: [
                Container(
                  width: MediaQuery.of(context).size.width - 0,
                  margin : EdgeInsets.only(left : 0 , right: 0),
                  child :  ClipRRect(
                    borderRadius: BorderRadius.circular(0.0),
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black.withAlpha(80), Colors.transparent],
                        ).createShader(Rect.fromLTRB(0, 150, rect.width, rect.height));
                      },
                      blendMode: BlendMode.srcOver,
                      child:GestureDetector(
                        onTap : (){
                          if(i.fileType != "video"){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => new ImagePreviewer(urlString: i?.fileType == "image" ? i?.fileUrl :i?.thumbnailUrl ,
                                    ))).then((value) {
                              setState(() {});
                            });
                          }

                         },
                        child: FadeInImage(
                          height: 300.h,
                          width: MediaQuery.of(context).size.width,
                            fadeInDuration: const Duration(milliseconds: 500),
                            fadeInCurve: Curves.easeInExpo,
                            fadeOutCurve: Curves.easeOutExpo,
                            placeholder: Image.asset("src/placeholder.png" , height: 280.h,width: MediaQuery.of(context).size.width).image,
                            image:i.fileType != "video" ? NetworkImage(i.fileUrl ?? "") : NetworkImage(i.thumbnailUrl ?? ""),
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Container(child: Image.asset("src/placeholder.png" , height: 280.h, width: MediaQuery.of(context).size.width,));

                            },
                            fit: BoxFit.cover),
                      ),
                    ),),),
              ]);
            },
          );
        }).toList(),
      ),
      Positioned(
        bottom: 20.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.product.product!.media!.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 8.0.w,
                height: 8.0.w,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : Colors.black)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ),
      if(widget.product?.product?.media?[_current].fileType == "video")
      Positioned(
          bottom: 300.h/2.5.h,
          child:InkWell(
            onTap: () {
              Navigator.pushNamed(context, VideoViewScreen.route, arguments: {
                "sourceType": VideoSource.URL,
                "source": "${ widget!.product!.product!
                    .media![_current]!.fileUrl}" ,
                "videoFile" : File("VideoFile.mp4"),

              });
            },
            child: Image.asset(
              "src/playicon.png",
              color: Colors.white,
            ),
          ),),



    ]);
  }




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: null,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
                children: [
               carouselWidget(context),
              Positioned(top: 280.h, child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  clipBehavior: Clip.hardEdge,
                  child: ColoredBox(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.only(left: 12.w , right: 12.w),
                      child: ListView(
                       physics: AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: 10.h,),
                          Text("${widget.product.rentarName}" , style: TextStyle(fontFamily: Const.aventa ,fontSize: 21.sp , fontWeight: FontWeight.w800) ,),
                          SizedBox(height: 3.5.h,),
                          Text("${widget.product.product?.category?.name}" , style: TextStyle(fontFamily: Const.aventa ,fontSize: 16.sp , fontWeight: FontWeight.w200) ,),
                          SizedBox(height: 15.h,),
                          Text("Additional Details" , style: TextStyle(fontFamily: Const.aventa ,fontSize: 21.sp , fontWeight: FontWeight.w800) ,),
                          SizedBox(height: 3.5.h,),
                          Text("${widget.product.details}" , style: TextStyle(fontFamily: Const.aventa ,fontSize: 12.sp , fontWeight: FontWeight.w200) ,),
                          SizedBox(height: 15.h,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.product.product!.rentType! == "hr" ? "Rent Per Hour" : "Rent Per Day" , style: TextStyle(fontFamily: Const.aventa ,fontSize: 16.sp , fontWeight: FontWeight.w800) ,),
                                  SizedBox(height: 3.5.h,),
                                  Text( widget.product.product!.rentType! == "hr" ? "\$${widget.product.netAmount}/hr" : "\$${widget.product.netAmount}/day" , style: TextStyle(fontFamily: Const.aventa ,fontSize: 12.sp , fontWeight: FontWeight.w800 , color: Colors.red) ,),
                                  SizedBox(height: 15.h,),

                                ],
                              ),
                              SizedBox(width: 25.h,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Duration" , style: TextStyle(fontFamily: Const.aventa ,fontSize: 16.sp , fontWeight: FontWeight.w800) ,),
                                  SizedBox(height: 3.5.h,),
                                  Text(widget.product.product!.rentType! == "hr" ?  "${ "${widget.product!.duration!}"}/hr" : "${ widget.product!.duration!}/day"  , style: TextStyle(fontFamily: Const.aventa ,fontSize: 12.sp , fontWeight: FontWeight.w800 , color: Colors.red) ,),
                                  SizedBox(height: 15.h,),

                                ],
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("Total Bill" , style: TextStyle(fontFamily: Const.aventa ,fontSize: 16.sp , fontWeight: FontWeight.w800) ,),
                              SizedBox(height: 3.5.h,),
                              Text("\$${widget.product.totalCharges}" , style: TextStyle(fontFamily: Const.aventa ,fontSize: 21.sp , fontWeight: FontWeight.w800 , color: Colors.red) ,),
                              SizedBox(height: 15.h,),

                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: EdgeInsets.only(left: 6.w),
                              child: Text(
                                "Your return item pictures of product",
                                textAlign: TextAlign.start,
                                style: Style.getSemiBoldFont(12.sp,
                                    color: Style.textBlackColorOpacity80),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          SizedBox(
                            height: 70.h,
                            child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.product.returnCondition?.length ?? 0,
                              itemBuilder: (context, index) =>
                                  showImages(index),

                              separatorBuilder: (context, index) => SizedBox(
                                width: 8.w,
                              ),
                            ),
                          ),
                          SizedBox(height: 300.h,)



                        ],
                      ),
                    ),
                  ),
                ),
              )),
                  Positioned( top : 45.h , child: Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        child: Icon(Icons.arrow_back , color: Colors.black,),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.h),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 12,
                              offset: Offset(-1, 1), // Shadow position
                            ),
                          ],
                        ),
                      ),
                    ),
                  ), )
            ]),
          ),
        ));
  }

  Widget showImages(int index) {
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new ImagePreviewer(urlString: widget.product.returnCondition![index]!.fileUrl!,
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
                      image:widget.product.returnCondition!.isNotEmpty!
                          ? NetworkImage(widget.product.returnCondition![index]!.fileUrl!)
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

}
