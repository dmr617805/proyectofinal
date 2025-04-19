import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:proyectofinal/screens/producto/producto_form_screen.dart';
import 'package:proyectofinal/viewmodels/producto_viewmodel.dart';
import 'package:proyectofinal/widgets/producto_card.dart';

class ProductoScreen extends StatefulWidget {
  static const String routeName = '/productos';
  const ProductoScreen({super.key});

  @override
  State<ProductoScreen> createState() => _ProductoScreenState();
}

class _ProductoScreenState extends State<ProductoScreen> {

  late ProductoViewModel viewModel;


  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {

    viewModel = Provider.of<ProductoViewModel>(context, listen: false);
    await viewModel.cargarProductosConInventario();
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body: Consumer<ProductoViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.productos.isEmpty) {
            return const Center(child: Text('No hay productos'));
          }
          return ListView.builder(
            itemCount: viewModel.productos.length,
            itemBuilder: (context, index) {
              final producto = viewModel.productos[index];
              return ProductoCard(
                producto: producto,
                onEdit: () {
                  Navigator.of(context).pushNamed(
                    ProductoFormScreen.routeName,
                    arguments: producto,
                  );
                },
                onDelete: () {
                  viewModel.eliminar(producto.idProducto!);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(ProductoFormScreen.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}