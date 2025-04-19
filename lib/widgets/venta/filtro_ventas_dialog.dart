import 'package:flutter/material.dart';
import 'package:proyectofinal/models/sucursal.dart';

class FiltroVentasDialog extends StatefulWidget {
  final DateTime? fechaInicial;
  final Sucursal? sucursalInicial;
  final List<Sucursal> sucursales;
  final Function(DateTime?, Sucursal?) onAplicar;

  const FiltroVentasDialog({
    super.key,
    required this.fechaInicial,
    required this.sucursalInicial,
    required this.sucursales,
    required this.onAplicar,
  });

  @override
  State<FiltroVentasDialog> createState() => _FiltroVentasDialogState();
}

class _FiltroVentasDialogState extends State<FiltroVentasDialog> {
  DateTime? fechaSeleccionada;
  Sucursal? sucursalSeleccionada;

  @override
  void initState() {
    super.initState();
    fechaSeleccionada = widget.fechaInicial;
    sucursalSeleccionada = widget.sucursalInicial;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Filtrar ventas',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.icon(
                icon: const Icon(Icons.date_range),
                label: Text(
                  fechaSeleccionada != null
                      ? '${fechaSeleccionada!.day}/${fechaSeleccionada!.month}/${fechaSeleccionada!.year}'
                      : 'Seleccionar fecha',
                ),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: fechaSeleccionada ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      fechaSeleccionada = picked;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Sucursal>(
              decoration: const InputDecoration(labelText: 'Sucursal'),
              value: sucursalSeleccionada,
              isExpanded: true,
              items:
                  widget.sucursales
                      .map(
                        (sucursal) => DropdownMenuItem(
                          value: sucursal,
                          child: Text(sucursal.nombre),
                        ),
                      )
                      .toList(),
              onChanged: (sucursal) {
                setState(() {
                  sucursalSeleccionada = sucursal;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Limpiar
            setState(() {
              fechaSeleccionada = null;
              sucursalSeleccionada = null;
            });
            widget.onAplicar(null, null);
            Navigator.of(context).pop();
          },
          child: const Text('Limpiar'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onAplicar(fechaSeleccionada, sucursalSeleccionada);
            Navigator.of(context).pop();
          },
          child: const Text('Aplicar'),
        ),
      ],
    );
  }
}
