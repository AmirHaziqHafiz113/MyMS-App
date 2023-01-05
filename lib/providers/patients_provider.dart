import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import './patient.dart';
import '../models/http_exception.dart';

class Patients_Provider with ChangeNotifier {
  List<Patient> _patients = [];
  // var _showOnlyMarked = false;

  final String authToken;
  final String userId;

  Patients_Provider(this.authToken, this.userId, this._patients);

  List<Patient> get patients {
    return [..._patients];
  }

  List<Patient> get markedPatients {
    return _patients.where((patient) => patient.isMarked).toList();
  }

  Patient findById(String id) {
    return _patients.firstWhere((patient) => patient.id == id);
  }

  Future<void> fetchAndSetPatients([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://msapp-533d1-default-rtdb.firebaseio.com/patients.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          'https://msapp-533d1-default-rtdb.firebaseio.com/userMarked/$userId.json?auth=$authToken';
      final markedResponse = await http.get(url);
      final markedData = json.decode(markedResponse.body);
      final List<Patient> loadedPatients = [];
      extractedData.forEach((patientId, patientData) {
        loadedPatients.add(Patient(
          id: patientId,
          name: patientData['name'],
          email: patientData['email'],
          age: patientData['age'],
          treatment: patientData['treatment'],
          diagnosis: patientData['diagnosis'],
          price: patientData['price'],
          image: patientData['image'],
          isMarked: markedData == null ? false : markedData[patientId] ?? false,
        ));
      });
      _patients = loadedPatients;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addPatient(Patient value) async {
    final url =
        'https://msapp-533d1-default-rtdb.firebaseio.com/patients.json?auth=$authToken&orderBy="creatorId"&equalTo="$userId"';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'name': value.name,
          'email': value.email,
          'age': value.age,
          'treatment': value.treatment,
          'diagnosis': value.diagnosis,
          'price': value.price,
          'image': value.image,
          'creatorId': userId,
        }),
      );
      final newPatient = Patient(
        name: value.name,
        email: value.email,
        age: value.age,
        treatment: value.treatment,
        diagnosis: value.diagnosis,
        price: value.price,
        image: value.image,
        id: json.decode(response.body)['name'],
      );
      _patients.add(newPatient);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updatePatient(String id, Patient newPatient) async {
    final patientIndex = _patients.indexWhere((patient) => patient.id == id);
    if (patientIndex >= 0) {
      final url =
          'https://msapp-533d1-default-rtdb.firebaseio.com/patients/$id.json?auth=$authToken';
      try {
        await http.patch(url,
            body: json.encode({
              'name': newPatient.name,
              'email': newPatient.email,
              'age': newPatient.age,
              'treatment': newPatient.treatment,
              'diagnosis': newPatient.diagnosis,
              'price': newPatient.price,
              'image': newPatient.image,
            }));
      } catch (error) {
        throw error;
      }
      _patients[patientIndex] = newPatient;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deletePatient(String id) async {
    final url =
        'https://msapp-533d1-default-rtdb.firebaseio.com/patients/$id.json?auth=$authToken';
    final existingPatientIndex =
        _patients.indexWhere((patient) => patient.id == id);
    var existingPatient = _patients[existingPatientIndex];
    _patients.removeAt(existingPatientIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode <= 400) {
      _patients.insert(existingPatientIndex, existingPatient);
      notifyListeners();
      throw HttpException('Could not delete patient.');
    }
    existingPatient = null;
  }
}
