import 'package:flutter/material.dart';

import '../services/api_service.dart';

class UserProvider with ChangeNotifier {
  List<dynamic> _users = [];

  List<dynamic> get users => _users;

  Future<void> fetchUsers() async {
    try {
      print('Fetching users...'); // Log przed wysłaniem żądania
      _users = await ApiService.fetchUsers();
      print('Fetched users: $_users'); // Log po otrzymaniu odpowiedzi
      notifyListeners();
    } catch (error) {
      print('Failed to load users: $error');
    }
  }

  Future<void> addUser(String name, String email, String phone, String address) async {
    final newUser = await ApiService.addUser(name, email, phone, address);
    _users.add(newUser);
    notifyListeners();
  }
}
