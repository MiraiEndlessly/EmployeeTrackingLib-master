import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Camera/camera_screen.dart';

void main() => runApp(CameraApp());

class CameraApp extends StatelessWidget {
  double latitude, longitude;
  var status;
  CameraApp({this.latitude, this.longitude, this.status});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black));
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      home: CameraScreen(latitude: latitude, longitude: longitude,status: status),
    );
  }
}
