import 'dart:io';
import 'package:seim_canary/models/user_model.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class MongoService {
  static final MongoService _instance = MongoService._internal();

  late mongo.Db _db;
  late mongo.DbCollection _userCollection;

  MongoService._internal();

  factory MongoService() {
    return _instance;
  }

  // Conecta a la base de datos
  Future<void> connect() async {
    try {
      _db = await mongo.Db.create(
          'mongodb+srv://diegonicolas:lkHF513apl5CmJBE@cluster0.xqp2g.mongodb.net/SEIM_prueba?retryWrites=true&w=majority&appName=Cluster0');
      await _db.open();
      _userCollection = _db.collection('Users');
      print('Connected to MongoDB Atlas');
    } on SocketException catch (e) {
      print('Error de conexión: $e');
      rethrow;
    } catch (e) {
      print('Error al conectar a la base de datos: $e');
      rethrow;
    }
  }

  // Verificar credenciales de un usuario para login
Future<UserModel?> loginUser(String email, String encryptedPassword) async {
  try {
    // Buscar al usuario por email
    var user = await _userCollection.findOne(mongo.where.eq('email', email));

    if (user != null) {
      // Obtener la contraseña almacenada en la base de datos
      final storedPassword = user['password'];

      // Comparar las contraseñas encriptadas
      if (storedPassword == encryptedPassword) {
        return UserModel.fromJson(user); // Devuelve el usuario si las contraseñas coinciden
      }
    }
    return null; // Devuelve null si el usuario no existe o las contraseñas no coinciden
  } catch (e) {
    print('Error al iniciar sesión: $e');
    rethrow;
  }
}

  // Obtener usuario por ID
  Future<UserModel?> getUserById(String id) async {
    try {
      var user = await _userCollection.findOne(mongo.where.eq('_id', mongo.ObjectId.fromHexString(id)));
      if (user != null) {
        return UserModel.fromJson(user);
      } else {
        return null;
      }
    } catch (e) {
      print('Error al obtener usuario por ID: $e');
      rethrow;
    }
  }

  mongo.Db get db {
    if (!_db.isConnected) {
      throw StateError('Database is not connected');
    }
    return _db;
  }

  Future<List<UserModel>> getUsers() async {
    final collection = _db.collection('Users');
    final users = await collection.find().toList();
    return users.map((user) => UserModel.fromJson(user)).toList();
  }

  Future<void> addUser(UserModel user) async {
    _db.databaseName = 'SEIM_prueba';
    final collection = db.collection('Users');
    await collection.insertOne(user.toJson());
  }

  Future<void> updateUser(UserModel user) async {
    final collection = _db.collection('Users');
    await collection.updateOne(
        mongo.where.eq('_id', user.id),
        mongo.modify
            .set('username', user.username)
            .set('email', user.email)
            .set('phone', user.phone)
            .set('password', user.password));
  }

  Future<void> deleteUser(UserModel user) async {
    final collection = _db.collection('Users');
    await collection.deleteOne(mongo.where.eq('_id', user.id));
  }

  void close() {
    _db.close();
  }
}