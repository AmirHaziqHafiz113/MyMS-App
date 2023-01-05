import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/patients_provider.dart';
import './patient_info.dart';

class PatientGrids extends StatelessWidget {
  final bool showMarks;

  PatientGrids(this.showMarks);

  Widget build(BuildContext context) {
    final patientsData = Provider.of<Patients_Provider>(context);
    final loadedPatients =
        showMarks ? patientsData.markedPatients : patientsData.patients;
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: loadedPatients.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // create: (c) => loadedPatients[i],
        value: loadedPatients[i],
        child: PatientInfo(
            // loadedPatients[i].id,
            // loadedPatients[i].name,
            // loadedPatients[i].email,
            // loadedPatients[i].image,
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
