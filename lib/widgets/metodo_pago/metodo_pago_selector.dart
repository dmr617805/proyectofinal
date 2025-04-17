import 'package:flutter/material.dart';
import 'package:proyectofinal/models/metodo_pago.dart';
import 'package:proyectofinal/screens/metodo_pago/metodo_pago_form_screen.dart';

class MetodoPagoSelector extends StatelessWidget {
  final MetodoPago? metodoPagoSeleccionado;
  final ValueChanged<MetodoPago> onMetodoSeleccionado;

  const MetodoPagoSelector({
    super.key,
    required this.metodoPagoSeleccionado,
    required this.onMetodoSeleccionado,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Método de pago',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                metodoPagoSeleccionado != null
                    ? metodoPagoSeleccionado!.descripcion
                    : 'Pendiente',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:
                      metodoPagoSeleccionado != null
                          ? Colors.black
                          : Colors.grey,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: () async {
            final metodo = await Navigator.pushNamed(
              context,
              MetodoPagoFormScreen.routeName,
            );

            if (metodo != null && metodo is MetodoPago) {
              onMetodoSeleccionado(metodo);
            }
          },
          icon: const Icon(Icons.payment),
          label: Text(
            metodoPagoSeleccionado != null ? 'Cambiar' : 'Seleccionar',
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),            
          ),
        ),
      ],
    );
  }
}
