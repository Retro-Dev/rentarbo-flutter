import 'dart:ffi';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Controllers/EditPost.dart';
import '../Controllers/ImagePreviewer.dart';
import '../Controllers/VideoViewScreen.dart';
import '../Extensions/style.dart';
import '../Models/Ads.dart';
import '../Utils/Ads_services.dart';
import '../Utils/Const.dart';
import '../Utils/utils.dart';
import '../View/views.dart';
import 'custom_button.dart';
import 'custom_outline_button.dart';

class ImageSlider extends StatefulWidget {
  final Widget? icRight;
  final Widget? icLeft;
  final VoidCallback? onPressed;

  bool? isFromCreatePost , isFromMyAds;
  List<File?> images;
  List<File?> videosImages;
  AdsObj? adsObj;
  List<bool> isVideoI;

  ImageSlider(
      {Key? key,
      this.icLeft,
      this.icRight,
      this.onPressed,
      required this.images,
      this.isFromCreatePost,
      this.adsObj,
      required this.isVideoI,
      required this.videosImages,
        this.isFromMyAds,
      })
      : super(key: key);

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _current = 0;

  List<File?>? imgimages = [];
  List<File?>? videvideosImages = [];
  List<bool>? isVideoIs = [];

  // ChewieController? _chewieController;

  @override
  void dispose() {
    // TODO: implement dispose

    imgimages = null;
    videvideosImages = null;
    isVideoIs = null;
    _controller = null;
    super.dispose();
    print("-----------Dispose Called----------------Image Slider_-----------");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("-----------Init Called----------------Image Slider_-----------");
    imgimages = widget.images;
    videvideosImages = widget.videosImages;
    isVideoIs = widget.isVideoI;
    // videsExt();
    // _chewieController = ChewieController(
    //   videoPlayerController: _controllerVideo,
    //   aspectRatio:5/8,
    //   autoInitialize: true,
    //   errorBuilder: (context, errorMessage) {
    //     return Center(
    //       child: Text(
    //         errorMessage,
    //         style: TextStyle(color: Colors.white),
    //       ),
    //     );
    //   },
    // );
  }

  CarouselController? _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final controller = PageController();
    var img = [
      Style.getTempImage("slider-img-4.png"),
      Style.getTempImage("slider-img-4.png"),
      Style.getTempImage("slider-img-4.png")
    ];

