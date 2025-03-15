import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart' as gl;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


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
  late mb.PointAnnotationManager _pointAnnotationManager;
  late mb.PolylineAnnotationManager _polylineAnnotationManager;
  String? API_KEY = dotenv.env['API_KEY'];
  gl.Position? currentPosition;

  @override
  void initState() {
    super.initState();
    _setUpTracking();
    _addMarker(userLat!, userLng!);
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
        searchController.clear();
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

  Future<void> _addMarker(double lattitude, double longitude) async {
    final ByteData bytes = await rootBundle.load('misc/icons/location.png');
    final Uint8List imageData = bytes.buffer.asUint8List();

    final pointAnnotationOptions = mb.PointAnnotationOptions(
        geometry: mb.Point(
          coordinates: mb.Position(longitude, lattitude),
        ),
        image: imageData,
        iconSize: 1.0);
    _pointAnnotationManager.create(pointAnnotationOptions);
  }

  void _addPolyline(
      double startLat, double startLng, double endLat, double endLng) {
    List<mb.Position> points = [
      mb.Position(startLng, startLat),
      mb.Position(endLng, endLat)
    ];
    final line = mb.LineString(coordinates: points);
    final polylineAnnotationOptions = mb.PolylineAnnotationOptions(
        geometry: line, lineColor: 0xFFFF0000, lineWidth: 5.0);

    _polylineAnnotationManager.create(polylineAnnotationOptions);
  }

  // Move map to selected location
  void moveToLocation(double latitude, double longitude) async {
    if (_mapboxMap == null) return;

    await _mapboxMap!.setCamera(mb.CameraOptions(
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
    if (currentPosition != null) {
      _addPolyline(
        currentPosition!.latitude,
        currentPosition!.longitude,
        latitude,
        longitude,
      );
    }

    // Add marker for the destination
    _addMarker(latitude, longitude);
  }

  final FocusNode _focusNode = FocusNode();
  bool keyboardHidden = false;
  void unFocus() {
    if (keyboardHidden) {
      _focusNode.unfocus();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
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
            top: 17,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: AnimatedContainer(
                height: expanded ? 350 : 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: expanded ? Colors.white : Colors.transparent,
                ),
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
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 28,
                              spreadRadius: 0.0,
                              offset: const Offset(0, 24 * 0.15),
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: TextField(
                          focusNode: _focusNode,
                          controller: searchController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search),
                            label: Text('Search'),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 20),
                          ),
                          onChanged: (value) => searchPlaces(value),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            final place = searchResults[index]['properties'];
                            String fullAddress =
                                place['full_address'] ?? 'Unknown Address';

                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
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
                                title: Text(
                                  fullAddress,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                leading: const Icon(
                                  Icons.location_on,
                                  color: Colors.blue,
                                ),
                                onTap: () {
                                  _moveToLocationFromSearchResult(index);
                                  searchController.clear();
                                  setState(() {
                                    expanded = false;
                                    keyboardHidden = true;
                                  });
                                  unFocus();
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
