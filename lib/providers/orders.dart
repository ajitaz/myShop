import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
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

  Future<void> fetchAndSetOrders() async {
    const url =
        'https://flutterproject-e1375-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json';
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedData = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>?;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((ordId, ordData) {
      loadedData.add(
        OrderItem(
          id: ordId,
          amount: ordData['amount'],
          dateTime: DateTime.parse(ordData['dateTime']),
          products: (ordData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  price: item['price'],
                  quantity: item['quantity']))
              .toList(),
        ),
      );
    });
    _orders = loadedData.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartItems, double amount) async {
    const url =
        'https://flutterproject-e1375-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json';
    final timeStamp = DateTime.now();
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'amount': amount,
        'dateTime': timeStamp.toIso8601String(),
        'products': cartItems
            .map((item) => {
                  'id': item.id,
                  'title': item.title,
                  'price': item.price,
                  'quantity': item.quantity,
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: amount,
        products: cartItems,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
  }
}
