import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _ordersFuture;
  Future _obtainOrder() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrder();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final ordersData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Selected Patient'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _ordersFuture,
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
                // ...
                // Do error handling stuff
                return Center(
                  child: Text('An error occurred!'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (ctx, ordersData, child) => ListView.builder(
                    itemCount: ordersData.orders.length,
                    itemBuilder: (ctx, i) => OrderItem(ordersData.orders[i]),
                  ),
                );
              }
            }
          },
        ));
  }
}
