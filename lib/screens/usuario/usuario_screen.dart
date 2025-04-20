import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectofinal/screens/usuario/usuario_form_screen.dart';
import 'package:proyectofinal/viewmodels/usuario_viewmodel.dart';
import 'package:proyectofinal/widgets/comun/screen_appbar.dart';
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


     void _eliminar(BuildContext context, int idUsuario, String nombreUsuario, UsuarioViewModel vm) async {
    final confirmacion = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar usuario?'),
        content: Text('¿Estás seguro que deseas eliminar el usuario $nombreUsuario ?'),
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
      vm.eliminar(idUsuario);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario eliminado correctamente.', style: TextStyle(color: Colors.black ),),
          backgroundColor: Color.fromARGB(255, 117, 177, 119),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      appBar: ScreenAppbar(title: 'Usuarios'),
      body: Consumer<UsuarioViewModel>(
        builder: (context, vm, child) {
          if (vm.usuarios.isEmpty) {            
            return const Center(child: Text('No hay usuarios registrados.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),));
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
                  _eliminar(context, usuario.idUsuario!, usuario.correo, viewModel);
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
