import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/patients_provider.dart';
import '../widgets/user_patient_item.dart';
import '../widgets/app_drawer.dart';
import '../screens/edit_patient_screen.dart';

class UserPatientScreen extends StatelessWidget {
  static const routeName = '/user-patients';

  Future<void> _refreshPatients(BuildContext context) async {
    await Provider.of<Patients_Provider>(context, listen: false)
        .fetchAndSetPatients();
  }

  @override
  Widget build(BuildContext context) {
    final patientsData = Provider.of<Patients_Provider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Patients'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditPatientScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshPatients(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: patientsData.patients.length,
            itemBuilder: (_, i) => Column(
              children: [
                UserPatientItem(
                  patientsData.patients[i].id,
                  patientsData.patients[i].name,
                  patientsData.patients[i].image,
                  patientsData.patients[i].diagnosis,
                  patientsData.patients[i].treatment,
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
