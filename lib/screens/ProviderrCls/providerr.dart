import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageNotifier extends ChangeNotifier {
  List _images = [];

  List get images => _images;

  void getApiData() async {
    final url = Uri.parse(
        "https://api.unsplash.com/photos/?client_id=0s6o__VDjhrWWinuuSxqu9umQkgExImox9T1C9yT3XU");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      _images = jsonDecode(response.body);
      notifyListeners(); // Notify listeners to rebuild the UI
    } else {
      print("Failed to fetch images: ${response.statusCode}");
    }
  }
}
