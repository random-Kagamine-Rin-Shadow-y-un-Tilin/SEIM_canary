import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'dart:convert'; // Para utf8.encode
import 'package:crypto/crypto.dart'; // Para sha256

class UserModel {
  final mongo.ObjectId id;
  final String username;
  final String email;
  final String phone;
  final String password;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
  });

  // Método para convertir un documento JSON a UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as mongo.ObjectId,
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'].toString(),
      password: json['password'] as String,
    );
  }

  // Método para convertir UserModel a JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'phone': phone, 
      'password': password,
    };
  }

  // Método para encriptar contraseñas
  static String hashPassword(String password) {
    final bytes = utf8.encode(password); // Convierte la contraseña a bytes
    final digest = sha256.convert(bytes); // Aplica el algoritmo SHA-256
    return digest.toString(); // Devuelve el hash como una cadena
  }
}