import 'package:flutter/material.dart';
// import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'Const.dart';
import '../View/views.dart';
import 'AddressModel.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geocode/geocode.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/services.dart';

import 'Dialogs.dart';


class HelpingMethods {
  // final geocodeInstant = GeoCode(apiKey: Const.MAP_API_KEY);
  // bool isEmailValid(String email) {
  //   Pattern pattern =
  //       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  //   RegExp regex = RegExp(pattern);
  //   return (!regex.hasMatch(email)) ? false : true;
  // }

  // static Future<Uint8List> getBytesFromAsset(String path, int width) async {
  //   ByteData data = await rootBundle.load(path);
  //   Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
  //       targetWidth: width);
  //   FrameInfo fi = await codec.getNextFrame();
  //   return (await fi.image.toByteData(format: ImageByteFormat.png))
  //       .buffer
  //       .asUint8List();
  // }

  // Future<File> getImage(
  //     ImagePicker imagePicker, ImageSource imageSource) async {
  //   final pickedFile =
  //       await imagePicker.pickImage(source: imageSource, imageQuality: 80, );
  //   return pickedFile == null ? null : File(pickedFile.path);
  // }

  Future<AddressModel> getAddress(double lat, double lng, {double? zoom}) async {
    // final coordinates = new Geo(lat, lng);
    // final coordinates = geocodeInstant.reverseGeocoding(latitude: lat, longitude: lng);
    final coordinates = placemarkFromCoordinates(lat, lng);
    // var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    // GeocodingPlatform.instance.placemarkFromCoordinates(coordinates.latitude, coordinates.l)
    // var addresses = await GeocodingPlatform.google(Const.MAP_API_KEY,language: "en").findAddressesFromCoordinates(coordinates);
    // addresses.first;

    var addresses = await placemarkFromCoordinates(lat,lng);
    for (var vale in addresses) {
      print("Places ${vale}");
    }

    // List<Placemark> placemarkAddress = await placemarkFromCoordinates(lat, lng);
    String fullAddress = addresses.first.street! + ", "  + addresses.first.administrativeArea! + ", " + addresses.first.postalCode!;
    String shortAddress =
        addresses.first.street ?? "" + ", " + addresses.first.country!;
    return AddressModel(
        fullAddress: fullAddress,
        shortAddress: shortAddress,
        address: addresses,
        zoomLevel: zoom,
        latLng: LatLng(lat, lng));
  }

  Widget permissionDialog(
      {required String title,
      required String content,
       String? rightBtnText,
       Function? rightBtn,
       String? leftBtnText,
        Function? leftBtn,
       required BuildContext context}) {
    return Dialogs.alertDialog(
      context: context,
      title: title,
      height: 13,
      width: 10,
      content: content,
      leftBtnText: leftBtnText,
      rightBtnText: rightBtnText,
      rightBtnTap: rightBtn,
      leftBtnTap: leftBtn != null
          ? leftBtn
          : () {
              Navigator.pop(context!);
            },
    );
  }

  Future<Position?> getCurrentLocation(
      {required BuildContext buildContext,
      required bool? serviceEnabled,
      required LocationPermission permission}) async {
    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        toast('Location services are disabled.');
        showDialog(
            context: buildContext,
            builder: (BuildContext context) => permissionDialog(
                title: "Location service is disabled",
                content:
                    "Please go to Settings${Platform.isIOS ? ">Privacy>Location Services" : ""} to enable Location Service.",
                rightBtnText: Platform.isIOS ? "OK" : "GO TO SETTINGS",
                rightBtn: () async {
                  Navigator.pop(buildContext);
                  if (Platform.isAndroid)
                    await Geolocator.openLocationSettings();
                },
                leftBtnText: "${Platform.isIOS}" ,
                context: buildContext, leftBtn: () {}),
            barrierDismissible: false);
        return Future.error('services disabled');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          toast('Location permissions are denied');
          return Future.error('denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        //toast(
         //   'Location permissions are permanently denied, we cannot request permissions.');
        showDialog(
            context: buildContext,
            builder: (BuildContext context) => permissionDialog(
                title: "Location permission is disabled",
                content: "Please go to settings to enable location permission.",
                rightBtnText: "Setting",
                rightBtn: () async {
                  Navigator.pop(buildContext);
                  await Geolocator.openAppSettings();
                },
                leftBtnText: "NO",
                context: buildContext, leftBtn: () {}),
            barrierDismissible: false);
        return Future.error('permanently denied');
      }
    } catch (e) {
      toast('$e');
      return null;
    }
    return await Geolocator.getCurrentPosition();
  }
}
