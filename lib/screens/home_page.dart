// pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectofinal/screens/cliente/cliente_screen.dart';
import 'package:proyectofinal/screens/producto/producto_screen.dart';
import 'package:proyectofinal/screens/reporte_inventario/reporte_inventario_screen.dart';
import 'package:proyectofinal/screens/reporte_ventas/reporte_ventas_screen.dart';
import 'package:proyectofinal/screens/sucursal/sucursal_screen.dart';
import 'package:proyectofinal/screens/usuario/usuario_screen.dart';
import 'package:proyectofinal/screens/venta/venta_screen.dart';
import 'package:proyectofinal/screens/venta/venta_form_screen.dart';
import 'package:proyectofinal/viewmodels/usuario_viewmodel.dart';
import 'package:proyectofinal/viewmodels/venta_viewmodel.dart';
import 'login_screen.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  Future<void> _logout(BuildContext context) async {
    final usuarioViewModel = Provider.of<UsuarioViewModel>(
      context,
      listen: false,
    );
    usuarioViewModel.logout();

    final ventaViewModel = Provider.of<VentaViewModel>(context, listen: false);
    ventaViewModel.limpiarVentas();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Drawer _buildAdminDrawer(BuildContext context, String nombre, String correo) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            accountName: Text(nombre),
            accountEmail: Text(correo),
          ),
          ListTile(
            title: Text('Usuarios'),
            leading: Icon(Icons.person),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, UsuarioScreen.routeName);
            },
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
          ListTile(
            title: Text('Nueva Venta'),
            leading: Icon(Icons.add_shopping_cart),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, VentaFormScreen.routeName);
            },
          ),
          ListTile(
            title: Text('Reporte de Inventario'),
            leading: Icon(Icons.inventory),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, ReporteInventarioScreen.routeName);
            },
          ),
          // reporte de ventas
          ListTile(
            title: Text('Reporte de Ventas'),
            leading: Icon(Icons.receipt_long),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, ReporteVentasScreen.routeName);
            },
          ),
          ListTile(
            title: Text('Cerrar Sesión'),
            leading: Icon(Icons.logout),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }

  Drawer _buildUserDrawer(BuildContext context, String nombre, String correo) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            accountName: Text(nombre),
            accountEmail: Text(correo),
          ),
          ListTile(
            title: Text('Nueva Venta'),
            leading: Icon(Icons.add_shopping_cart),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, VentaFormScreen.routeName);
            },
          ),
          ListTile(
            title: Text('Cerrar Sesión'),
            leading: Icon(Icons.logout),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuarioViewModel = Provider.of<UsuarioViewModel>(context);
    final usuario = usuarioViewModel.usuario;

    final nombre = '${usuario?.nombre} ${usuario?.apellidoPaterno}';
    final correo = usuario?.correo ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bienvenido ${usuario?.nombre}',
          style: TextStyle(
            color:Theme.of(context).colorScheme.onPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      drawer:
          usuario?.esAdmin == true
              ? _buildAdminDrawer(context, nombre, correo)
              : _buildUserDrawer(context, nombre, correo),
      body: VentaScreen(),
    );
  }
}
