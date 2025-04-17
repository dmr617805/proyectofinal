import 'package:flutter/material.dart';
import 'package:proyectofinal/models/detalle_venta.dart';

class ListaDetalleProductosWidget extends StatelessWidget {
  final List<DetalleVenta> detalles;
  final void Function(int index) onEliminar;

  const ListaDetalleProductosWidget({
    super.key,
    required this.detalles,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child:
            detalles.isEmpty
                ? const Center(child: Text('No se han agregado productos.'))
                : Scrollbar(
                  thumbVisibility: true,
                  child: ListView.builder(
                    itemCount: detalles.length,
                    itemBuilder: (context, index) {
                      final item = detalles[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(item.producto!.nombre),
                          subtitle: Text(
                            'Cantidad: ${item.cantidad} | Subtotal: \$${(item.precioUnitario * item.cantidad).toStringAsFixed(2)}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => onEliminar(index),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      ),
    );
  }
}
