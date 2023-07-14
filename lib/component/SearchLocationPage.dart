import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:geocoder/geocoder.dart';
// import 'package:geocode/geocode.dart';
import 'package:geocoding/geocoding.dart';
import '../Utils/Const.dart';
import '../Utils/helping_methods.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../View/views.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

import 'custom_button.dart';

class SearchLocationPage extends StatefulWidget {
  static const String route = 'SearchLocationPage';
  LatLng? userLatLng;

  SearchLocationPage({this.userLatLng});

  @override
  _SearchLocationPageState createState() => _SearchLocationPageState();
}

class _SearchLocationPageState extends State<SearchLocationPage>
    with WidgetsBindingObserver {
  Completer<GoogleMapController> _controller = Completer();
   bool? serviceEnabled,
      locationDenied = false,
      serviceDenied = false;
  LocationPermission? permission;
   LatLng? latLng;

  animateCamera(LatLng latlng) {
    widget.userLatLng = latlng;
    _controller.future.then((value) {
      value.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(latlng.latitude, latlng.longitude),
        zoom: 15,
      )));
    });
  }

  late TextEditingController searchEditTextController;
  @override
  void initState() {
    latLng = widget.userLatLng;
    searchEditTextController = TextEditingController();
    WidgetsBinding.instance.addObserver(this);
    if (widget.userLatLng != null) {
      handlePermission();
      animateCamera(widget.userLatLng!);
    } else {
      // widget.userLatLng = LatLng(40.7128, 74.0060);

    }
    super.initState();
  }

  handlePermission() {

    HelpingMethods()
        .getCurrentLocation(
      buildContext: context,
      permission: permission ?? LocationPermission.denied,
      serviceEnabled: serviceEnabled ?? false,
    )
        .then((position) {
      if (position != null) {
        if (widget.userLatLng == null) {
          latLng = LatLng(position.latitude, position.longitude);
        }
        animateCamera(LatLng(position.latitude, position.longitude));
      }
    }).catchError((error) {
      if (error == 'services disabled') {
        serviceDenied = true;
        return;
      }
      if (error == 'permanently denied') locationDenied = true;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (serviceDenied ?? false) {
        Geolocator.isLocationServiceEnabled().then((serviceEnabled) {
          if (serviceEnabled) {
            serviceDenied = false;
            handlePermission();
          }
        });
        return;
      }
      if (locationDenied ?? false) {
        Geolocator.checkPermission().then((permission) async {
          if (permission == LocationPermission.always) {
            locationDenied = false;
            await Geolocator.getCurrentPosition().then((position) {
              if (position != null) {
                latLng = LatLng(position.latitude, position.longitude);
                animateCamera(LatLng(position.latitude, position.longitude));
              }
            });
          }
        });
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (latLng != null)
      Navigator.pop(context,
          HelpingMethods().getAddress(latLng!.latitude, latLng!.longitude));
    return Future<bool>.value(true);
  }

  @override
  Widget build(BuildContext context) {
    double screeSize = MediaQuery
        .of(context)
        .size
        .width;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SizedBox(
              // height: 30,
              // width: 30,
              child: Image.asset("src/backimg@3x.png" ,scale: 2,),
            ),
          ),
          title: Text("Search Location" , style: TextStyle(fontFamily:  Const.aventa ,fontSize: 22.sp, color: Colors.black , fontWeight: FontWeight.w500),),
          elevation: 0,

        ),
        body: Stack(
          children: [
            Padding(
              padding:  EdgeInsets.only(top: 10),
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: widget.userLatLng!,
                  zoom: 15,
                ),
                myLocationButtonEnabled: false,
                myLocationEnabled: false,
                zoomControlsEnabled: false,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                onCameraMove: (position) {
                  widget.userLatLng =
                      LatLng(position.target.latitude, position.target.longitude);

                },onCameraIdle: () async {
                // HelpingMethods().getAddress(widget.userLatLng!.latitude,
                //     widget.userLatLng!.longitude).then((value) {
                //   searchEditTextController.text = value.fullAddress!;
                //       //value.address!.last.street! + " " + value.address!.last.administrativeArea! + " " + value.address!.last.locality! ;
                //   // "${value.address!.last.name!.isEmpty ?  value.address!.last.street! : value.address!.last.name!}, ${value.address!.last!.subAdministrativeArea!.isEmpty ? value.address!.last!.administrativeArea : value.address!.last!.subAdministrativeArea },${(value.address!.last.subLocality!.isEmpty ? value.address!.last!.locality!.isEmpty ? value.address!.last!.country! : value.address!.last!.isoCountryCode! : value.address!.last!.subLocality!.isEmpty ?  value.address!.last!.postalCode! : value.address!.last!.isoCountryCode! ) }    ";
                //
                // });
                await getAddressFromLatLng(widget.userLatLng!.latitude ?? 0.0, widget.userLatLng!.longitude ?? 0.0).then((value) {
                  searchEditTextController.text = value;
                  setState((){});
                  // animateCamera(LatLng(placeDetails.lat ?? 0.0, placeDetails.lng ?? 0.0));
                });
              },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 0 ),
              width: screeSize,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.white.withOpacity(0.0)],
                  stops: [0.5, 1],
                  end: Alignment.bottomCenter,
                  begin: Alignment.topCenter,
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 23, right: 23, top: 20),
                width: screeSize,
                height: 54,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        offset: Offset(0, 2),
                        blurRadius: 0.3,
                        spreadRadius: 0),
                    BoxShadow(
                      color: Color(0x6778849e),
                    ),
                  ],
                ),
                child: Container(
                  height: 54,
                  width: screeSize,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.3,
                      blurRadius: 0.2,
                      offset: Offset(0.3, 0.5), // changes position of shadow
                    ),
                  ],
                  ),
                  child: TextField(
                    controller: searchEditTextController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      icon: Container(
                        width: 10,
                        height: 10,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10 , bottom: 7 ),
                          child: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      hintText: "Search a location",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 16.0, top: 10.0),
                    ),
                    onTap: ()  async {
                      final sessionToken = Uuid().generateV4();
                      final Suggestion? result = await showSearch(
                        context: context,
                        delegate: AddressSearch(sessionToken),
                      );
                      if (result != null) {
                        final Place placeDetails = await PlaceApiProvider(
                            sessionToken)
                            .getPlaceDetailFromId(result.placeId);

                        await getAddressFromLatLng(placeDetails.lat ?? 0.0, placeDetails.lng ?? 0.0).then((value) {
                          searchEditTextController.text = value;
                          setState((){});
                          animateCamera(LatLng(placeDetails.lat ?? 0.0, placeDetails.lng ?? 0.0));
                        });
                      }
                    },
                    // hintText: "Search Location",
                    // suffixIcon: "src/search_icon.png", context: context,
                  ),
                )),
            Positioned(
              bottom: 31,
              left: 27,
              right: 27,
              child: Container(
                width: screeSize,
                child:
                CustomButton(
                    btnText: "Confirm",
                    radius: 25.w,
                    height: 50.w,
                    width: MediaQuery.of(context).size.width,
                    fontSize: 12.sp,
                    fontstyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontFamily: Const.aventa,
                      fontStyle: FontStyle.normal,
                      fontSize: 18.sp,
                    ),
                    onPressed: () async {
                      Navigator.pop(
                          context,
                          HelpingMethods().getAddress(widget.userLatLng!.latitude,
                              widget.userLatLng!.longitude));

                      // var list = await GeoCoder.local.findAddressesFromQuery('75001');
                      var list = await placemarkFromCoordinates(widget.userLatLng!.latitude, widget.userLatLng!.longitude);
                      print('list: '+list.toString());
                    }),
                // MyButtonWithgradient(
                //   height: 18,
                //   text: 'CONFIRM',
                //   // letterSpacing: 0.8,
                //   color: Colors.white,
                //   // textColor: Colors.white,
                //   onPress: () async {
                //     Navigator.pop(
                //         context,
                //         HelpingMethods().getAddress(widget.userLatLng.latitude,
                //             widget.userLatLng.longitude));
                //
                //     // var list = await GeoCoder.local.findAddressesFromQuery('75001');
                //     var list = await placemarkFromCoordinates(widget.userLatLng.latitude, widget.userLatLng.longitude);
                //     print('list: '+list.toString());
                //     //list[0].addressLine+", "+list[0].subAdminArea+", "+list[0].adminArea
                //     //Addison, TX 75001, USA, Dallas County, Texas
                //   },
                // ),
              ),
            ),
            Positioned(
              bottom: 100,
              right: 19,
              child: IconButton(
                iconSize: 53,
                icon: Image.asset("src/locationBtn.png"), onPressed: () { handlePermission(); },
              ),
            ),
            Center(
              child: Image.asset(
                'src/icons8-location-96.png',
                scale: 2,
              ),
            ),
            // MyHomePage(title: 'Places Autocomplete Demo'),
          ],
        ),
      ),
    );
  }
}

