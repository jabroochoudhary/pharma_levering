import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:delayed_display/delayed_display.dart';

import '../Admin Side/DashBoard/dashboard.dart';
import '../App Services/LocalDataSaver.dart';
import '../screens/homepage/home_page.dart';
import '../screens/login/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    initVar();
    super.initState();
  }

  void initVar() async {
    bool isShope;
    int ch;
    try {
      isShope = (await LocalDataSaver.getIsShope())!;
      if (isShope) {
        ch = 0;
      } else {
        ch = 1;
      }
    } catch (e) {
      ch = 2;
    }
    Timer(const Duration(seconds: 3), () {
      Get.offAll(() => ch == 0
          ? DashBoardAdmin()
          : ch == 1
              ? HomePage()
              : LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.green,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              DelayedDisplay(
                delay: Duration(milliseconds: 1000),
                child: Image(
                  image: AssetImage("images/appicon.png"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
