import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final VoidCallback onDelete;

  DeleteButton({required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.red),
      onPressed: onDelete,
    );
  }
}
