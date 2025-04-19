import 'package:flutter/material.dart';
import 'package:proyectofinal/models/reporte_inventario.dart';

class ReporteInventarioCard extends StatelessWidget {
  final ReporteInventario reporte;

  const ReporteInventarioCard({super.key, required this.reporte});

  @override
  Widget build(BuildContext context) {
    final isBajoStock = reporte.cantidadDisponible <= reporte.cantidadMinima;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        onTap: () {},
        leading: Icon(
          Icons.inventory_2,
          color:
              isBajoStock ? Colors.redAccent : Theme.of(context).primaryColor,
        ),
        title: Text(
          reporte.producto,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sucursal: ${reporte.sucursal}'),
            Text('Disponible: ${reporte.cantidadDisponible}'),
            Text('Mínimo: ${reporte.cantidadMinima}'),
            Text('Precio: \$${reporte.precio.toStringAsFixed(2)}'),
            if (isBajoStock)
              const Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Text(
                  '¡Stock bajo!',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
