import 'package:flutter/material.dart';
import 'package:user_management/services/api_service.dart';

class TaskProvider with ChangeNotifier {
  Map<String, List<dynamic>> _tasks = {};

  List<dynamic> getTasksForUser(String userId) {
    return _tasks[userId] ?? []; // Zwraca pustą listę, jeśli brak zadań
  }

  Future<void> fetchTasks(String userId) async {
    print('Fetching tasks for userId: $userId');
    try {
      _tasks[userId] = await ApiService.fetchTasks(userId);
      print('Tasks fetched for userId $userId: ${_tasks[userId]}');
      notifyListeners();
    } catch (error) {
      print('Failed to load tasks for userId $userId: $error');
      _tasks[userId] = []; // Upewnij się, że _tasks[userId] to pusta lista w przypadku błędu
    }
  }

  // Dodaj nowe zadanie
  Future<void> addTask(String userId, String description) async {
    try {
      final newTask = await ApiService.addTask(userId, description);
      _tasks[userId] = [...getTasksForUser(userId), newTask];
      notifyListeners();
    } catch (error) {
      print('Failed to add task: $error');
    }
  }

  // Zaktualizuj status zadania
  void updateTaskStatus(String userId, String taskId, String newStatus) async {
    final updatedTask = await ApiService.updateTaskStatus(taskId, newStatus);

    // Znajdź zadanie i zaktualizuj jego status lokalnie
    final taskIndex = _tasks[userId]?.indexWhere((task) => task['_id'] == taskId) ?? -1;
    if (taskIndex != -1) {
      _tasks[userId]?[taskIndex] = updatedTask;
      notifyListeners(); // Powiadomienie widoku o aktualizacji
    }
  }

  // Usuń zadanie
  void removeTask(String userId, String taskId) async {
    await ApiService.deleteTask(taskId);
    _tasks[userId]?.removeWhere((task) => task['_id'] == taskId);
    notifyListeners();
  }
}
