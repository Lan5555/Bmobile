import 'dart:async';
import 'dart:math';
import 'package:b_mobile/pages/intro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BodyPage extends StatefulWidget {
  const BodyPage({super.key});
  @override
  Body createState() => Body();
}


class Body extends State<BodyPage> {
  Map<dynamic, dynamic> category = {
    'Drive': 'misc/car.jpg',
    'Train ride': 'misc/train.jpg',
    'Fight': 'misc/plane.jpeg',
    'Bike ride': 'misc/bike.jpg'
  };

  dynamic handleClick(value) {
    if (value == 'Drive') {
      print(value);
    }
  }

  int index = 0;

  void randomIndex() {
    // ignore: unnecessary_new
    Random random = new Random();
    int newIndex = random.nextInt(5);
    setState(() {
      index = newIndex;
    });
  }

  final List<Color> colors = [
    Colors.blue,
    Colors.grey,
    Colors.green,
    Colors.pink,
    Colors.purple
  ];


  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      randomIndex();
    });
  }



  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Bauchi',
            style: TextStyle(fontSize: 12, color: colors[index]),
          ),
          Text('${DateTime.now()}', style: const TextStyle(fontSize: 12))
        ],
      ).animate().fadeIn(duration: const Duration(seconds: 3)),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Gombe',
            style: TextStyle(fontSize: 12, color: colors[index]),
          ),
          Text('${DateTime.now()}', style: const TextStyle(fontSize: 12))
        ],
      ).animate().fadeIn(duration: const Duration(seconds: 3)),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Kano',
            style: TextStyle(fontSize: 12, color: colors[index]),
          ),
          Text('${DateTime.now()}', style: const TextStyle(fontSize: 12))
        ],
      ).animate().fadeIn(duration: const Duration(seconds: 3)),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Lagos',
            style: TextStyle(fontSize: 12, color: colors[index]),
          ),
          Text('${DateTime.now()}', style: const TextStyle(fontSize: 12))
        ],
      ).animate().fadeIn(duration: const Duration(seconds: 3)),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Anambra',
            style: TextStyle(fontSize: 12, color: colors[index]),
          ),
          Text('${DateTime.now()}', style: const TextStyle(fontSize: 12))
        ],
      ).animate().fadeIn(duration: const Duration(seconds: 3)),
    ];

    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              height: 30,
            ),
            CarouselSlider(
                items: [
                  Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: const DecorationImage(
                            image: AssetImage('misc/fam.jpg'),
                            fit: BoxFit.cover,
                          )),
                      clipBehavior: Clip.antiAlias,
                      child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            margin: const EdgeInsets.only(left: 20, bottom: 20),
                            child: ElevatedButton(
                                style: const ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll(Colors.blue),
                                    foregroundColor:
                                        WidgetStatePropertyAll(Colors.white),
                                    shadowColor:
                                        WidgetStatePropertyAll(Colors.black)),
                                onPressed: () {
                                  
                                },
                                child: const Text('Book a ride')),
                          ))),
                  Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: const DecorationImage(
                              image: AssetImage('misc/car.jpg'),
                              fit: BoxFit.cover)),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          const Positioned(
                              top: 100,
                              left: 28,
                              right: 0,
                              child: Text(
                                'Fast and Reliable',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "GowunBatang",
                                    shadows: [
                                      Shadow(
                                          color: Colors.black, blurRadius: 2),
                                      Shadow(color: Colors.blue, blurRadius: 2),
                                    ]),
                              )),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 20, bottom: 20),
                              child: ElevatedButton(
                                  style: const ButtonStyle(
                                      backgroundColor:
                                          WidgetStatePropertyAll(Colors.blue),
                                      foregroundColor:
                                          WidgetStatePropertyAll(Colors.white),
                                      shadowColor:
                                          WidgetStatePropertyAll(Colors.black)),
                                  onPressed: () {},
                                  child: const Text('Book a ride')),
                            ),
                          )
                        ],
                      )),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: const DecorationImage(
                            image: AssetImage('misc/bike.jpg'),
                            fit: BoxFit.cover)),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        const Positioned(
                            top: 100,
                            left: 28,
                            right: 0,
                            child: Text(
                              'Arrive at location in minutes',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "GowunBatang",
                                  shadows: [
                                    Shadow(color: Colors.black, blurRadius: 2),
                                    Shadow(color: Colors.blue, blurRadius: 2),
                                  ]),
                            )),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            margin: const EdgeInsets.only(left: 20, bottom: 20),
                            child: ElevatedButton(
                                style: const ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll(Colors.blue),
                                    foregroundColor:
                                        WidgetStatePropertyAll(Colors.white),
                                    shadowColor:
                                        WidgetStatePropertyAll(Colors.black)),
                                onPressed: () {},
                                child: const Text('Book a ride')),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
                options: CarouselOptions(
                  height: 200,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 7),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  aspectRatio: 16 / 9,
                  scrollPhysics: const BouncingScrollPhysics(),
                )),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      prefixIcon: const Icon(Icons.arrow_drop_down),
                      suffixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      hintText: 'Search location'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.star),
                          Text(
                            'Category',
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Inter',
                                fontSize: 20.0),
                          ),
                        ],
                      ),
                      Image.asset(
                        'misc/avatar/register.png',
                        scale: 90,
                      )
                    ],
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: CarouselSlider(
                  items: category.entries.map((entry) {
                    return _buildCarouselItem(
                        Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 10, bottom: 10),
                              child: Text(
                                entry.key,
                                style: const TextStyle(color: Colors.white),
                              ),
                            )),
                        '${entry.value}',
                        70,
                        100,
                        () => handleClick(entry.key));
                  }).toList(),
                  options: CarouselOptions(
                    scrollPhysics: const BouncingScrollPhysics(),
                    height: 70,
                    enlargeCenterPage: true,
                    viewportFraction: 0.37,
                    aspectRatio: 16 / 9,
                    autoPlay: true,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayInterval: const Duration(seconds: 10),
                  )),
            ),
            const SizedBox(
              height: 3,
            ),
            const Padding(
                padding: EdgeInsets.all(16),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'History',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20.0,
                              fontWeight: FontWeight.w900),
                        ),
                        Icon(
                          Icons.history,
                          color: Colors.blue,
                        )
                      ],
                    ))),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white.withOpacity(0.7),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 24,
                            spreadRadius: 0.0,
                            color: Color.fromRGBO(33, 40, 50, 0.15),
                          )
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Location',
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'View all',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.arrow_forward,
                                        size: 19,
                                      ))
                                ],
                              )
                            ],
                          ),
                          items[index],
                        ],
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}



Widget _buildCarouselItem(Widget children, String imagePath, double height,
    double width, Function() onclick,
    {BoxDecoration? decoration}) {
  return GestureDetector(
      onTap: () {
        onclick();
      },
      child: Container(
        height: height,
        width: width,
        decoration: decoration ??
            BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                  image: AssetImage(imagePath), fit: BoxFit.cover),
            ),
        child: children,
      ));
}


