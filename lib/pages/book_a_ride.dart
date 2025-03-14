import 'package:b_mobile/pages/home.dart';
import 'package:b_mobile/widgets/map_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class Ride extends StatefulWidget {
  const Ride({super.key});
  @override
  RidePage createState() => RidePage();
}

class RidePage extends State<Ride> {
  
  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  // Function to request location permission
  Future<void> _requestPermission() async {
    // Request permission to access location
    var status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      _checkLocationService();
    } else if (status.isDenied) {
    } else if (status.isPermanentlyDenied) {
      Fluttertoast.showToast(msg: "Location Permission Permanently Denied");
      openAppSettings();
    }
  }

  // Function to check if location services are enabled
  Future<void> _checkLocationService() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationServiceEnabled) {
    } else {
      // If location services are not enabled, prompt the user to enable them
      Geolocator.openLocationSettings(); // Open the settings to enable GPS
    }
  }

  


 

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          width: double.infinity,
          height: double.infinity,
          child: const MapState()),
      Positioned(
          bottom: 30,
          right: 10,
          child: Column(children: [
            GestureDetector(
                onTap: () {
                  setState(() {
                   
                  });
                },
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 0.0,
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 28,
                            offset: const Offset(0, 0.15 * 24))
                      ],
                      borderRadius: BorderRadius.circular(16)),
                  child: const Center(
                    child: Icon(Icons.location_on),
                  ),
                )),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  });
                },
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 0.0,
                            blurRadius: 28,
                            offset: const Offset(0, 0.15 * 24))
                      ],
                      borderRadius: BorderRadius.circular(16)),
                  child: const Center(
                    child: Icon(Icons.arrow_back),
                  ),
                ))
          ])),
    ]);
  }
}
