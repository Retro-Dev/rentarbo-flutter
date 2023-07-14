import 'package:flutter/cupertino.dart';
// import 'package:geocoder/geocoder.dart';
import 'package:geocode/geocode.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressModel {
  String? fullAddress, shortAddress;
  LatLng? latLng;
  double? zoomLevel;
  List<Placemark>? address;

  AddressModel({
    @required this.fullAddress,
    @required this.shortAddress,
    @required this.latLng,
    this.address,
    this.zoomLevel,
  });
}
