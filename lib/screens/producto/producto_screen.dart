import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:proyectofinal/screens/producto/producto_form_screen.dart';
import 'package:proyectofinal/viewmodels/producto_viewmodel.dart';
import 'package:proyectofinal/widgets/comun/screen_appbar.dart';
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


  
   void _eliminar(BuildContext context, int idProducto, String nombreProducto, ProductoViewModel vm) async {
    final confirmacion = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar producto?'),
        content: Text('¿Estás seguro que deseas eliminar el producto $nombreProducto ?'),
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
      vm.eliminar(idProducto);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Producto eliminado correctamente.', style: TextStyle(color: Colors.black ),),
          backgroundColor: Color.fromARGB(255, 117, 177, 119),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(      
      appBar: ScreenAppbar(title: 'Productos'),
      body: Consumer<ProductoViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.productos.isEmpty) {            
            return const Center(child: Text('No hay productos registrados.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),));
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
                  _eliminar(context, producto.idProducto!, producto.nombre, viewModel);
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