/*class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = TextEditingController();
  String _streetNumber = '';
  String _street = '';
  String _city = '';
  String _zipCode = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _controller,
              readOnly: true,
              onTap: () async {
                // generate a new token here
                final sessionToken = Uuid().generateV4();
                final Suggestion result = await showSearch(
                  context: context,
                  delegate: AddressSearch(sessionToken),
                );
                // This will change the text displayed in the TextField
                if (result != null) {
                  final placeDetails = await PlaceApiProvider(sessionToken)
                      .getPlaceDetailFromId(result.placeId);
                  setState(() {
                    _controller.text = result.description;
                    _streetNumber = placeDetails.streetNumber;
                    _street = placeDetails.street;
                    _city = placeDetails.city;
                    _zipCode = placeDetails.zipCode;
                  });
                }
              },
              decoration: InputDecoration(
                icon: Container(
                  width: 10,
                  height: 10,
                  child: Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                ),
                hintText: "Enter your shipping address",
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 8.0, top: 16.0),
              ),
            ),
            SizedBox(height: 20.0),
            Text('Street Number: $_streetNumber'),
            Text('Street: $_street'),
            Text('City: $_city'),
            Text('ZIP Code: $_zipCode'),
          ],
        ),
      ),
    );
  }
}*/

class AddressSearch extends SearchDelegate<Suggestion> {
  AddressSearch(this.sessionToken) {
    apiClient = PlaceApiProvider(sessionToken);
  }

