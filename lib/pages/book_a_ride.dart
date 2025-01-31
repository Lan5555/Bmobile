import 'package:flutter/material.dart';

class Ride extends StatefulWidget {
  const Ride({super.key});
  @override
  RidePage createState() => RidePage();
}

class RidePage extends State<Ride> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: const SingleChildScrollView(
        child: Column(
          children: [
            
          ],
        ),
      ),
    );
  }
}
