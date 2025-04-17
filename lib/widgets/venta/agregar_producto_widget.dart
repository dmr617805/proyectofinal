import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyectofinal/models/producto.dart';

class AgregarProductoWidget extends StatefulWidget {
 final List<Producto> productos;
  final void Function(Producto producto, int cantidad) onAgregar;

  const AgregarProductoWidget({
    super.key,
    required this.productos,
    required this.onAgregar,
  });

  @override
  State<AgregarProductoWidget> createState() => _AgregarProductoWidgetState();
}

class _AgregarProductoWidgetState extends State<AgregarProductoWidget> {

  Producto? productoSeleccionado;
  final TextEditingController cantidadController = TextEditingController();

  @override
  void dispose() {
    cantidadController.dispose();
    super.dispose();
  }

 void _agregar() {
    final cantidad = int.tryParse(cantidadController.text);
    if (productoSeleccionado != null && cantidad != null && cantidad > 0) {
      widget.onAgregar(productoSeleccionado!, cantidad);
      cantidadController.clear();
      setState(() {
        productoSeleccionado = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Agregar producto',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 4,
              child: DropdownButtonFormField<Producto>(
                decoration: const InputDecoration(
                  labelText: 'Producto',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                value: productoSeleccionado,
                items: widget.productos
                    .map((producto) => DropdownMenuItem(
                          value: producto,
                          child: Text('${producto.nombre} (\$${producto.precio})'),
                        ))
                    .toList(),
                onChanged: (producto) => setState(() {
                  productoSeleccionado = producto;
                }),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: TextField(
                controller: cantidadController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cant.',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.green),
              iconSize: 32,
              onPressed: _agregar,
              tooltip: 'Agregar producto',
            ),
          ],
        ),
      ],
    );
  }
}