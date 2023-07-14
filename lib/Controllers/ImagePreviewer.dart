import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import '../Extensions/style.dart';


class ImagePreviewer extends StatefulWidget {
  static const String route = "ImagePreviewer";
  File? images;
  String? urlString;


  ImagePreviewer({this.images , this.urlString });


  @override
  _ImagePreviewerViewState createState() => _ImagePreviewerViewState();
}

class _ImagePreviewerViewState extends State<ImagePreviewer> {


  Widget showImage() {
    if (widget.images != null) {
      return PhotoView(
        imageProvider: FileImage(widget!.images!),
      );
    }else {
      return PhotoView(
        imageProvider: NetworkImage(widget!.urlString!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          "Image Preview",
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

            Navigator.pop( context );

          },
        ),
      ),
      body: showImage(),
    );
  }


}