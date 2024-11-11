import 'package:flutter/material.dart';

class CustomFloatingButtons extends StatelessWidget {
  final VoidCallback onRefresh;
  final VoidCallback onAddUser;

  CustomFloatingButtons({required this.onRefresh, required this.onAddUser});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: onRefresh,
          child: Icon(Icons.refresh),
          heroTag: "refreshButton",
        ),
        SizedBox(width: 16),
        FloatingActionButton(
          onPressed: onAddUser,
          child: Icon(Icons.add),
          heroTag: "addButton",
        ),
      ],
    );
  }
}
