import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:toast/toast.dart';
import 'package:tracking/success_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Camera/camera.dart';

class MapView extends StatefulWidget {

  var status;
  MapView({this.status});

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MapView> {
  GoogleMapController mapController;
  LocationData currentLocation;
  MapType _currentMapType = MapType.normal;
  double lastlat;
  double lastlong;

  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _goToMe();
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  Future<LocationData> getCurrentLocation() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        Toast.show("กรุณาเปิด permission ก่อน", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('หน้าแผนที่'),
        ),
        body: Stack(children: <Widget>[
          GoogleMap(
            myLocationEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: false,
            onMapCreated: _onMapCreated,
            markers: _markers,
            initialCameraPosition: CameraPosition(
              target: LatLng(13.7650836, 100.5379664),
              zoom: 16,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  /* FloatingActionButton(
                    onPressed: _onMapTypeButtonPressed,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.map, size: 36.0),
                  ),
                  SizedBox(height: 16.0),
                  FloatingActionButton(
                    onPressed: _onAddMarkerButtonPressed,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.add_location, size: 36.0),
                  ), */
                ],
              ),
            ),
          ),
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FloatingActionButton.extended(
                heroTag: "btn1",
                onPressed: _goToMe,
                label: Text('พิกัดของฉัน'),
                icon: Icon(Icons.near_me),
              ),
              FloatingActionButton.extended(
                heroTag: "btn2",
                onPressed: () {
                  SendLocation(context);
                },
                label: Text('ส่งพิกัด'),
                icon: Icon(Icons.near_me),
              )
            ],
          ),
        ));
  }

  _openOnGoogleMapApp(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      // Could not open the map.
    }
  }

  Future _goToMe() async {
    Toast.show("พิกัดของฉัน", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

    final GoogleMapController controller = await mapController;
    currentLocation = await getCurrentLocation();
    //print('Lat = ${currentLocation.latitude} , Lat = ${currentLocation.longitude}');
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom: 16,
    )));
    lastlat = currentLocation.latitude;
    lastlong = currentLocation.longitude;

    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(LatLng(lastlat, lastlong).toString()),
        position: LatLng(lastlat, lastlong),
        infoWindow: InfoWindow(title: 'ตำแหน่งของฉัน'),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });

    print(lastlat);
    print(lastlong);
  }

  SendLocation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              CameraApp(latitude: lastlat, longitude: lastlong,status: widget.status)),
    );
  }
}