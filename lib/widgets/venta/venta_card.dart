

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyectofinal/models/venta.dart';

class VentaCard extends StatelessWidget {
  final Venta venta;

  const VentaCard({super.key, required this.venta});

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM/yyyy HH:mm');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(Icons.receipt_long, color: Theme.of(context).primaryColor),
        title: Text(
          'Venta: \$${venta.total.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Fecha: ${formatter.format(venta.fecha)}'),
            Text('Cliente: ${venta.cliente?.nombre ?? "N/A"}'),
            Text('Sucursal: ${venta.sucursal?.nombre ?? "N/A"}'),
            Text('Vendedor: ${venta.usuario?.nombre} ${venta.usuario?.apellidoPaterno ?? ""}'),
          ],
        ),
      ),
    );
  }
}