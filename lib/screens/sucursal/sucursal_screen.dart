import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectofinal/screens/sucursal/sucursal_form_screen.dart';
import 'package:proyectofinal/viewmodels/sucursal_viewmodel.dart';
import 'package:proyectofinal/widgets/comun/screen_appbar.dart';
import 'package:proyectofinal/widgets/sucursal/sucursal_card.dart';

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

 void _eliminar(BuildContext context, int idSucursal, String nombreSucursal, SucursalViewModel vm) async {
    final confirmacion = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar sucursal?'),
        content: Text('¿Estás seguro que deseas eliminar la sucursal $nombreSucursal ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),                        
            child: const Text('Eliminar', style: TextStyle(fontWeight: FontWeight.w800),),
          ),
        ],
      ),
    );

    if (confirmacion == true) {
      vm.eliminar(idSucursal);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sucursal eliminada correctamente.', style: TextStyle(color: Colors.black ),),
          backgroundColor: Color.fromARGB(255, 117, 177, 119),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      appBar: ScreenAppbar(title: 'Sucursales'),
      body: Consumer<SucursalViewModel>(
        builder: (context, vm, child) {
          if (vm.sucursales.isEmpty) {
            return const Center(child: Text('No hay sucursales registradas.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),));
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
                   _eliminar(context, sucursal.idSucursal!, sucursal.nombre, vm);
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
