// lib/screens/user_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../presentation/typography.dart';
import '../providers/user_provider.dart';
import '../utils/date_formatter.dart';
import '../widgets/add_user_dialog.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_floating_buttons.dart'; // Import nowego komponentu
import 'user_details_screen.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  String? _errorMessage;
  bool _isLoading = true;
  List<dynamic> _filteredUsers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await Provider.of<UserProvider>(context, listen: false).fetchUsers();
      _filteredUsers = Provider.of<UserProvider>(context, listen: false).users;
    } catch (error) {
      setState(() {
        _errorMessage = 'Nie udało się załadować użytkowników. Sprawdź połączenie z serwerem.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterUsers(String query) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final users = userProvider.users;

    setState(() {
      _filteredUsers = users.where((user) => user['name'].toString().toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final users = _filteredUsers.isEmpty && _searchController.text.isEmpty ? userProvider.users : _filteredUsers;
    final double lineHeight = MediaQuery.of(context).size.height * 0.005;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dostępni użytkownicy', style: AppTypography.titleStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Wyszukaj użytkownika',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
              onChanged: _filterUsers,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(child: Text(_errorMessage!, style: AppTypography.subtitleStyle))
                      : users.isEmpty
                          ? Center(child: Text('Brak dostępnych użytkowników', style: AppTypography.subtitleStyle))
                          : ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (ctx, i) {
                                final user = users[i];
                                final createdDate = formatDate(user['createdDate']);
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF3C58F9),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                        ),
                                        height: lineHeight,
                                        width: double.infinity,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(user['name'], style: AppTypography.titleStyle),
                                            const SizedBox(height: 4),
                                            Text('Email: ${user['email']}', style: AppTypography.subtitleStyle),
                                            const SizedBox(height: 4),
                                            Text('Data utworzenia: $createdDate', style: AppTypography.subtitleStyle),
                                            const SizedBox(height: 16),
                                            CustomButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (_) => UserDetailsScreen(
                                                      userId: user['_id'].toString(),
                                                    ),
                                                  ),
                                                );
                                              },
                                              text: 'Szczegóły',
                                            ),
                                          ],
                                        ),
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
      floatingActionButton: CustomFloatingButtons(
        onRefresh: _fetchUsers,
        onAddUser: () {
          showDialog(
            context: context,
            builder: (ctx) => AddUserDialog(),
          );
        },
      ),
    );
  }
}
