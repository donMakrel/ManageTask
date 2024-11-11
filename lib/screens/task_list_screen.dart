// lib/screens/task_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../presentation/typography.dart';
import '../providers/task_provider.dart';
import '../utils/date_formatter.dart';
import '../widgets/add_task_button.dart';
import '../widgets/clear_filter_button.dart'; // Import czyszczenia filtra
import '../widgets/date_filter_button.dart'; // Import daty
import '../widgets/delete_button.dart'; // Import usuwania
import '../widgets/status_toggle_button.dart';

class TaskListScreen extends StatefulWidget {
  final String userId;

  TaskListScreen({required this.userId});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String? _filterStatus;
  DateTime? _filterDate;

  @override
  void initState() {
    super.initState();
    Provider.of<TaskProvider>(context, listen: false).fetchTasks(widget.userId);
  }

  List<Map<String, dynamic>> _getFilteredTasks(List<Map<String, dynamic>> tasks) {
    return tasks.where((task) {
      final taskDate = DateTime.parse(task['createdDate']);
      final matchesStatus = _filterStatus == null || task['status'] == _filterStatus;
      final matchesDate = _filterDate == null || sameDay(taskDate, _filterDate!);

      return matchesStatus && matchesDate;
    }).toList();
  }

  bool sameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  String getStatusText(String status) {
    return status == 'resolved' ? 'Rozwiązane' : 'Nierozwiązane';
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = _getFilteredTasks(
      (taskProvider.getTasksForUser(widget.userId) as List).cast<Map<String, dynamic>>(),
    );
    final TextEditingController taskController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Zadania użytkownika', style: AppTypography.titleStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: InputDecoration(
                      hintText: 'Nowe zadanie',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                AddTaskButton(
                  controller: taskController,
                  onAdd: () => taskProvider.addTask(widget.userId, taskController.text),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  hint: const Text("Filtruj po statusie"),
                  value: _filterStatus,
                  items: const [
                    DropdownMenuItem(value: null, child: Text('Wszystkie')),
                    DropdownMenuItem(value: 'resolved', child: Text('Rozwiązane')),
                    DropdownMenuItem(value: 'unresolved', child: Text('Nierozwiązane')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _filterStatus = value;
                    });
                  },
                ),
                DateFilterButton(
                  onDateSelected: (selectedDate) {
                    setState(() {
                      _filterDate = selectedDate;
                    });
                  },
                ),
                if (_filterDate != null)
                  ClearFilterButton(
                    onClear: () {
                      setState(() {
                        _filterDate = null;
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: tasks.isEmpty
                  ? Center(
                      child: Text(
                        'Brak przypisanych zadań',
                        style: AppTypography.subtitleStyle,
                      ),
                    )
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (ctx, i) {
                        final task = tasks[i];
                        final description = (task['description'] ?? 'Brak opisu').toString();
                        final status = (task['status'] ?? 'Nieznany status').toString();
                        final createdDate = task['createdDate'] != null ? formatDate(task['createdDate']) : 'Brak daty';
                        final taskId = (task['_id'] ?? '').toString();

                        return ListTile(
                          title: Text(description, style: AppTypography.basicStyle),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Data utworzenia: $createdDate', style: AppTypography.subtitleStyle),
                              Text(
                                'Status: ${getStatusText(status)}',
                                style: status == 'resolved'
                                    ? AppTypography.taskStatusStyle.copyWith(color: Colors.green)
                                    : AppTypography.taskStatusStyle.copyWith(color: Colors.red),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DeleteButton(
                                onDelete: () {
                                  if (taskId.isNotEmpty) {
                                    taskProvider.removeTask(widget.userId, taskId);
                                  }
                                },
                              ),
                              StatusToggleButton(
                                status: status,
                                onToggle: () {
                                  if (taskId.isNotEmpty) {
                                    final newStatus = status == 'resolved' ? 'unresolved' : 'resolved';
                                    taskProvider.updateTaskStatus(widget.userId, taskId, newStatus);
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
