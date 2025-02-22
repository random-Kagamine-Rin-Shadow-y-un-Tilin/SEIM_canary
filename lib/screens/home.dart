import 'package:flutter/material.dart';
import 'package:seim_canary/screens/register.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const RegisterUserScreen(),
                  )
                );
              },
              child: const Icon(
                Icons.person_add_alt_1_rounded,
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: const Center(
        child: Text('Welcome to SEIM Canary'),
      ),
    );
  }
}