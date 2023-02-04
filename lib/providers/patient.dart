import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Patient with ChangeNotifier {
  final String id;
  final String name;
  final int age;
  final double price;
  final String diagnosisDate;
  final String diagnosis;
  final String treatment;
  final String image;
  bool isMarked;

  Patient({
    @required this.id,
    @required this.name,
    @required this.age,
    @required this.price,
    @required this.diagnosisDate,
    @required this.diagnosis,
    @required this.treatment,
    @required this.image,
    this.isMarked = false,
  });

  void _setMarkedValue(bool newValue) {
    isMarked = newValue;
    notifyListeners();
  }

  Future<void> toggleMarkedStatus(String token, String userId) async {
    final oldMarked = isMarked;
    isMarked = !isMarked;
    notifyListeners();
    final url =
        'https://msapp-533d1-default-rtdb.firebaseio.com/userMarked/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isMarked,
        ),
      );
      if (response.statusCode >= 400) {
        _setMarkedValue(oldMarked);
      }
    } catch (error) {
      _setMarkedValue(oldMarked);
    }
  }
}
