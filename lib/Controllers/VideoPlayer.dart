import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import '../Extensions/style.dart';


 class VideoPlayerView extends StatefulWidget {
  static const String route = "VideoPlayerView";
  // const VideoPlayerView({Key? key}) : super(key: key);
  File? videosImages;
  String? videoUrl;
  bool? isFromCreate;
  double? height;
  double? widht;


  VideoPlayerView({required this.videosImages ,  this.videoUrl, this.isFromCreate , this.height , this.widht} );


  @override
  _VideoPlayerViewState createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {

   File? Videos = null;
   // late ChewieController?_chewieController;
   late VideoPlayerController? contrView;
   late ChewieController?  _chewieController;
   BuildContext? contextBuild;

   @override
   void dispose() {
     widget.videosImages = null;
     contrView!.removeListener(() {
       widget.videosImages = null;
        Videos = null;
     });
     contrView!.dispose();
     super.dispose();
   }


   playVideo()  {
     if (widget.isFromCreate?? false) {
       contrView  =  VideoPlayerController.file(Videos!);
       contrView?.addListener(() {
         setState(() {});
       });
       contrView?.setLooping(false);
       contrView?.initialize();

     }else {
       contrView  =  VideoPlayerController.network(widget!.videoUrl!);
       contrView?.addListener(() {
         setState(() {});
       });
       contrView?.setLooping(false);
       contrView?.initialize();

     }
   }

   @override
  void initState() {
    // TODO: implement initState

     super.initState();

    if (widget.isFromCreate ?? false) {
      Videos = widget.videosImages!;
      contrView = null;
      contrView  =  VideoPlayerController.file(Videos!);
      _chewieController = ChewieController(
        videoPlayerController: contrView!,
        maxScale: 1.5,
        autoInitialize: true,
        autoPlay: false,
        looping: false,
        fullScreenByDefault: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      );

    }else {
      contrView  =  VideoPlayerController.network(widget!.videoUrl!);
      _chewieController = ChewieController(
        videoPlayerController: contrView!,
        maxScale: 1.5,
        deviceOrientationsAfterFullScreen:[DeviceOrientation.landscapeLeft , DeviceOrientation.landscapeRight , DeviceOrientation.portraitUp , DeviceOrientation.portraitDown] ,
        autoInitialize: true,
        autoPlay: false,
        looping: false,
        showOptions: true,
        showControls: true,
        fullScreenByDefault: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      );
    }
   }

   @override
  Widget build(BuildContext context) {
    // TODO: implement build

     contextBuild = context;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          "Video Player View",
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

            Navigator.pop( context , widget.videosImages);

          },
        ),
      ),
      body:  Padding(
    padding: const EdgeInsets.all(8.0),
     child: Container(
       color: Colors.black,
         height: MediaQuery.of(context).size.height/2,
         width: MediaQuery.of(context).size.width,
         child: Padding(
           padding: const EdgeInsets.all(0.0),
           child: Chewie(
             controller: _chewieController! ,
           ),
         ),
     ),
     ),
    );
  }

}