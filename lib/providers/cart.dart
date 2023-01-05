import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String name;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.name,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _patients = {};

  Map<String, CartItem> get patient {
    return {..._patients};
  }

  int get itemCount {
    return _patients.length;
  }

  double get totalAmount {
    var total = 0.0;
    _patients.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(
    String patientId,
    double price,
    String name,
  ) {
    if (_patients.containsKey(patientId)) {
      // change quantity...
      _patients.update(
        patientId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          name: existingCartItem.name,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _patients.putIfAbsent(
        patientId,
        () => CartItem(
          id: DateTime.now().toString(),
          name: name,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String patientId) {
    _patients.remove(patientId);
    notifyListeners();
  }

  void removeSingleItem(String patientId) {
    if (!_patients.containsKey(patientId)) {
      return;
    }
    if (_patients[patientId].quantity > 1) {
      _patients.update(
        patientId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          name: existingCartItem.name,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _patients.remove(patientId);
    }
    notifyListeners();
  }

  void clear() {
    _patients = {};
    notifyListeners();
  }
}
