import 'package:flutter/material.dart';
import 'package:proyectofinal/models/cliente.dart';

class ClienteCard extends StatelessWidget {
  final Cliente cliente;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ClienteCard({super.key,  required this.cliente, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(cliente.nombre),
        subtitle: Text(cliente.correo),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}