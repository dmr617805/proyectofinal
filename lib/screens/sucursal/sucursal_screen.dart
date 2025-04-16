import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectofinal/screens/sucursal/sucursal_form_screen.dart';
import 'package:proyectofinal/viewmodels/sucursal_viewmodel.dart';
import 'package:proyectofinal/widgets/sucursal_card.dart';

class SucursalScreen extends StatefulWidget {
  static const String routeName = '/sucursales';

  const SucursalScreen({super.key});

  @override
  State<SucursalScreen> createState() => _SucursalScreenState();
}

class _SucursalScreenState extends State<SucursalScreen> {
  late SucursalViewModel viewModel;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Cargar los datos necesarios para la pantalla de productos.
    viewModel = Provider.of<SucursalViewModel>(context, listen: false);
    await viewModel.cargarSucursales();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sucursales')),
      body: Consumer<SucursalViewModel>(
        builder: (context, vm, child) {
          if (vm.sucursales.isEmpty) {
            return const Center(child: Text('No hay sucursales registradas.'));
          }

          return ListView.builder(
            itemCount: vm.sucursales.length,
            itemBuilder: (context, index) {
              final sucursal = vm.sucursales[index];
              return SucursalCard(
                sucursal: sucursal,
                onEditar: () {
                  Navigator.of(context).pushNamed(
                    SucursalFormScreen.routeName,
                    arguments: sucursal,
                  );
                },
                onEliminar: () {
                  vm.eliminar(sucursal.idSucursal!);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(SucursalFormScreen.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
