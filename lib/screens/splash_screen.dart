import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String loadingString = 'Loading.....';
  Duration delayInterval = const Duration(milliseconds: 5000);

  @override
  void initState() {
    super.initState();
    waitUp();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff1C0649),
              Color(0xff282828),
            ],
          ),
        ),
        child: Center(
          child: Lottie.asset(
            'assets/fortune_wheel.json',
          ),
        ),
      ),
    );
  }

  void waitUp() async {
    loadingString;
    await Future.delayed(delayInterval);
    Future(
      () => Navigator.of(context).pushReplacementNamed('/fortune'),
    );
  }
}
