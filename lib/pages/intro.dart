import 'dart:async';
import 'package:b_mobile/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  IntroPage createState() => IntroPage();
}

class IntroPage extends State<Intro> {
  void moveToNextPage() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Splash()));
      ;
    });
  }

  @override
  void initState() {
    super.initState();
    moveToNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('misc/splash_1.png'), fit: BoxFit.cover)),
    ).animate().fadeIn(duration: 1000.ms);
  }
}
