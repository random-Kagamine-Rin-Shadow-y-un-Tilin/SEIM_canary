import 'dart:io';
import 'package:seim_canary/models/user_model.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class MongoService {
  static final MongoService _instance = MongoService._internal();

  mongo.Db? _db; // Changed to nullable
  late mongo.DbCollection _userCollection;

  MongoService._internal();

  factory MongoService() {
    return _instance;
  }

  // Connect to the database
  Future<void> connect() async {
    if (_db != null && _db!.isConnected) {
      return;
    }
    try {
      _db = await mongo.Db.create(
          'mongodb+srv://diegonicolas:lkHF513apl5CmJBE@cluster0.xqp2g.mongodb.net/SEIM_prueba?retryWrites=true&w=majority&appName=Cluster0');
      await _db!.open();
      _userCollection = _db!.collection('Users');
      print('Connected to MongoDB Atlas');
    } on SocketException catch (e) {
      print('Connection error: $e');
      rethrow;
    } catch (e) {
      print('Error connecting to the database: $e');
      rethrow;
    }
  }

  // Verify user credentials for login
  Future<UserModel?> loginUser(String email, String encryptedPassword) async {
    await connect();
    try {
      var user = await _userCollection.findOne(mongo.where.eq('email', email));
      if (user != null) {
        final storedPassword = user['password'];
        if (storedPassword == encryptedPassword) {
          return UserModel.fromJson(user);
        }
      }
      return null;
    } catch (e) {
      print('Error logging in: $e');
      rethrow;
    }
  }

  // Get user by ID
  Future<UserModel?> getUserById(String id) async {
    await connect();
    try {
      var user = await _userCollection.findOne(mongo.where.eq('_id', mongo.ObjectId.fromHexString(id)));
      return user != null ? UserModel.fromJson(user) : null;
    } catch (e) {
      print('Error getting user by ID: $e');
      rethrow;
    }
  }

  mongo.Db get db {
    if (_db == null || !_db!.isConnected) {
      throw StateError('Database is not connected or has not been initialized');
    }
    return _db!;
  }

  Future<List<UserModel>> getUsers() async {
    await connect();
    final users = await _userCollection.find().toList();
    return users.map((user) => UserModel.fromJson(user)).toList();
  }

  Future<void> addUser(UserModel user) async {
    await connect();
    await _userCollection.insertOne(user.toJson());
  }

  Future<void> updateUser(UserModel user) async {
    await connect();
    var modifier = mongo.modify
        .set('username', user.username)
        .set('email', user.email)
        .set('phone', user.phone);
    if (user.password != null) {
      modifier = modifier.set('password', user.password);
    }
    await _userCollection.updateOne(
        mongo.where.eq('_id', user.id),
        modifier);
  }

  Future<void> updateUserPassword(String userId, String newPassword) async {
    await connect();
    print('Updating password for userId: $userId');
    await _userCollection.updateOne(
      mongo.where.eq('_id', mongo.ObjectId.fromHexString(userId)),
      mongo.modify.set('password', newPassword),
    );
    print('Password updated successfully');
  }

  Future<void> deleteUser(UserModel user) async {
    await connect();
    await _userCollection.deleteOne(mongo.where.eq('_id', user.id));
  }

  void close() {
    _db?.close();
  }
}
