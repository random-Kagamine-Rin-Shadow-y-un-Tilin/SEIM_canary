import 'package:flutter/material.dart';
import 'package:seim_canary/models/user_model.dart';
import 'package:seim_canary/services/mongo_service.dart';

class EditPasswordScreen extends StatefulWidget {
  final UserModel user;
  final Function(UserModel) onUserUpdated; // Callback para actualizar el estado

  const EditPasswordScreen({
    super.key,
    required this.user,
    required this.onUserUpdated,
    required String userId, // Recibe el callback
  });

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  late TextEditingController _passwordController;
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _updatePassword() async {
    if (_formKey.currentState!.validate()) {
      // Encripta la contraseña antes de actualizar el usuario
      final encryptedPassword = UserModel.hashPassword(_passwordController.text);

      print('Updating password to: ${_passwordController.text}'); // Add logging
      await MongoService().updateUserPassword(widget.user.id.toHexString(), encryptedPassword);

      if (!mounted) return;

      // Actualiza solo la contraseña del usuario
      var updatedUser = widget.user.copyWith(password: encryptedPassword);

      // Llama al callback para actualizar el estado en la pantalla anterior
      widget.onUserUpdated(updatedUser);

      // Navega de regreso a la pantalla anterior (home page)
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: _passwordController,
                obscureText: _isObscure,
                validator: (value) =>
                    value!.length < 6 ? "Mínimo 6 caracteres" : null,
                decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        })),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updatePassword,
                child: const Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
