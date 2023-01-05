import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_patient_screen.dart';
import '../providers/patients_provider.dart';

class UserPatientItem extends StatelessWidget {
  final String id;
  final String name;
  final String image;
  final String diagnosis;
  final String treatment;

  UserPatientItem(
      this.id, this.name, this.image, this.diagnosis, this.treatment);

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(name),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(image),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditPatientScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<Patients_Provider>(context, listen: false)
                      .deletePatient(id);
                } catch (error) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text("Delete Failed"),
                    ),
                  );
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
