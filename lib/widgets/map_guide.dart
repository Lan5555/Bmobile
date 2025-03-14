// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart'; // To access location data

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  Location _location = Location();
  LatLng _currentLocation =
      const LatLng(6.5244, 3.3792); // Default to Lagos coordinates
  LatLng _driverLocation =
      const LatLng(6.5444, 3.3592); // Sample driver location
  MapController? _mapController; // Nullable MapController
  double _currentZoom = 14.0; // Track the current zoom level manually
  late AnimationController _animationController;
  late Animation<LatLng> _animation;
  late Animation<double> _zoomAnimation;

  Map<dynamic, dynamic> customShadow = {
    "blurRadius": 1.75 * 16,
    "spreadRadius": 0.0,
    "color": const Color.fromRGBO(33, 40, 50, 0.15),
    "offset": const Offset(0, 0.15 * 16)
  };

  @override
  void initState() {
    super.initState();
    _mapController = MapController(); // Initialize the MapController
    _getCurrentLocation();

    // Animation setup
    _animationController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 300), // The duration for the animation
    );
    _zoomAnimation =
        Tween<double>(begin: _currentZoom, end: _currentZoom).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  // Get the current location of the user (rider)
  Future<void> _getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    // Check if location services are enabled
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) return;
    }

    // Check if location permissions are granted
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    // Get the current location
    LocationData _locationData = await _location.getLocation();
    setState(() {
      _currentLocation =
          LatLng(_locationData.latitude!, _locationData.longitude!);
    });

    // Re-center the map to the current location after the data is fetched
    if (_mapController != null) {
      _mapController!.move(_currentLocation,
          _currentZoom); // Center the map with the current location
    }
  }

  // Function to zoom in
  void _zoomIn() {
    setState(() {
      _currentZoom = (_currentZoom + 1)
          .clamp(14.0, 18.0); // Zoom in and clamp within the allowed zoom range
    });
    if (_mapController != null) {
      _animationController.forward(from: 0.0);
      _mapController!.move(_currentLocation, _currentZoom);
    }
  }

  // Function to zoom out
  void _zoomOut() {
    setState(() {
      _currentZoom = (_currentZoom - 1).clamp(
          14.0, 18.0); // Zoom out and clamp within the allowed zoom range
    });
    if (_mapController != null) {
      _animationController.forward(from: 0.0);
      _mapController!.move(_currentLocation, _currentZoom);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Container(
            height: 400,
            width: double.infinity,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(56),
                    bottomRight: Radius.circular(56)),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 1.75 * 16,
                      spreadRadius: 0.0,
                      color: Color.fromRGBO(33, 40, 50, 0.15),
                      offset: Offset(0, 0.15 * 16))
                ]),
            clipBehavior: Clip.antiAlias,
            child: Stack(children: [
              FlutterMap(
                mapController:
                    _mapController!, // Use the MapController here (ensure it's initialized)
                options: MapOptions(
                  initialZoom: 14.0, // Set initial zoom level
                  minZoom: 14.0,
                  maxZoom: 18.0,
                  initialCenter:
                      _currentLocation, // Set the center to _currentLocation
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  ),
                  MarkerLayer(
                    markers: [
                      // Rider's current location
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _currentLocation,
                        child: Container(
                          child: const Icon(Icons.location_pin,
                              color: Colors.blue, size: 40),
                        ),
                      ),
                      // Driver's location (this would typically come from your database/server)
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _driverLocation,
                        child: Container(
                          child: const Icon(Icons.directions_car,
                              color: Colors.red, size: 40),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                  top: 280,
                  right: 20,
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(26),
                                boxShadow: const [
                                  BoxShadow(
                                      blurRadius: 1.75 * 16,
                                      spreadRadius: 0.0,
                                      color: Color.fromRGBO(33, 40, 50, 0.15),
                                      offset: Offset(0, 0.15 * 16)),
                                ],
                                color: Colors.white),
                            child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: GestureDetector(
                                  onTap: _zoomIn,
                                  child: const Icon(Icons.zoom_in),
                                ))),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(26),
                                boxShadow: const [
                                  BoxShadow(
                                      blurRadius: 1.75 * 16,
                                      spreadRadius: 0.0,
                                      color: Color.fromRGBO(33, 40, 50, 0.15),
                                      offset: Offset(0, 0.15 * 16))
                                ],
                                color: Colors.white),
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(Icons.zoom_out),
                            )),
                      ],
                    ),
                  ))
            ])),
            Padding(padding: const EdgeInsets.all(16),
            child: 
            _buildContainer(widget: ListTile(
              title: const Text('Search'),
              leading: const Icon(Icons.search),
              trailing: GestureDetector(
                onTap: (){},
                child: const Icon(Icons.chevron_right_rounded),
              ),
            ))),
            Padding(padding: const EdgeInsets.all(16),
            child: 
            _buildContainer(widget: ListTile(
              title: const Text('Favourites'),
              leading: Icon(Icons.favorite_outline_sharp,),
              trailing: GestureDetector(
                onTap: (){},
                child: const Icon(Icons.chevron_right_rounded),
                
              )
            ))),
            Padding(padding: const EdgeInsets.all(16),
            child: 
            _buildContainer(widget: ListTile(
              title: const Text('Explore'),
              leading: Icon(Icons.travel_explore),
              trailing: GestureDetector(
                onTap: (){},
                child: const Icon(Icons.chevron_right_rounded),
              )
            ))),
            Padding(padding: const EdgeInsets.all(16),
            child: 
            _buildContainer(widget: ListTile(
              title: const Text('Saved'),
              leading: Icon(Icons.collections_bookmark),
              trailing: GestureDetector(
                onTap: (){},
                child: const Icon(Icons.chevron_right_rounded),
              )
            ))),
      ],
    ));
  }
}

Widget _buildContainer({Widget? widget}) {
  return Container(
    width: double.infinity,
    height: 60,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          blurRadius: 1.75 * 16,
          spreadRadius: 0.0,
          color: Color.fromRGBO(33, 40, 50, 0.15),
          offset: Offset(0, 0.15 * 16)
        )
      ]
    ),
    child: widget,
  );
}
