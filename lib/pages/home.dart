import 'package:b_mobile/pages/body.dart';
import 'package:b_mobile/pages/settings.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  HomePage createState() => HomePage();
}

class HomePage extends State<Home> {
  List<Widget> pages = [const BodyPage()];
  int currentPageIndex = 0;
  int tracker = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'B-Mobile',
              style:
                  TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              'Fast and Reliable',
              style: TextStyle(fontSize: 10),
            )
          ],
        ),
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 10),
              width: 30,
              height: 30,
              child: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  'N',
                  style: TextStyle(color: Colors.white),
                ),
              )),
        ],
      ),
      body: currentPageIndex < pages.length
          ? pages[currentPageIndex]
          : const Center(
              child: Text('No widget yet'),
            ),
      floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            setState(() {
              currentPageIndex = 3;
            });
          },
          child: const Icon(Icons.drive_eta)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    currentPageIndex = 0;
                  });
                },
                icon: Icon(
                  Icons.home,
                  color: currentPageIndex == 0 ? Colors.white : Colors.black,
                  size: 28,
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    currentPageIndex = 1;
                  });
                },
                icon: Icon(
                  Icons.directions_walk_rounded,
                  color: currentPageIndex == 1 ? Colors.white : Colors.black,
                  size: 28,
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    currentPageIndex = 3;
                  });
                },
                icon: Icon(
                  Icons.my_location,
                  color: currentPageIndex == 3 ? Colors.white : Colors.black,
                  size: 28,
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    //currentPageIndex = 4;
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Settings()));
                  });
                },
                icon: Icon(
                  Icons.settings,
                  color: currentPageIndex == 4 ? Colors.white : Colors.black,
                  size: 28,
                ))
          ],
        ),
      ),
    );
  }
}