    Widget isFromCreatePost() {
      if (widget.isFromCreatePost ?? false) {
        return CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            height: 350.0,
            enlargeCenterPage: false,
            viewportFraction: 1,
            onPageChanged: (position, reason) {
              debugPrint(reason.toString());
              print(CarouselPageChangedReason.controller);
              _current = position;
              setState(() {});
            },
            enableInfiniteScroll: false,
          ),
          items: imgimages?.map<Widget>((i) {
            return Builder(
              builder: (BuildContext context) {
                return Stack(children: [
                  Container(
                    child: ShaderMask(
                        shaderCallback: (rect) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withAlpha(150)
                            ],
                          ).createShader(Rect.fromLTRB(0, 0, 0, 330));
                        },
                        blendMode: BlendMode.srcOver,
                        child: InkWell(
                          onTap: () {
                            print("Open Image");
                            if (!widget.isVideoI[_current])
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => new ImagePreviewer(images: i!,
                                    ))).then((value) {
                              setState(() {});
                            });
                          },
                          child: InteractiveViewer(
                            panEnabled: false,
                            // Set it to false
                            boundaryMargin: EdgeInsets.all(0),
                            minScale: 1,
                            maxScale: 1,
                            // child: Image.network(
                            //   '${widget.choreData?.imageUrl ?? ''}',
                            //   height: 315,
                            //   width: MediaQuery.of(context).size.width,
                            //   fit: BoxFit.fill,
                            //
                            // ),
                            child: Image.file(
                              i!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                  ),
                  if(widget.isFromMyAds ?? false)
                  Positioned(
                    right: 10.w,
                    top: 20.h,
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        width: 50,
                        height: 50,
                        child: Icon(Icons.edit),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(20),
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
                  ),
                  if (isVideoIs![_current])
                    Positioned(
                      right: 130.w,
                      top: 100.h,
                      child: SizedBox(
                        width: 80.w,
                        height: 80.w,
                        child: InkWell(
                          onTap: () {
                            print(videvideosImages![_current]);
                            Navigator.pushNamed(context, VideoViewScreen.route, arguments: {
                "sourceType": VideoSource.FILE,
                "videoFile": videvideosImages![_current],
                              "source": "videoFile",

                            });
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => new VideoPlayerView(
                            //               videosImages:
                            //                   videvideosImages![_current],
                            //               isFromCreate: widget.isFromCreatePost,
                            //           height: MediaQuery.of(context).size.height,
                            //           widht:  MediaQuery.of(context).size.width,
                            //             ))).then((value) {
                            //   setState(() {});
                            // });
                          },
                          child: Image.asset(
                            "src/playicon.png",
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                  //
                ]);
              },
            );
          }).toList(),
        );
      }
      else {
        print(widget.adsObj?.media?.length);

        if (widget.adsObj!.media!.length > 0) {
          return CarouselSlider(
            carouselController: _controller,
            options: CarouselOptions(
              height: 350.0,
              enlargeCenterPage: false,
              viewportFraction: 1,
              onPageChanged: (position, reason) {
                debugPrint(reason.toString());
                print(CarouselPageChangedReason.controller);
                _current = position;
                setState(() {});
              },
              enableInfiniteScroll: false,
            ),
            items: widget.adsObj?.media?.map<Widget>((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Stack(children: [
                    Container(
                      child: ShaderMask(
                        shaderCallback: (rect) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withAlpha(200)
                            ],
                          ).createShader(Rect.fromLTRB(0, 0, 0, 330));
                        },
                        blendMode: BlendMode.srcOver,
                        child: InteractiveViewer(
                          panEnabled: false,
                          // Set it to false
                          boundaryMargin: EdgeInsets.all(0),
                          minScale: 1,
                          maxScale: 1,
                          // child: Image.network(
                          //   '${widget.choreData?.imageUrl ?? ''}',
                          //   height: 315,
                          //   width: MediaQuery.of(context).size.width,
                          //   fit: BoxFit.fill,
                          //
                          // ),
                          child: InkWell(
                            onTap: () {
                              print("Open Image");
                              if(i?.fileType == "image")
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => new ImagePreviewer(urlString: i?.fileType == "image" ? i?.fileUrl :i?.thumbnailUrl ,
                                      ))).then((value) {
                                setState(() {});
                              });
                            },
                            child:  i?.fileType == "image"
                                    ?   circularImageView(image: "${i?.fileUrl}" ,size: 300.h)
                                    : circularImageView(image: "${i?.thumbnailUrl}" , size: 300.h),
                          ),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                    ),
                    if(widget.isFromMyAds ?? false)
                    Positioned(
                      right: 8.w,
                      top: 50.h,
                      child: InkWell(
                        onTap: () {

                          print("Edit");
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (context) => EditPostAd(widget.adsObj)
                  )
                  ).then((valueadj) {
                    if (valueadj == "back") {
                      showLoading();
                      getAdsDetails(slug: widget.adsObj?.slug ?? "", onSuccess: (data) {
                        print("--------Ads Slug--------");
                        print(data);
                        print("--------Ads Slug--------");
                        setState((){
                          widget.adsObj = data;
                        });

                        hideLoading();
                      }, onError: (error) {
                        toast(error);
                        hideLoading();
                      });
                    }else {
                      Navigator.pop(context,"ads");
                    }
                  print(valueadj);

                  });


                },
                        child: Container(
                          width: 50,
                          height: 50,
                          child: Icon(Icons.edit , color: Colors.black,),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(35.h),
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
                    ),
                    if(widget.isFromMyAds ?? false)
                    SizedBox(
                      width: 35.w,
                    ),
                    if(widget.isFromMyAds ?? false)
                    Positioned(
                      right: 70.w,
                      top: 50.h,
                      child: InkWell(
                        onTap: () {
                          print("Deleted");
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) =>
                                  ThankYoupopUp()
                            //thankYouDialog(navigationViewModel,context)
                          );

                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          child: Icon(Icons.delete , color: Colors.black,),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(35.h),
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
                    ),
                    if (widget.adsObj!.media![_current]?.fileType == "video")
                      Positioned(
                        right: 130.w,
                        top: 100.h,
                        child: SizedBox(
                          width: 80.w,
                          height: 80.w,
                          child: InkWell(
                            onTap: () {
                              print(widget.adsObj!.media![_current]);


                              Navigator.pushNamed(context, VideoViewScreen.route, arguments: {
                                "sourceType": VideoSource.URL,
                                "source": "${ widget!.adsObj!
                             .media![_current]!.fileUrl}" ,
                                "videoFile" : File("VideoFile.mp4"),

                              });
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => new VideoPlayerView(
                              //               videosImages: null,
                              //               isFromCreate:
                              //                   widget.isFromCreatePost,
                              //               videoUrl: widget!.adsObj!
                              //                   .media![_current]!.fileUrl,
                              //           height: MediaQuery.of(context).size.height,
                              //           widht:  MediaQuery.of(context).size.width,
                              //             ))).then((value) {
                              //   setState(() {});
                              // });
                            },
                            child: Image.asset(
                              "src/playicon.png",
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ]);
                },
              );
            }).toList(),
          );
        } else {
          return Stack(
            children: [
              Builder(
                builder: (BuildContext context) {
                  return Container(
                    height: 350,
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withAlpha(150)],
                        ).createShader(Rect.fromLTRB(0, 0, 0, 330));
                      },
                      blendMode: BlendMode.srcOver,
                      child: InteractiveViewer(
                        panEnabled: false,
                        // Set it to false
                        boundaryMargin: EdgeInsets.all(0),
                        minScale: 1,
                        maxScale: 1,
                        // child: Image.network(
                        //   '${widget.choreData?.imageUrl ?? ''}',
                        //   height: 315,
                        //   width: MediaQuery.of(context).size.width,
                        //   fit: BoxFit.fill,
                        //
                        // ),
                        child: FadeInImage(
                          // height: 50,
                          // width: 50,
                            fadeInDuration: const Duration(milliseconds: 500),
                            fadeInCurve: Curves.easeInExpo,
                            fadeOutCurve: Curves.easeOutExpo,
                            placeholder: AssetImage("src/placeholder.png"),
                            image: Image.asset("src/placeholder.png").image,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Container(
                                  child: Image.asset("src/placeholder.png" , height: 300, fit: BoxFit.cover,));
                            },
                            fit: BoxFit.cover),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                  );
                },
              ),
              if(widget.isFromMyAds ?? false)
                Positioned(
                  right: 8.w,
                  top: 40.h,
                  child: InkWell(
                    onTap: () {

                      print("Edit");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditPostAd(widget.adsObj)
                          )
                      ).then((valueadj) {
                        print(valueadj);
                        showLoading();
                        getAdsDetails(slug: widget.adsObj?.slug ?? "", onSuccess: (data) {


                          setState((){
                            widget.adsObj = data;
                          });

                          hideLoading();
                        }, onError: (error) {
                          toast(error);
                          hideLoading();
                        });

                      });


                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      child: Icon(Icons.edit , color: Colors.black,),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35.h),
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
                ),
              if(widget.isFromMyAds ?? false)
                SizedBox(
                  width: 35.w,
                ),
              if(widget.isFromMyAds ?? false)
                Positioned(
                  right: 70.w,
                  top: 40.h,
                  child: InkWell(
                    onTap: () {
                      print("Deleted");
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) =>
                              ThankYoupopUp()
                        //thankYouDialog(navigationViewModel,context)
                      );

                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      child: Icon(Icons.delete , color: Colors.black,),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35.h),
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
                ),
            ],
          );
        }
      }
    }

    Widget isFromCreatePostPoints() {
      if (widget.isFromCreatePost ?? false) {
        return Positioned(
          bottom: 70.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: this.widget.images.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller?.animateToPage(entry.key),
                child: Container(
                  width: 8.0,
                  height: 8.0,
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
        );
      }
      else { return Positioned(
          bottom: 70.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.adsObj!.media!.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller?.animateToPage(entry.key),
                child: Container(
                  width: 8.0,
                  height: 8.0,
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
        );
      }
    }

    return Stack(alignment: Alignment.topCenter, children: [
      isFromCreatePost(),
      isFromCreatePostPoints(),
      Padding(
        padding: const EdgeInsets.only(top: 60.0, right: 9, left: 9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
                child:widget.icLeft),
            Spacer(),
            GestureDetector(
              onTap: widget.onPressed,
              child: widget.icRight,
            ),
          ],
        ),
      ),
    ]);
  }


  Widget circularImageView(
      {required String image, double size = 50, bool profile = true}) {
    return CachedNetworkImage(
      // imageUrl: "http://via.placeholder.com/350x150",
      imageUrl: image,
      fit: BoxFit.cover,
      placeholder: (context, url) => FittedBox(
        fit: BoxFit.cover,
        child: Image.asset('src/placeholder.png' , fit: BoxFit.cover,),
      ),
      errorWidget: (context, url, error) => FittedBox(
          child: Image.asset(
            profile ? 'src/placeholder.png' : 'src/placeholder.png',
            fit: BoxFit.cover,
          )),
      height: 300.w,
      width: size.w,
      memCacheHeight: 800 ,
      memCacheWidth: 800,
      maxHeightDiskCache: 800,
      maxWidthDiskCache: 800,
      // imageBuilder: (context, imageProvider) => CircleAvatar(
      // backgroundImage: imageProvider,
      // radius: 50.r,
      // ),
      // fit: BoxFit.cover,
    );
  }


  Widget ThankYoupopUp() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        height: 230,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Alert!",
                style: Style.getBoldFont(
                  22.sp,
                ),
              ),
              SizedBox(
                height: 22.h,
              ),
              Text(
                "Are you sure you want to delete the post?",
                textAlign: TextAlign.center,
                style: Style.getMediumFont(
                  12.sp,
                ),
              ),
              SizedBox(
                height: 22.h,
              ),
              // CustomButton(
              //     btnText: "Goto Home",
              //     color: Style.redColor,
              //     onPressed: () {
              //       homeNavigationViewModel.currentScreenIndex = 0;
              //       Navigator.pushNamedAndRemoveUntil(
              //           context, Constants.home, (route) => false);
              //     })
              Row(
                children: [
                  Expanded(child:CustomButton(
                    btnText: "Yes",
                    radius: 25.w,
                    height: 50.w,
                    width: MediaQuery.of(context).size.width,
                    fontSize: 12.sp,
                    fontstyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontFamily: Const.aventa,
                      fontStyle: FontStyle.normal,
                      fontSize: 18.sp,
                    ),
                    onPressed: () {

                      showLoading();


                      deleteAds(slug: widget.adsObj!.slug!, onSuccess: (data) {

                        hideLoading();

                        toast(data.message);
                        Navigator.pop(context,data);
                        Navigator.pop(context,data);


                      }, onError: (error) {
                        hideLoading();
                        toast(error);

                      });
                    },
                  )
                  ),
                  SizedBox(width: 15.w,),
                  Expanded(child:CustomOutlineButton(
                    btnText: "Cancel",
                    radius: 25.w,
                    height: 50.w,
                    width: MediaQuery.of(context).size.width,
                    fontSize: 12.sp,
                    fontstyle: TextStyle(
                      color: Style.redColor,
                      fontWeight: FontWeight.w400,
                      fontFamily: Const.aventa,
                      fontStyle: FontStyle.normal,
                      fontSize: 18.sp,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ) )
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
