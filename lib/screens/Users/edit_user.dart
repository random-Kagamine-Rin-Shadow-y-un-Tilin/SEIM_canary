import 'package:flutter/material.dart';
import 'package:seim_canary/models/user_model.dart';
import 'package:seim_canary/screens/Users/login.dart'; // Importa LoginScreen
import 'package:seim_canary/services/mongo_service.dart';

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
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone.toString());
    _passwordController = TextEditingController(text: widget.user.password);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updateUser() async {
    // Encripta la contraseña antes de actualizar el usuario
    final encryptedPassword = UserModel.hashPassword(_passwordController.text);

    var updatedUser = UserModel(
      id: widget.user.id,
      username: _usernameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      password: encryptedPassword, // Usa la contraseña encriptada
    );

    await MongoService().updateUser(updatedUser);

    if (!mounted) return;

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
            const SizedBox(height: 16,),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Nombre de Usuario'),
            ),
            const SizedBox(height: 16,),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Correo Electrónico'),
            ),
            const SizedBox(height: 16,),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Teléfono'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16,),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUser,
              child: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}