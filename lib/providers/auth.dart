import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expireDate;
  String? _userId;

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAEO8C08oIzi7ATe8um9tw50FbAFJtaubk';
    final response = await http.post(Uri.parse(url),
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ));

    print(json.decode(response.body));
  }

  Future<void> signUp(String email, String password) async {
   return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
   return _authenticate(email, password, 'signInWithPassword');
  }
}
