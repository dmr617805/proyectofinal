import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectofinal/screens/cliente/cliente_form_screen.dart';
import 'package:proyectofinal/viewmodels/cliente_viewmodel.dart';
import 'package:proyectofinal/widgets/cliente_card.dart';
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
            return Center(child: Text('No hay clientes'));
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
                  viewModel.eliminar(cliente.idCliente!);
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
