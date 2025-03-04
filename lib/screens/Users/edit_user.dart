import 'package:flutter/material.dart';
import 'package:seim_canary/models/user_model.dart';
import 'package:seim_canary/screens/Users/login.dart'; // Importa LoginScreen
import 'package:seim_canary/services/mongo_service.dart';
import 'package:seim_canary/screens/Users/password.dart';

class EditUserScreen extends StatefulWidget {
  final UserModel user;
  final Function(UserModel) onUserUpdated; // Callback para actualizar el estado

  const EditUserScreen({
    super.key,
    required this.user,
    required this.onUserUpdated, // Recibe el callback
  });

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late UserModel _localUser;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _localUser = widget.user;
    _usernameController = TextEditingController(text: _localUser.username);
    _emailController = TextEditingController(text: _localUser.email);
    _phoneController = TextEditingController(text: _localUser.phone.toString());
    print('Initialized _localUser: $_localUser'); // Add logging
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _updateUser() async {
    print('Current password: ${_localUser.password}'); // Add logging
    var updatedUser = _localUser.copyWith(
      username: _usernameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      password: _localUser.password, // Preserve the existing password
    );

    await MongoService().updateUser(updatedUser);

    if (!mounted) return;

    setState(() {
      _localUser = updatedUser;
    });

    // Llama al callback para actualizar el estado en la pantalla anterior
    widget.onUserUpdated(updatedUser);
  }

  void _logout() {
    // Redirige a LoginScreen y reemplaza la pantalla actual
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  void _navigateToChangePassword() {
    // Navega a ChangePasswordScreen y pasa el ID del usuario actual
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditPasswordScreen(
          userId: _localUser.id.toHexString(),
          user: _localUser,
          onUserUpdated: (updatedUser) {
            setState(() {
              _localUser = updatedUser; // Update the user with the new password
            });
            widget.onUserUpdated(updatedUser);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Usuario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout), // Botón de logout
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            TextField(
              style: const TextStyle(color: Colors.white),
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Nombre de Usuario'),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              style: const TextStyle(color: Colors.white),
              controller: _emailController,
              decoration:
                  const InputDecoration(labelText: 'Correo Electrónico'),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              style: const TextStyle(color: Colors.white),
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Teléfono'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUser,
              child: const Text('Guardar Cambios'),
            ),
            const SizedBox(
              height: 16,
            ),
            TextButton(
              onPressed: _navigateToChangePassword,
              child: const Text('Cambiar Contraseña'),
            )
          ],
        ),
      ),
    );
  }
}