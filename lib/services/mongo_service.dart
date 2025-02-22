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
      print('Conectado a MongoDB Atlas');
    } on SocketException catch (e) {
      print('Error de conexión: $e');
      rethrow;
    } catch (e) {
      print('Error al conectar a la base de datos: $e');
      rethrow;
    }
  }

//  Verifica si un usuario ya existe en la base de datos
  Future<bool> userExists(String email) async {
    try {
        var user = await _userCollection.findOne(mongo.where.eq('email', email));
        return user != null;
    } catch (e) {
      print('Error al verificar usuario: $e');
      rethrow;
    }
  } 

  mongo.Db get db {
    if (!_db.isConnected) {
      throw StateError('Database is not connected');
    }
    return _db;
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
