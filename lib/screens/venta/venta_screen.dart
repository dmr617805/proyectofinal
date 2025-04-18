import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectofinal/screens/venta/venta_form_screen.dart';
import 'package:proyectofinal/viewmodels/usuario_viewmodel.dart';
import 'package:proyectofinal/viewmodels/venta_viewmodel.dart';
import 'package:proyectofinal/widgets/venta/venta_card.dart';

class VentaScreen extends StatefulWidget {
  const VentaScreen({super.key});

  @override
  State<VentaScreen> createState() => _VentaScreenState();
}

class _VentaScreenState extends State<VentaScreen> {
  late VentaViewModel viewModel;
  String titulo = 'Mis Ventas';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final usuarioViewModel = Provider.of<UsuarioViewModel>(
      context,
      listen: false,
    );


    if (usuarioViewModel.usuario!.esAdmin) {
      setState(() {
        titulo = 'Ventas Realizadas';
      });
    }

    viewModel = Provider.of<VentaViewModel>(context, listen: false);
    if (usuarioViewModel.usuario != null) {
      await viewModel.cargarVentas(usuario: usuarioViewModel.usuario!);
    } else {
      throw Exception('Usuario no puede ser nulo');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: Consumer<VentaViewModel>(
        builder: (context, vm, child) {
          if (vm.ventas.isEmpty) {
            return const Center(child: Text('No hay ventas registradas.'));
          }

          return RefreshIndicator(
            onRefresh: _loadData,
            child: ListView.builder(
              itemCount: vm.ventas.length,
              itemBuilder: (context, index) {
                final venta = vm.ventas[index];
                return VentaCard(venta: venta);
              },
            ),
          );
        },
      ),
       floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(VentaFormScreen.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
