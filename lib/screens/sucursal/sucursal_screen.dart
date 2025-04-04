import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectofinal/screens/sucursal/sucursal_form_screen.dart';
import 'package:proyectofinal/viewmodels/sucursal_viewmodel.dart';

class SucursalScreen extends StatefulWidget {
  static const String routeName = '/sucursales';

  const SucursalScreen({super.key});

  @override
  State<SucursalScreen> createState() => _SucursalScreenState();
}

class _SucursalScreenState extends State<SucursalScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<SucursalViewModel>(
            context,
            listen: false,
          ).cargarSucursales(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SucursalViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Sucursales')),
      body:
          vm.sucursales.isEmpty
              ? Center(child: Text('No hay sucursales registradas.'))
              : ListView.builder(
                itemCount: vm.sucursales.length,
                itemBuilder: (context, index) {
                  final sucursal = vm.sucursales[index];
                  return ListTile(
                    title: Text(sucursal.nombre),
                    subtitle: Text(sucursal.ubicacion),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              SucursalFormScreen.routeName,
                              arguments: sucursal,
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            vm.eliminar(sucursal.idSucursal!);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(SucursalFormScreen.routeName);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
