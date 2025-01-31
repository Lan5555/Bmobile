import 'dart:math';

import 'package:b_mobile/pages/intro.dart';
import 'package:b_mobile/pages/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});
  @override
  SplashScreen createState() => SplashScreen();
}

class SplashScreen extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('misc/car.jpg'),
              fit: BoxFit.cover,
              opacity: 0.7)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.info_rounded,
                  color: Colors.white,
                ))
          ],
        ),
        backgroundColor: Colors.transparent,
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 220,
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'WELCOME',
                    style: TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        fontFamily: 'Inter',
                        shadows: [
                          Shadow(
                              color: Colors.black,
                              blurRadius: 3,
                              offset: Offset(1, 2))
                        ]),
                  )),
              SizedBox(
                height: 20,
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Your Ride,',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'Inter',
                    ),
                  )),
              SizedBox(
                height: 50,
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Your Way - Fast, Easy, and Reliable',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'Inter',
                    ),
                  )),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
            label: const Text('Get Started')),
      ),
    );
  }
}
