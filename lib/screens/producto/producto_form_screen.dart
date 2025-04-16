import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectofinal/models/inventario.dart';
import 'package:proyectofinal/models/producto.dart';
import 'package:proyectofinal/models/sucursal.dart';
import 'package:proyectofinal/viewmodels/producto_viewmodel.dart';
import 'package:proyectofinal/viewmodels/sucursal_viewmodel.dart';

class ProductoFormScreen extends StatefulWidget {
  static const String routeName = '/producto_form';
  final Producto? producto;
  const ProductoFormScreen({super.key, this.producto});

  @override
  State<ProductoFormScreen> createState() => _ProductoFormScreenState();
}

class _ProductoFormScreenState extends State<ProductoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _precioController;
  bool _isLoading = true;
  final List<InventarioEntry> _inventarioControllers = [];

  @override
  void initState() {
    super.initState();
   _loadData();
  }

  Future<void> _loadData() async {
   final producto = widget.producto;
    _nombreController = TextEditingController(text: producto?.nombre ?? '');
    _descripcionController = TextEditingController(text: producto?.descripcion ?? '');
    _precioController = TextEditingController(text: producto?.precio?.toString() ?? '');

    final sucursalVM = Provider.of<SucursalViewModel>(context, listen: false);
    await sucursalVM.cargarSucursales(); // Cargar sucursales al iniciar

    for (var sucursal in sucursalVM.sucursales) {
      // Buscar si el producto ya tiene inventario registrado para esa sucursal
      final inventarioExistente = producto?.inventario.firstWhere(
        (inv) => inv.idSucursal == sucursal.idSucursal,
        orElse: () => Inventario(idSucursal: sucursal.idSucursal!, idProducto: 0, cantidadDisponible: 0),
      );

      final cantidad = inventarioExistente?.cantidadDisponible ?? 0;
      _inventarioControllers.add(InventarioEntry(
        sucursal: sucursal,
        controller: TextEditingController(text: cantidad.toString()),
      ));
    }

    setState(() {
      _isLoading = false;
    });

  }

  void _guardar() async {
    if (_formKey.currentState?.validate() ?? false) {

      final inventarioList = _inventarioControllers.map((entry) {
          return Inventario(
            idSucursal: entry.sucursal.idSucursal!,
            idProducto: widget.producto?.idProducto ?? 0, // Si es nuevo, asigna después del guardado
            cantidadDisponible: int.tryParse(entry.controller.text) ?? 0,
          );
      }).toList();

      final producto = Producto(
        idProducto: widget.producto?.idProducto,
        nombre: _nombreController.text,
        descripcion: _descripcionController.text,
        precio: double.tryParse(_precioController.text) ?? 0,
        isActive: true,
        inventario: inventarioList,
      );

      final productoVM = Provider.of<ProductoViewModel>(context, listen: false);
      await productoVM.guardar(producto);

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    for (var entry in _inventarioControllers) {
      entry.controller.dispose();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final esEdicion = widget.producto != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEdicion ? 'Editar Producto' : 'Nuevo Producto'),
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator:
                    (value) => value!.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              TextFormField(
                controller: _precioController,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator:
                    (value) => value!.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 16),
              const Text(
                'Inventario',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Column(
                children: _inventarioControllers.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: entry.controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Cantidad en ${entry.sucursal.nombre}'),
                      validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardar,
                child: Text(esEdicion ? 'Actualizar' : 'Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InventarioEntry {
  final Sucursal sucursal;
  final TextEditingController controller;

  InventarioEntry({
    required this.sucursal,
    required this.controller,
  });
}