  final sessionToken;
  PlaceApiProvider? apiClient;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: SizedBox(
        child: Image.asset("src/backimg@3x.png" ,scale: 2,),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: query == ""
          ? null
          : apiClient?.fetchSuggestions(
          query,'en'
        // Localizations
        // .localeOf(context)
        // .languageCode
      ),
      builder: (context, snapshot) =>
      query == ''
          ? Container(
        padding: EdgeInsets.all(16.0),
        child: Text(''),//Enter your address
      )
          : snapshot.hasData
          ? Container(
        color: Colors.white,
            child: ListView.builder(
        itemBuilder: (context, index) => ListTile(
            title:
            Text((snapshot.data as List<Suggestion>)[index].description),
            onTap: () {
              // dataSnap = snapshot.data as List<String>;
              close(context, (snapshot.data as List<Suggestion>)[index]);
            },
        ),
        itemCount: (snapshot.data as List<Suggestion>).length,
      ),
          )
          : Container(child: Text('Loading...')),
    );
  }
}

// For storing our result
class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}
class PlaceApiProvider {
  PlaceApiProvider(this.sessionToken);

  final sessionToken;
  final String country = 'US';
  // final String country = 'PK';

  static final String androidKey = Const.MAP_API_KEY;
  static final String iosKey = Const.MAP_API_KEY;
  final apiKey = Platform.isAndroid ? androidKey : iosKey;

  Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=geocode&language=$lang&components=country:$country&key=$apiKey&sessiontoken=$sessionToken';
    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      print("-------------------------Suggestion List--------------------");
      print(result.toString());
      print("-------------------------Suggestion List--------------------");
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<Place> getPlaceDetailFromId(String placeId) async {
    // final request =
    //     'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_component&key=$apiKey&sessiontoken=$sessionToken';
    final request =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey&sessiontoken=$sessionToken';

    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        var latlngJson = result['result']['geometry']['location'];
        final components =
        result['result']['address_components'] as List<dynamic>;
        // build result
        final place = Place();
        if(latlngJson!=null){
          place.lat = latlngJson['lat'];
          place.lng = latlngJson['lng'];
        }
        components.forEach((c) {
          final List type = c['types'];
          if (type.contains('street_number')) {
            place.streetNumber = c['long_name'];
          }
          if (type.contains('route')) {
            place.street = c['long_name'];
          }
          if (type.contains('locality')) {
            place.city = c['long_name'];
          }
          if (type.contains('postal_code')) {
            place.zipCode = c['long_name'];
          }
        });
        return place;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }


}

class Place {
  String? streetNumber;
  String? street;
  String? city;
  String? zipCode;
  double? lat;
  double? lng;

  Place({
    this.streetNumber,
    this.street,
    this.city,
    this.zipCode,
  });

  @override
  String toString() {
    return 'Place(streetNumber: $streetNumber, street: $street, city: $city, zipCode: $zipCode)';
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}


Future<String> getAddressFromLatLng(double lat, double lng) async {
  var location = "Undefined Location";
  await placemarkFromCoordinates(
      lat, lng)
      .then((List<Placemark> placemarks) {
    Placemark place = placemarks[0];
    print(place);
    if(place.subLocality == "" || place.subAdministrativeArea == ""){
      location = place.name! + " "  + place.locality! + ", " + place.administrativeArea!;
    }
    else{
      location = place.name! + " " + place.subLocality! + ", " + place.subAdministrativeArea!;
    }
    // location = place.subLocality!.isNotEmpty ? "${place.subLocality!}, " + place.subAdministrativeArea! : place.subAdministrativeArea!;
    // place.subLocality! + ", " + place.subAdministrativeArea!;
    return location;
  }).catchError((e) {
    return "Undefined Location";
    debugPrint(e);
  });
  return location;
}