import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectofinal/screens/cliente/cliente_form_screen.dart';
import 'package:proyectofinal/viewmodels/cliente_viewmodel.dart';
import 'package:proyectofinal/widgets/cliente/cliente_card.dart';
import 'package:proyectofinal/widgets/comun/screen_appbar.dart';

class ClienteScreen extends StatefulWidget {
  static const String routeName = '/clientes';
  const ClienteScreen({super.key});

  @override
  State<ClienteScreen> createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  late ClienteViewModel viewModel;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Inicializamos el viewModel y cargamos los clientes cuando el widget se cree.
    viewModel = Provider.of<ClienteViewModel>(context, listen: false);
    await viewModel.cargarClientes();
  }


   void _eliminar(BuildContext context, int idCliente, String nombreCliente, ClienteViewModel vm) async {
    final confirmacion = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar cliente?'),
        content: Text('¿Estás seguro que deseas eliminar el cliente $nombreCliente ?'),
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
      vm.eliminar(idCliente);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cliente eliminado correctamente.', style: TextStyle(color: Colors.black ),),
          backgroundColor: Color.fromARGB(255, 117, 177, 119),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScreenAppbar(
        title: 'Clientes',        
      ),   
      body: Consumer<ClienteViewModel>(
        builder: (context, viewModel, child) {
          // Verificamos el estado de la conexión con la base de datos.
          if (viewModel.clientes.isEmpty) {            
            return const Center(child: Text('No hay clientes registrados.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),));
          }

          return ListView.builder(
            itemCount: viewModel.clientes.length,
            itemBuilder: (context, index) {
              final cliente = viewModel.clientes[index];
              return ClienteCard(
                cliente: cliente,
                onEdit: () {
                  Navigator.of(
                    context,
                  ).pushNamed(ClienteFormScreen.routeName, arguments: cliente);
                },
                onDelete: () {                  
                   _eliminar(context, cliente.idCliente!, cliente.nombre, viewModel);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(ClienteFormScreen.routeName);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
