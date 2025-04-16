import 'package:flutter/material.dart';
import 'package:proyectofinal/models/producto.dart';

class ProductoCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductoCard({
    super.key,
    required this.producto,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(
          Icons.shopping_cart,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          producto.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (producto.descripcion != null &&
                producto.descripcion!.isNotEmpty)
              Text(producto.descripcion!),
            const SizedBox(height: 4),
            Text('Precio: \$${producto.precio?.toStringAsFixed(2) ?? '0.00'}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blueAccent),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
