import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../presentation/typography.dart';
import '../providers/user_provider.dart';
import '../utils/date_formatter.dart';
import '../widgets/custom_button.dart';
import 'task_list_screen.dart';

class UserDetailsScreen extends StatelessWidget {
  final String userId;

  UserDetailsScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.users.firstWhere(
      (user) => user['_id'].toString() == userId,
      orElse: () => null,
    );

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Szczegóły użytkownika', style: AppTypography.titleStyle),
        ),
        body: Center(
          child: Text('Nie znaleziono użytkownika', style: AppTypography.subtitleStyle),
        ),
      );
    }

    final name = user['name'] ?? 'Nieznane imię';
    final email = user['email'] ?? 'Brak adresu e-mail';
    final createdDate = user['createdDate'] != null ? formatDate(user['createdDate']) : 'Brak daty utworzenia';
    final address = user['address'] ?? 'Brak adresu';
    final phone = user['phone'] ?? 'Brak numeru telefonu';

    return Scaffold(
      appBar: AppBar(
        title: Text('Szczegóły użytkownika', style: AppTypography.titleStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Imię i nazwisko:', style: AppTypography.subtitleStyle),
            Text(name, style: AppTypography.basicStyle),
            const SizedBox(height: 8),
            Text('Email:', style: AppTypography.subtitleStyle),
            Text(email, style: AppTypography.basicStyle),
            const SizedBox(height: 8),
            Text('Data utworzenia:', style: AppTypography.subtitleStyle),
            Text(createdDate, style: AppTypography.basicStyle),
            const SizedBox(height: 8),
            Text('Adres:', style: AppTypography.subtitleStyle),
            Text(address, style: AppTypography.basicStyle),
            const SizedBox(height: 8),
            Text('Telefon:', style: AppTypography.subtitleStyle),
            Text(phone, style: AppTypography.basicStyle),
            const SizedBox(height: 16),
            CustomButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => TaskListScreen(userId: userId.toString()),
                  ),
                );
              },
              text: 'Przeglądaj zadania',
            ),
          ],
        ),
      ),
    );
  }
}
