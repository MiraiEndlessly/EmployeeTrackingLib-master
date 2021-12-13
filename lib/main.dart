import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  //setupLocator();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase',
      /* theme: ThemeData(
        primarySwatch: Colors.blue,
      ), */
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
