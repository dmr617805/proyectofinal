import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectofinal/models/cliente.dart';
import 'package:proyectofinal/models/producto.dart';
import 'package:proyectofinal/models/sucursal.dart';
import 'package:proyectofinal/models/usuario.dart';
import 'package:proyectofinal/screens/cliente/cliente_form_screen.dart';
import 'package:proyectofinal/screens/cliente/cliente_screen.dart';
import 'package:proyectofinal/screens/home_page.dart';
import 'package:proyectofinal/screens/login_screen.dart';
import 'package:proyectofinal/screens/metodo_pago/metodo_pago_form_screen.dart';
import 'package:proyectofinal/screens/producto/producto_form_screen.dart';
import 'package:proyectofinal/screens/producto/producto_screen.dart';
import 'package:proyectofinal/screens/sucursal/sucursal_form_screen.dart';
import 'package:proyectofinal/screens/sucursal/sucursal_screen.dart';
import 'package:proyectofinal/screens/usuario/usuario_form_screen.dart';
import 'package:proyectofinal/screens/usuario/usuario_screen.dart';
import 'package:proyectofinal/screens/venta/venta_form_screen.dart';
import 'package:proyectofinal/viewmodels/cliente_viewmodel.dart';
import 'package:proyectofinal/viewmodels/metodo_pago_viewmodel.dart';
import 'package:proyectofinal/viewmodels/producto_viewmodel.dart';
import 'package:proyectofinal/viewmodels/sucursal_viewmodel.dart';
import 'package:proyectofinal/viewmodels/usuario_viewmodel.dart';
import 'package:proyectofinal/viewmodels/venta_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClienteViewModel()),
        ChangeNotifierProvider(create: (_) => SucursalViewModel()),
        ChangeNotifierProvider(create: (_) => ProductoViewModel()),
        ChangeNotifierProvider(create: (_) => VentaViewModel()),
        ChangeNotifierProvider(create: (_) => MetodoPagoViewmodel()),
        ChangeNotifierProvider(create: (_) => UsuarioViewModel()),
      ],
      child: MaterialApp(
        title: 'Proyecto Final',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        initialRoute: LoginScreen.routeName,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case LoginScreen.routeName:
              return MaterialPageRoute(builder: (_) => const LoginScreen());

            case HomePage.routeName:              
              return MaterialPageRoute(builder: (_) => HomePage());

            case ClienteScreen.routeName:
              return MaterialPageRoute(builder: (_) => const ClienteScreen());

            case ClienteFormScreen.routeName:
              final cliente = settings.arguments as Cliente?;
              return MaterialPageRoute(
                builder: (_) => ClienteFormScreen(cliente: cliente),
              );

            case SucursalScreen.routeName:
              return MaterialPageRoute(builder: (_) => const SucursalScreen());

            case SucursalFormScreen.routeName:
              final sucursal = settings.arguments as Sucursal?;
              return MaterialPageRoute(
                builder: (_) => SucursalFormScreen(sucursal: sucursal),
              );

            case ProductoScreen.routeName:
              return MaterialPageRoute(builder: (_) => const ProductoScreen());

            case ProductoFormScreen.routeName:
              final producto = settings.arguments as Producto?;
              return MaterialPageRoute(
                builder: (_) => ProductoFormScreen(producto: producto),
              );

            case VentaFormScreen.routeName:
              return MaterialPageRoute(builder: (_) => const VentaFormScreen());

            case MetodoPagoFormScreen.routeName:
              return MaterialPageRoute(builder: (_) => const MetodoPagoFormScreen());

           case UsuarioScreen.routeName:
              return MaterialPageRoute(builder: (_) => const UsuarioScreen());

            case UsuarioFormScreen.routeName:
              final usuario = settings.arguments as Usuario?;
              return MaterialPageRoute(
                builder: (_) => UsuarioFormScreen(usuario: usuario),
              );


            default:
              return null;
          }
        },
      ),
    );
  }
}
