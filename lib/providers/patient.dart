import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Patient with ChangeNotifier {
  final String id;
  final String name;
  final String email;
  final int phone;
  final int age;
  final double price;
  final String address;
  final String diagnosisDate;
  final String diagnosis;
  final String treatment;
  final String currentMedicDose;
  final String currentMedicName;
  final String image;
  bool isMarked;

  Patient({
    @required this.id,
    @required this.name,
    @required this.email,
    @required this.phone,
    @required this.age,
    @required this.price,
    @required this.address,
    @required this.diagnosisDate,
    @required this.diagnosis,
    @required this.treatment,
    @required this.currentMedicDose,
    @required this.currentMedicName,
    @required this.image,
    this.isMarked = false,
  });

  void _setMarkedValue(bool newValue) {
    isMarked = newValue;
    notifyListeners();
  }

  Future<void> toggleMarkedStatus(String token) async {
    final oldMarked = isMarked;
    isMarked = !isMarked;
    notifyListeners();
    final url =
        'https://msapp-533d1-default-rtdb.firebaseio.com/patients/$id.json?auth=$token';
    try {
      final response = await http.patch(url,
          body: json.encode({
            'isMarked': isMarked,
          }));
      if (response.statusCode >= 400) {
        _setMarkedValue(oldMarked);
      }
    } catch (error) {
      _setMarkedValue(oldMarked);
    }
  }
}
