import 'package:flutter/material.dart';
import 'package:proyectofinal/viewmodels/reporte_ventas_viewmodel.dart';
import 'package:proyectofinal/widgets/comun/boton_fecha.dart';

class ReporteVentasEncabezado extends StatelessWidget {
  final ReporteVentasViewModel vm;

  const ReporteVentasEncabezado({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BotonFecha(
          label: 'Desde',
          date: vm.fechaInicio,
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: vm.fechaInicio,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              vm.setFechas(picked, vm.fechaFin);
            }
          },
        ),
        BotonFecha(
          label: 'Hasta',
          date: vm.fechaFin,
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: vm.fechaFin,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              vm.setFechas(vm.fechaInicio, picked);
            }
          },
        ),
      ],
    );
  }
}
