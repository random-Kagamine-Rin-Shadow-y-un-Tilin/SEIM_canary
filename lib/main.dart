import 'package:flutter/material.dart';
import 'package:seim_canary/screens/home.dart';
import 'package:seim_canary/screens/login.dart';
import 'package:seim_canary/services/mongo_service.dart';
import 'package:seim_canary/screens/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoService().connect();
  print('Connected to MongoDB');
  runApp(const MainApp());

}

  class MainApp extends StatelessWidget {
    const MainApp({super.key});

    @override
    Widget build(BuildContext context) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
    );
  }   
}

