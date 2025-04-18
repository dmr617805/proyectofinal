import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectofinal/screens/usuario/usuario_form_screen.dart';
import 'package:proyectofinal/viewmodels/usuario_viewmodel.dart';
import 'package:proyectofinal/widgets/usuario/usuario_card.dart';


class UsuarioScreen extends StatefulWidget {
  static const String routeName = '/usuarios';

  const UsuarioScreen({super.key});

  @override
  State<UsuarioScreen> createState() => _UsuarioScreenState();
}

class _UsuarioScreenState extends State<UsuarioScreen> {
  late UsuarioViewModel viewModel;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    viewModel = Provider.of<UsuarioViewModel>(context, listen: false);
    await viewModel.cargarUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios')),
      body: Consumer<UsuarioViewModel>(
        builder: (context, vm, child) {
          if (vm.usuarios.isEmpty) {
            return const Center(child: Text('No hay usuarios registrados.'));
          }

          return ListView.builder(
            itemCount: vm.usuarios.length,
            itemBuilder: (context, index) {
              final usuario = vm.usuarios[index];
              return UsuarioCard(
                usuario: usuario,
                onEditar: () {
                  Navigator.of(context).pushNamed(
                    UsuarioFormScreen.routeName,
                    arguments: usuario,
                  );
                },
                onEliminar: () {
                  vm.eliminar(usuario.idUsuario!);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(UsuarioFormScreen.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
