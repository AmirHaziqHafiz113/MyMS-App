import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/patient_detail_screen.dart';
import '../providers/patient.dart';
import '../providers/cart.dart';

class PatientInfo extends StatelessWidget {
  // final String id;
  // final String name;
  // final String email;
  // final String image;

  // PatientInfo(this.id, this.name, this.email, this.image);

  @override
  Widget build(BuildContext context) {
    final patient = Provider.of<Patient>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(PatientDetailScreen.routeName,
                arguments: patient.id);
          },
          child: Image.network(
            patient.image,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Patient>(
            builder: (ctx, patient, _) => IconButton(
              icon: Icon(
                  patient.isMarked ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                patient.toggleMarkedStatus();
              },
              color: Colors.red,
            ),
          ),
          title: Text(
            patient.name,
            textAlign: TextAlign.center,
          ),
          trailing: Consumer<Cart>(
            builder: (ctx, cart, _) => IconButton(
              icon: Icon(Icons.account_box),
              onPressed: () {
                cart.addItem(patient.id, patient.price, patient.name);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Item added to cart'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(patient.id);
                    },
                  ),
                ));
              },
              color: Colors.orange,
            ),
          ),
        ),
      ),
    );
  }
}
