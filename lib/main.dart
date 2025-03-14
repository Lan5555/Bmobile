import 'package:b_mobile/pages/home.dart';
import 'package:b_mobile/pages/intro.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  String ACCESS_TOKEN =
      "sk.eyJ1IjoiYi1tb2JpbGUiLCJhIjoiY204NHhpZG40MHh6aDJpcXZ3b3p5Y280YyJ9.H-gBoe0xrTXRUCX_3je6Uw";
  MapboxOptions.setAccessToken(ACCESS_TOKEN);
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
