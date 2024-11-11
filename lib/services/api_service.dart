import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  // Pobierz listę użytkowników
  static Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Pobierz szczegóły użytkownika
  static Future<Map<String, dynamic>> fetchUserDetails(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user details');
    }
  }

  // Pobierz zadania dla użytkownika
  static Future<List<dynamic>> fetchTasks(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/tasks/user/$userId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  // Dodaj nowe zadanie dla użytkownika
  static Future<Map<String, dynamic>> addTask(String userId, String description) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks/user/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'description': description}),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add task');
    }
  }

  // Zaktualizuj status zadania
  static Future<Map<String, dynamic>> updateTaskStatus(String taskId, String status) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/tasks/$taskId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'status': status}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update task status');
    }
  }

  // Usuń zadanie
  static Future<void> deleteTask(String taskId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/tasks/$taskId'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }

  // Dodaj nowego użytkownika
  static Future<Map<String, dynamic>> addUser(String name, String email, String phone, String address) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'email': email, 'phone': phone, 'address': address}),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add user');
    }
  }
}
