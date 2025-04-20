import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:proyectofinal/models/reporte_venta.dart';
import 'package:proyectofinal/viewmodels/reporte_ventas_viewmodel.dart';
import 'package:proyectofinal/widgets/comun/screen_appbar.dart';
import 'package:proyectofinal/widgets/reporte_ventas/reporte_ventas_encabezado.dart';

class ReporteVentasScreen extends StatelessWidget {
  static const String routeName = '/reporte-ventas';
  const ReporteVentasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReporteVentasViewModel()..cargarReportes(),
      child: Scaffold(        
        appBar: ScreenAppbar(title: 'Reporte de Ventas'),
        body: Consumer<ReporteVentasViewModel>(
          builder: (context, vm, _) {
            return Column(
              children: [
                ReporteVentasEncabezado(vm: vm),
                Expanded(
                  child: ListView(
                    children: [
                      _buildPieChart('Ventas por Sucursal', vm.ventasSucursal),
                      _buildPieChart('Ventas por Usuario', vm.ventasUsuario),
                      _buildPieChart('Ventas por Producto', vm.ventasProducto),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPieChart(String titulo, List<ReporteVenta> data) {
    final total = data.fold(0.0, (sum, item) => sum + item.total);
    final List<Color> coloresPastel = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.indigo,
    ];

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              titulo,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (data.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('No hay datos en el rango seleccionado.'),
              )
            else
              SizedBox(
                height: 250,
                child: PieChart(
                  PieChartData(
                    sections:
                        data.asMap().entries.map((entry) {
                          final index = entry.key;
                          final reporte = entry.value;
                          final porcentaje =
                              total > 0
                                  ? (reporte.total / total * 100)
                                      .toStringAsFixed(1)
                                  : '0';
                          final color =
                              coloresPastel[index % coloresPastel.length];

                          return PieChartSectionData(
                            color: color,
                            value: reporte.total,
                            title: '$porcentaje%',
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          );
                        }).toList(),
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                  ),
                ),
              ),
            const SizedBox(height: 10),
            ...data.asMap().entries.map((entry) {
              final index = entry.key;
              final reporte = entry.value;
              final color = coloresPastel[index % coloresPastel.length];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${reporte.nombre}: \$${reporte.total.toStringAsFixed(2)}',
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}



