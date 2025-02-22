import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:crypto/crypto.dart';
import 'dart:convert';

class UserModel {
  final mongo.ObjectId id;
  String username;
  String email;
  int phone;
  String password;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
  });

  // Método para hashear la contraseña antes de almacenarla
  static String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    var id = json['_id'];
    if (id is String) {
      try {
        id = mongo.ObjectId.fromHexString(id);
      } catch (e) {
        id = mongo.ObjectId();
      }
    } else if (id is! mongo.ObjectId) {
      id = mongo.ObjectId();
    }
    return UserModel(
      id: id as mongo.ObjectId,
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as int,
      password: json['password'] as String,
    );
  }
}
