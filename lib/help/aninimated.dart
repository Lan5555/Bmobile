how to properly implement the searchbox api import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart' as gl;
import 'package:latlong2/latlong.dart';
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
  // late SearchBoxAPI _searchApi;
  // List<Suggestion>? _suggestions = [];

  late mb.PolylineAnnotationManager _polylineAnnotationManager;
  TextEditingController searchController = TextEditingController();
  double? userLat, userLng;
  
  bool ready = true;

  @override
  void initState() {
    super.initState();
    _setUpTracking();
    //_searchApi = SearchBoxAPI(apiKey: API_KEY, limit: 5, country: 'NG');
  }

  @override
  void dispose() {
    super.dispose();
    userSubscribtion?.cancel();
  }

  void _onMapBoxCreated(mb.MapboxMap controller) async {
    setState(() {
      _mapboxMap = controller;
    });

    // Enable the location component to show the user's location on the map
    _mapboxMap?.location.updateSettings(
      mb.LocationComponentSettings(enabled: true, pulsingEnabled: true),
    );

    final pointAnnotationManager =
        await _mapboxMap?.annotations.createPointAnnotationManager();
    final Uint8List imageData = await loadMarkerImage();

    // Add a custom marker to the map
    mb.PointAnnotationOptions pointAnnotationOptions =
        mb.PointAnnotationOptions(
      image: imageData,
      iconSize: 0.3,
      geometry: mb.Point(
        coordinates: mb.Position(-122.0312186, 37.33233141),
      ),
    );
    pointAnnotationManager?.create(pointAnnotationOptions);
  }

  Future<Uint8List> loadMarkerImage() async {
    var byteData = await rootBundle.load('misc/icons/location.png');
    return byteData.buffer.asUint8List();
  }

  Future<void> _setUpTracking() async {
    bool isEnabled;
    gl.LocationPermission permission;

    // Check if location services are enabled
    isEnabled = await gl.Geolocator.isLocationServiceEnabled();
    if (!isEnabled) {
      print("Location services are not enabled.");
      return Future.error(
          'Location services are not enabled. Please enable it in settings.');
    }

    // Check if the location permission is granted
    permission = await gl.Geolocator.checkPermission();
    if (permission == gl.LocationPermission.denied) {
      print("Location permission denied, requesting permission...");
      permission = await gl.Geolocator.requestPermission();
      if (permission == gl.LocationPermission.denied) {
        print("Location permission still denied.");
        return Future.error(
            'Location permission denied. Please grant location permission.');
      }
    }

    if (permission == gl.LocationPermission.deniedForever) {
      print("Location permission denied forever.");
      return Future.error(
          'Location permission denied forever. Please enable it in settings.');
    }

    gl.LocationSettings locationSettings = const gl.LocationSettings(
      accuracy: gl.LocationAccuracy.high,
      distanceFilter: 100,
    );

    // Start listening to location updates
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

  // // Search controller
  // void _onSearchChanged(String query) async {
  //   if (query.isNotEmpty) {
  //     final results = await _searchApi.getSuggestions(query);
  //     setState(() {
  //       _suggestions =
  //           results.fold((success) => success.suggestions, (failure) => []);
  //     });
  //   } else {
  //     setState(() {
  //       _suggestions = [];
  //     });
  //   }
  // }

  // void _moveToPlace(Suggestion suggestion) async {
  //   // Ensure that coordinates is a List<double>
  //   final coordinates = suggestion as List<dynamic>;

  //   // Access the latitude and longitude
  //   final destination = LatLng(coordinates[1], coordinates[0]);
  //   final point = mb.Position(destination.longitude, destination.latitude);

  //   _mapboxMap!.setCamera(
  //       mb.CameraOptions(zoom: 14, center: mb.Point(coordinates: point)));
  //   _mapboxMap!.flyTo(
  //       mb.CameraOptions(zoom: 14, center: mb.Point(coordinates: point)),mb.MapAnimationOptions(duration: 300, startDelay: 100));

  //   final pointAnnotationManager =
  //       await _mapboxMap?.annotations.createPointAnnotationManager();
  //   // Add a custom marker to the map
  //   mb.PointAnnotationOptions pointAnnotationOptions =
  //       mb.PointAnnotationOptions(
  //           iconImage: 'marker-icon',
  //           iconSize: 0.3,
  //           geometry: mb.Point(coordinates: point));
  //   pointAnnotationManager?.create(pointAnnotationOptions);

  //   List<LatLng> route = [LatLng(37.7749, -122.4194), destination];
  //   _drawPolyLine(route);
  // }

  // void _drawPolyLine(List<LatLng> points) async {
  //   _polylineAnnotationManager =
  //       await _mapboxMap!.annotations.createPolylineAnnotationManager();

  //   // Convert List<LatLng> to List<mb.Position>
  //   List<mb.Position> coordinates = points
  //       .map((point) => mb.Position(point.longitude, point.latitude))
  //       .toList();

  //   // Create a LineString from the coordinates
  //   final lineString = mb.LineString(coordinates: coordinates);

  //   // Create the polyline annotation options
  //   mb.PolylineAnnotationOptions polylineAnnotationOptions =
  //       mb.PolylineAnnotationOptions(
  //     geometry: lineString, // Use LineString here
  //     lineColor: Colors.blue.value, // Set the color of the polyline
  //     lineWidth: 5.0, // Set the width of the polyline
  //   );

  //   // Add the polyline to the map
  //   _polylineAnnotationManager.create(polylineAnnotationOptions);
  // }

  List<dynamic> searchResults = [];
  Map<String, List<dynamic>> searchCache = {};
  bool isLoading = false;

  Future<void> searchPlaces(String query) async {
    if (query.isEmpty) return;
    if (searchCache.containsKey(query)) {
      setState(() {
        searchResults = searchCache[query]!;
      });
      return;
    }
    String url =
    'https://api.mapbox.com/search/searchbox/v1/suggest?q=$query&language=en&country=ng&proximity=-73.990593,40.740121&session_token=024498f6-e4be-4a41-8959-38d7cd500774&access_token=$API_KEY';
  setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      //Fluttertoast.showToast(msg: response.body);
      final data = json.decode(response.body);
      searchCache[query] = data['suggestions'];
      setState(() {
        searchResults = data['suggestions'];
      });
    } else {
      Fluttertoast.showToast(msg: response.body);
    }
  }

  void moveToLocation(double latitude, double longitude) {
    _mapboxMap!.setCamera(mb.CameraOptions(
      center: mb.Point(coordinates: mb.Position(longitude, latitude)),
      zoom: 12.0,
    ));
    setState(() {
      searchResults = [];
    });
    //searchController.clear();
  }

  //Search controller

  dynamic _showModalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: 600,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 60,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Where to?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.blue,
                        fontFamily: 'GowunBatang',
                      ),
                    ),
                  ).animate().fadeIn(duration: const Duration(seconds: 1)),
                  const SizedBox(height: 10),
                  Container(
                    height: 60,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                          prefixIcon: const Icon(Icons.location_on),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.2),
                          label: const Text('Enter destination'),
                        ),
                        onChanged: (value) => searchPlaces(value)),
                  ),
                  const SizedBox(height: 30),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ElevatedButton.icon(
                  //     style: const ButtonStyle(
                  //       backgroundColor:
                  //           WidgetStatePropertyAll(Colors.blueAccent),
                  //       foregroundColor: WidgetStatePropertyAll(Colors.white),
                  //     ),
                  //     onPressed: () {
                  //       Fluttertoast.showToast(msg: 'Queried');
                  //     },
                  //     icon: const Icon(Icons.search),
                  //     label: const Text('Search'),
                  //   ),
                  // ),
                  if (isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  if (!isLoading)
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final place = searchResults[index];
                          return ListTile(
                            title: Text(place['name'] ?? 'Unknown'),
                            onTap: () {
                              double lat = place['center'][1];
                              double long = place['center'][0];
                              moveToLocation(lat, long);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        mb.MapWidget(
          onMapCreated: _onMapBoxCreated,
          styleUri: mb.MapboxStyles.SATELLITE_STREETS,
        ),
        Positioned(
          bottom: 40,
          left: 20,
          child: ElevatedButton.icon(
            onPressed: () => _showModalSheet(context),
            icon: const Icon(Icons.search),
            label: const Text('Search'),
          ),
        ),
        if (ready)
          AnimatedOpacity(
              opacity: ready ? 1.0 : 0.0,
              duration: const Duration(seconds: 1),
              child: Container(
                color: Colors.white.withOpacity(0.7),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )),
              if(searchResults.isNotEmpty)
       Center(
  child: Material( // Wrap your list inside a Material widget
    child: Container(
      width: double.infinity,  // Full width
      height: 600,             // Fixed height
      color: Colors.white,     // Background color of the container
      child: ListView.builder(
        shrinkWrap: true,       // Optimize ListView for performance
        itemCount: searchResults.length,  // The length of the search results
        itemBuilder: (context, index) {
          final place = searchResults[index];  // Get the current place
          return ListTile(
            title: Text(
              place['place_name'] ?? 'Unknown',  // Display the place name or 'Unknown'
              overflow: TextOverflow.ellipsis,   // Handle long names
            ),
            onTap: () {
              double lat = place['center'][1];  // Latitude from the 'center'
              double long = place['center'][0]; // Longitude from the 'center'
              moveToLocation(lat, long);         // Call your moveToLocation function
              Navigator.pop(context);            // Close the bottom sheet or modal
            },
          );
        },
      ),
    ),
  ),
)

      ],
    );
  }
}