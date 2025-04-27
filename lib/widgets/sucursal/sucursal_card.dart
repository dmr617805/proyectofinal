import 'package:flutter/material.dart';
import 'package:proyectofinal/models/sucursal.dart';

class SucursalCard extends StatelessWidget {
  final Sucursal sucursal;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const SucursalCard({
    super.key,
    required this.sucursal,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(Icons.store, color: Theme.of(context).primaryColor),
        title: Text(
          sucursal.nombre,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(sucursal.ubicacion),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blueAccent),
              onPressed: onEditar,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.redAccent),
              onPressed: onEliminar,
            ),
          ],
        ),
      ),
    );
  }
}
