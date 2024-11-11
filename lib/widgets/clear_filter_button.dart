import 'package:flutter/material.dart';

class ClearFilterButton extends StatelessWidget {
  final VoidCallback onClear;

  ClearFilterButton({required this.onClear});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.clear),
      onPressed: onClear,
    );
  }
}
