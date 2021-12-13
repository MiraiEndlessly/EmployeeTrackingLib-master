import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'Model/user.dart';
import 'splash_screen.dart';
import 'package:tracking/home_page.dart';
import 'login_page.dart';

class SuccessPage extends StatefulWidget {
  @override
  _SuccessPage createState() => _SuccessPage();
}

class _SuccessPage extends State<SuccessPage> {
  final interval = const Duration(seconds: 1);
  final int timerMaxSeconds = 5;
  int currentSeconds = 0;

  /* startTimeout([int milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      try {
        setState(() async {
          currentSeconds = timer.tick;

          if (timer.tick >= timerMaxSeconds) {
            timer.cancel();

            
          }
        });
      } catch (e) {}
    });
  } */

  @override
  void initState() {
    super.initState();
    //startTimeout();
    Future.delayed(Duration(seconds: 6)).then((value) async {
         SharedPreferences prefs = await SharedPreferences.getInstance();
            String user_id = prefs.getString("user_id");
            String email = prefs.getString("email");
            String password = prefs.getString("password");
            String photo = prefs.getString("photo");
            String name = prefs.getString("name");
            String surname = prefs.getString("surname");
            String position = prefs.getString("position");
            String tel = prefs.getString("tel");

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
                settings: RouteSettings(
                  arguments: User(
                    user_id,
                    email,
                    password,
                    photo,
                    name,
                    surname,
                    position,
                    tel
                  ),
                ),
              ),
            );
       });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("ภารกิจสำเร็จ",
                style: new TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold)),
            Image.asset(
              'assets/success.gif',
              width: 350.0,
              height: 350.0,
            ),
            Text("ยินดีด้วย คุณเพิ่มข้อมูลพิกัดได้สำเร็จ",
                style: new TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500)),
            SizedBox(
              height: 30.0,
            ),
            Text("กรุณารอสักครู่...",
                style: new TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }
}
