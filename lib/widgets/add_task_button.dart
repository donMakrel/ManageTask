import 'package:flutter/material.dart';

class AddTaskButton extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAdd;

  AddTaskButton({required this.controller, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add, color: Colors.blue),
      onPressed: () {
        if (controller.text.isNotEmpty) {
          onAdd();
          controller.clear();
        }
      },
    );
  }
}
