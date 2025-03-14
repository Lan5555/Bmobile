import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart' as gl;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;
import 'package:http/http.dart' as http;

class MapState extends StatefulWidget {
  const MapState({super.key});

  @override
  MapPage createState() => MapPage();
}

class MapPage extends State<MapState> {
  mb.MapboxMap? _mapboxMap;
  StreamSubscription? userSubscribtion;
  TextEditingController searchController = TextEditingController();
  double? userLat, userLng;
  bool ready = true;
  List<dynamic> searchResults = [];
  Map<String, List<dynamic>> searchCache = {};
  bool isLoading = false;
  final API_KEY =
      "sk.eyJ1IjoiYi1tb2JpbGUiLCJhIjoiY204NHhpZG40MHh6aDJpcXZ3b3p5Y280YyJ9.H-gBoe0xrTXRUCX_3je6Uw";

  @override
  void initState() {
    super.initState();
    _setUpTracking();
  }

  @override
  void dispose() {
    super.dispose();
    userSubscribtion?.cancel();
  }

  Future<void> _setUpTracking() async {
    bool isEnabled = await gl.Geolocator.isLocationServiceEnabled();
    if (!isEnabled) {
      Fluttertoast.showToast(msg: "Location services are not enabled.");
      return;
    }

    gl.LocationPermission permission = await gl.Geolocator.checkPermission();
    if (permission == gl.LocationPermission.denied) {
      permission = await gl.Geolocator.requestPermission();
      if (permission == gl.LocationPermission.denied) {
        Fluttertoast.showToast(msg: "Location permission denied.");
        return;
      }
    }

    gl.LocationSettings locationSettings = const gl.LocationSettings(
      accuracy: gl.LocationAccuracy.high,
      distanceFilter: 100,
    );

    userSubscribtion?.cancel();
    userSubscribtion =
        gl.Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((gl.Position? position) {
      if (position != null && _mapboxMap != null) {
        setState(() {
          userLat = position.latitude;
          userLng = position.longitude;
          ready = false;
        });

        _mapboxMap?.setCamera(mb.CameraOptions(
          zoom: 15,
          center: mb.Point(
              coordinates: mb.Position(position.longitude, position.latitude)),
        ));
      }
    });
  }

  void _onMapBoxCreated(mb.MapboxMap controller) async {
    setState(() {
      _mapboxMap = controller;
    });

    _mapboxMap?.location.updateSettings(
      mb.LocationComponentSettings(enabled: true, pulsingEnabled: true),
    );
  }

  bool expanded = false;

  // Implement Mapbox Search API
  Future<void> searchPlaces(String query) async {
    if (searchController.text != '') {
      setState(() {
        expanded = true;
      });
    } else {
      setState(() {
        expanded = false;
      });
    }

    if (query.isEmpty) return;

    if (searchCache.containsKey(query)) {
      setState(() {
        searchResults = searchCache[query]!;
      });
      return;
    }

    // Replace with your Mapbox API key
    String url =
        'https://api.mapbox.com/search/geocode/v6/forward?q=$query&country=ng&proximity=$userLat,$userLng&language=en&access_token=$API_KEY';

    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        searchResults = data['features'];
        searchCache[query] = data['features'];
        isLoading = false;
      });
      setState(() {
        isLoading = false;
      });
    }
  }

  // Move map to selected location
  void moveToLocation(double latitude, double longitude) {
    _mapboxMap!.setCamera(mb.CameraOptions(
      center: mb.Point(coordinates: mb.Position(longitude, latitude)),
      zoom: 12.0,
    ));
  }

  void _moveToLocationFromSearchResult(int index) {
    // Get coordinates from the selected result
    final feature = searchResults[index];
    final latitude = feature['geometry']['coordinates'][1];
    final longitude = feature['geometry']['coordinates'][0];

    moveToLocation(latitude, longitude);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          mb.MapWidget(
            onMapCreated: _onMapBoxCreated,
            styleUri: mb.MapboxStyles.SATELLITE_STREETS,
          ),
          if (ready)
            const Center(
              child: CircularProgressIndicator(),
            ),
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: AnimatedContainer(
                height: expanded ? 350 : 100,
                color: expanded ? Colors.white : Colors.transparent,
                duration: const Duration(milliseconds: 300),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        height: 50.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 28,
                              spreadRadius: 0.0,
                              offset: Offset(0, 24 * 0.15),
                              color: Colors.black,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: TextField(
                          controller: searchController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.location_on),
                            label: Text('Search'),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 20),
                          ),
                          onChanged: (value) => searchPlaces(value),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Use Expanded here to make ListView take the remaining space
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            final place = searchResults[index]['properties'];
                            String fullAddress =
                                place['full_address'] ?? 'Unknown Address';

                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(33, 40, 50, 0.15),
                                    spreadRadius: 0.0,
                                    blurRadius: 28,
                                    offset: Offset(0, 24 * 0.15),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Text(fullAddress),
                                leading: const Icon(Icons.location_on),
                                onTap: () {
                                  _moveToLocationFromSearchResult(index);
                                  Navigator.pop(
                                      context); // Close the search screen
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
