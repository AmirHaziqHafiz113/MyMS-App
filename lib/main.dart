import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:provider/provider.dart';
import './screens/patient_overview.dart';
import './screens/cart_screen.dart';
import './screens/user_patients_screen.dart';
import './screens/patient_detail_screen.dart';
import './providers/patients_provider.dart';
import './providers/auth.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/edit_patient_screen.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Patients_Provider>(
            create: (ctx) => Patients_Provider('', '', []),
            update: (ctx, auth, previousPatients) => Patients_Provider(
              auth.token,
              auth.userId,
              previousPatients == null ? [] : previousPatients.patients,
            ),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => Orders('', '', []),
            update: (ctx, auth, previousOrders) => Orders(
              auth.token,
              auth.userId,
              previousOrders == null ? [] : previousOrders.orders,
            ),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                  .copyWith(secondary: Colors.deepOrange),
            ),
            home: auth.isAuth ? PatientOverview() : AuthScreen(),
            routes: {
              PatientDetailScreen.routeName: (ctx) => PatientDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserPatientScreen.routeName: (ctx) => UserPatientScreen(),
              EditPatientScreen.routeName: (ctx) => EditPatientScreen(),
            },
          ),
        ));
  }
}
