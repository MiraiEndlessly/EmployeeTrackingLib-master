import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking/home_page.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _TimerButton createState() => _TimerButton();
}

class _TimerButton extends State<SplashScreen> {
  final interval = const Duration(seconds: 1);
  final int timerMaxSeconds = 4;
  int currentSeconds = 0;

  startTimeout([int milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      try {
        setState(() async {
          currentSeconds = timer.tick;

          if (timer.tick >= timerMaxSeconds) {
            timer.cancel();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          }
        });
      } catch (e) {}
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  void _asyncMethod() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool check = prefs.getBool("check");
    /* String userId = prefs.getString("user_id");
    String email = prefs.getString("email");
    String password = prefs.getString("password");
    String photo = prefs.getString("photo");
    String name = prefs.getString("name");
    String surname = prefs.getString("surname");
    String position = prefs.getString("position");
    String tel = prefs.getString("tel"); */

    if (check == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
          // Pass the arguments as part of the RouteSettings. The
          // DetailScreen reads the arguments from these settings.
          /* settings: RouteSettings(
            arguments: User(
              userId,
              email,
              password,
              photo,
              name,
              surname,
              position,
              tel
            ),
          ), */
        ),
      );
    } else {
      startTimeout();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/wsffsd.png',
              width: 200.0,
              height: 200.0,
            ),
          ],
        ),
      ),
    );
  }
}
