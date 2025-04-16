// pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:proyectofinal/screens/cliente/cliente_screen.dart';
import 'package:proyectofinal/screens/producto/producto_screen.dart';
import 'package:proyectofinal/screens/sucursal/sucursal_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';
  final String username;
  const HomePage({super.key, required this.username});

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("username");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido $username'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.all(0),
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              accountName: Text('John Doe'),
              accountEmail: Text('john.doe@mail.com'),
            ),

            ListTile(
              title: Text('Productos'),
              leading: Icon(Icons.shopping_cart),
              onTap: () {
                Navigator.pop(context); 
                Navigator.pushNamed(context, ProductoScreen.routeName);
              },
            ),
            ListTile(
              title: Text('Sucursales'),
              leading: Icon(Icons.store),
              onTap: () {
                Navigator.pop(context); 
                Navigator.pushNamed(context, SucursalScreen.routeName);
              },
            ),
            ListTile(
              title: Text('Clientes'),
              leading: Icon(Icons.person),
              onTap: () {
                Navigator.pop(context); 
                Navigator.pushNamed(context, ClienteScreen.routeName);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('¡Hola, $username!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
