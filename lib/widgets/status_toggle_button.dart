import 'package:flutter/material.dart';

class StatusToggleButton extends StatelessWidget {
  final String status;
  final VoidCallback onToggle;

  StatusToggleButton({required this.status, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        status == 'resolved' ? Icons.check_box : Icons.check_box_outline_blank,
        color: status == 'resolved' ? Colors.green : Colors.grey,
      ),
      onPressed: onToggle,
    );
  }
}
