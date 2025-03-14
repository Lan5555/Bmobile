import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_search/mapbox_search.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});
  @override
  SearchPage createState() => SearchPage();
}

class SearchPage extends State<SearchBar> {
  TextEditingController searchController = TextEditingController();
  List<MapBoxPlace> searchResults = [];
  final API_TEST_KEY =
      "pk.eyJ1IjoiYi1tb2JpbGUiLCJhIjoiY203Njdyd3djMHBzZTJxc2NicmVodjVybSJ9.M29f5Xh5TbJ3cmwHHEhtiA";

  Future<Object> searchLocation(String query) async {
    var placesService =
        GeoCodingApi(apiKey: API_TEST_KEY, country: 'NG', limit: 5);
    var result = await placesService.getPlaces(query);
    return result ?? [];
  }

  // void _addMarker(MapBoxPlace place){
  //   LatLng position = LatLng(, place.geometry!.coordinates[0]);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
