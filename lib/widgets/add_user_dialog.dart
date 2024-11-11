import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../presentation/typography.dart';
import '../providers/user_provider.dart';

class AddUserDialog extends StatefulWidget {
  @override
  _AddUserDialogState createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String? errorMessage;

  void _addUser(BuildContext context) {
    if (nameController.text.isEmpty || emailController.text.isEmpty || phoneController.text.isEmpty || addressController.text.isEmpty) {
      setState(() {
        errorMessage = 'Uzupełnij wszystkie pola';
      });
    } else {
      Provider.of<UserProvider>(context, listen: false).addUser(
        nameController.text,
        emailController.text,
        phoneController.text,
        addressController.text,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Dodaj użytkownika',
        style: AppTypography.titleStyle,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Imię i Nazwisko',
              labelStyle: AppTypography.subtitleStyle,
            ),
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: AppTypography.subtitleStyle,
            ),
          ),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: 'Numer telefonu',
              labelStyle: AppTypography.subtitleStyle,
            ),
            keyboardType: TextInputType.phone,
          ),
          TextField(
            controller: addressController,
            decoration: InputDecoration(
              labelText: 'Adres',
              labelStyle: AppTypography.subtitleStyle,
            ),
          ),
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                errorMessage!,
                style: AppTypography.subtitleStyle.copyWith(color: Colors.red),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Anuluj',
            style: AppTypography.basicStyle.copyWith(color: Colors.black),
          ),
        ),
        ElevatedButton(
          onPressed: () => _addUser(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black38,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
          child: Text(
            'Dodaj',
            style: AppTypography.basicStyle.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
