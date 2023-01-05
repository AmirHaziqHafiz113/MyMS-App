import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

import '../widgets/patients_grid.dart';
import 'package:provider/provider.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../providers/patients_provider.dart';
import '../screens/cart_screen.dart';

enum FilterOptions {
  OnlyMarked,
  ShowAll,
}

class PatientOverview extends StatefulWidget {
  @override
  State<PatientOverview> createState() => _PatientOverviewState();
}

class _PatientOverviewState extends State<PatientOverview> {
  var _showOnlyMarked = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Patients_Provider>(context).fetchAndSetPatients().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Patient Overview'), actions: <Widget>[
        PopupMenuButton(
          onSelected: (FilterOptions selectedValue) {
            setState(() {
              if (selectedValue == FilterOptions.OnlyMarked) {
                _showOnlyMarked = true;
              } else {
                _showOnlyMarked = false;
              }
            });
          },
          icon: Icon(
            Icons.more_vert,
          ),
          itemBuilder: (_) => [
            PopupMenuItem(
                child: Text('Only Marked'), value: FilterOptions.OnlyMarked),
            PopupMenuItem(
                child: Text('Show All'), value: FilterOptions.ShowAll),
          ],
        ),
        Consumer<Cart>(
          builder: (_, cartData, ch) => Badge(
            child: ch,
            value: cartData.itemCount.toString(),
          ),
          child: IconButton(
            icon: Icon(Icons.shopping_cart_checkout),
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
        ),
      ]),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : PatientGrids(_showOnlyMarked),
    );
  }
}
