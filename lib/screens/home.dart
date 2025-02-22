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
        ),
      body: const Center(
        child: Text('Welcome to SEIM Canary'),
      ),
    );
  }
}