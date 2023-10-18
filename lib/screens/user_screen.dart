
import 'package:flutter/material.dart';
import 'package:hotel_manager/models/user_model.dart';
import 'package:hotel_manager/services/user_service.dart';
import 'package:hotel_manager/utils/Roles.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final UserService _userService = UserService();
  final TextEditingController _usernameController = TextEditingController();

  List<User> _users = []; // List to hold the fetched users

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
      await _userService.fetchAllUsers();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _showSnackbar(BuildContext context, String username) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Username: $username'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _addUser() async {
    String username = _usernameController.text;
    User user = User(username, Role.user, 0);

    _showSnackbar(context, username);
    await _userService.addUser(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter your username',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _addUser();
              },
              child: const Text('Add User'),
            ),
            ElevatedButton(
              onPressed: () {
                _fetchUsers(); // Fetch users again when "Get All Users" is pressed
              },
              child: const Text('Get All Users'),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Username: ${_users[index].username}'),
                  subtitle: Text('Role: ${_users[index].role}'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
