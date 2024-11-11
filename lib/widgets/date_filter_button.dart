import 'package:flutter/material.dart';

class DateFilterButton extends StatelessWidget {
  final Function(DateTime) onDateSelected;

  DateFilterButton({required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.calendar_today),
      onPressed: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (selectedDate != null) {
          onDateSelected(selectedDate);
        }
      },
    );
  }
}
