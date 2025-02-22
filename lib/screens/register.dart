import 'package:flutter/material.dart';
import 'package:seim_canary/models/user_model.dart';
import 'package:seim_canary/services/mongo_service.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Función para validar email
  bool _isValidEmail(String email) {
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(email);
  }

  // Función para registrar usuario
  void _insertUser() async {
    if (!_formKey.currentState!.validate()) return;

    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    int phone = int.parse(_phoneController.text.trim());
    String password = UserModel.hashPassword(_passwordController.text.trim());

    // Verificar si el usuario ya existe en la base de datos
    bool userExists = await MongoService().userExists(email);
    if (userExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("El correo ya está registrado")),
      );
      return;
    }

    var user = UserModel(
      id: mongo.ObjectId(),
      username: username,
      email: email,
      phone: phone,
      password: password,
    );

    await MongoService().addUser(user);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Usuario registrado con éxito")),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration:
                    const InputDecoration(labelText: 'Nombre de Usuario'),
                validator: (value) => value!.isEmpty ? "Campo requerido" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration:
                    const InputDecoration(labelText: 'Correo Electrónico'),
                validator: (value) => value!.isEmpty
                    ? "Campo requerido"
                    : (_isValidEmail(value) ? null : "Email inválido"),
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Campo requerido" : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) =>
                    value!.length < 6 ? "Mínimo 6 caracteres" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _insertUser,
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
