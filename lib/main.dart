import 'package:flutter/material.dart';
import 'package:seim_canary/screens/Devices/register_device.dart';
import 'screens/Users/login.dart';
import 'services/mongo_service.dart';
import 'screens/home.dart';
import 'screens/home_page.dart';
import 'screens/Users/register.dart';
import 'widgets/theme.dart';
import 'models/user_model.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeMain(),
      home: const LoginScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(builder: (context) => const HomeScreen());
          case '/home_page':
            final user = settings.arguments as UserModel; // Obtén el user de los argumentos
            return MaterialPageRoute(builder: (context) => HomePage(user: user));
          case '/register':
            return MaterialPageRoute(builder: (context) => const RegisterUserScreen());
          case '/dispositivos:':
            return MaterialPageRoute(builder: (context) => const RegisterDeviceScreen());
          default:
            return MaterialPageRoute(builder: (context) => const LoginScreen());
        }
      },
    );
  }
}