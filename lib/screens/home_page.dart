import 'package:flutter/material.dart';
import 'package:seim_canary/screens/home.dart';
import 'package:seim_canary/screens/login.dart';
import 'package:seim_canary/screens/register.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Índice para cambiar las páginas
  int _selectedIndex = 0;

  // Lista de widgets para mostrar en el cuerpo
  static const List<Widget> _widgetOptions = <Widget>[
    //agregar las screens que se quieran mostrar
    HomeScreen(),
    LoginScreen(),
    RegisterUserScreen(),
  ];

  // Método para cambiar de página cuando se selecciona una opción
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cambia el índice
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SEIM'),
      ),
      body: Center(
        child: _widgetOptions
            .elementAt(_selectedIndex), // Muestra la página correspondiente
      ),
      // Implementación del BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Indica el ítem seleccionado
        onTap: _onItemTapped, // Llama a la función cuando se selecciona un ítem
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuraciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
