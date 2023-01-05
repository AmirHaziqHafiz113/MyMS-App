import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/patients_provider.dart';

class PatientDetailScreen extends StatelessWidget {
  static const routeName = '/patient-detail';

  @override
  Widget build(BuildContext context) {
    final patientId = ModalRoute.of(context).settings.arguments as String;
    final loadedPatient = Provider.of<Patients_Provider>(
      context,
      listen: false,
    ).findById(patientId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedPatient.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedPatient.image,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '\$${loadedPatient.price}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedPatient.name,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedPatient.treatment,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedPatient.diagnosis,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
