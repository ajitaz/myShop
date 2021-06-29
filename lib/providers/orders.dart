import 'package:flutter/foundation.dart';
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.dateTime,
      required this.products});
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartItems, double amount) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: amount,
        products: cartItems,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
