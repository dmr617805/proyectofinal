import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectofinal/models/reporte_inventario.dart';
import 'package:proyectofinal/models/sucursal.dart';
import 'package:proyectofinal/viewmodels/producto_viewmodel.dart';
import 'package:proyectofinal/viewmodels/sucursal_viewmodel.dart';
import 'package:proyectofinal/widgets/comun/screen_appbar.dart';
import 'package:proyectofinal/widgets/reporte_inventario/reporte_inventario_card.dart';

class ReporteInventarioScreen extends StatefulWidget {
  static const String routeName = '/reporte-inventario';

  const ReporteInventarioScreen({super.key});

  @override
  State<ReporteInventarioScreen> createState() =>
      _ReporteInventarioScreenState();
}

class _ReporteInventarioScreenState extends State<ReporteInventarioScreen> {
  late Future<List<ReporteInventario>> _reporteFuture;
  late ProductoViewModel viewModel;
  late SucursalViewModel sucursalViewModel;
  List<ReporteInventario> _todosLosReportes = [];
  Sucursal? _sucursalSeleccionada;

  @override
  void initState() {
    super.initState();
    _loadData();
    _reporteFuture = _cargarReporte();
  }

  Future<List<ReporteInventario>> _cargarReporte() async {
    final viewModel = ProductoViewModel();
    final reportes = await viewModel.obtenerReporteInventario();
    _todosLosReportes = reportes;
    return reportes;
  }

  Future<void> _loadData() async {
    sucursalViewModel = Provider.of<SucursalViewModel>(context, listen: false);
    await sucursalViewModel.cargarSucursales();
  }

  List<ReporteInventario> _filtrarPorSucursal(
    List<ReporteInventario> reportes,
  ) {
    if (_sucursalSeleccionada == null) return reportes;
    return reportes
        .where((r) => r.sucursal == _sucursalSeleccionada?.nombre)
        .toList();
  }

  void _limpiarFiltro() {
    setState(() {
      _sucursalSeleccionada = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScreenAppbar(title: 'Reporte de Inventario'),
      body: FutureBuilder<List<ReporteInventario>>(
        future: _reporteFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay datos de inventario'));
          }

          final sucursales = sucursalViewModel.sucursales;
          final reportesFiltrados = _filtrarPorSucursal(_todosLosReportes);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<Sucursal>(
                        decoration: const InputDecoration(
                          labelText: 'Sucursal',
                        ),
                        value: _sucursalSeleccionada,
                        isExpanded: true,
                        items:
                            sucursales
                                .map(
                                  (sucursal) => DropdownMenuItem(
                                    value: sucursal,
                                    child: Text(sucursal.nombre),
                                  ),
                                )
                                .toList(),
                        onChanged: (sucursal) {
                          setState(() {
                            _sucursalSeleccionada = sucursal;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      tooltip: 'Borrar filtro',
                      onPressed:
                          _sucursalSeleccionada == null ? null : _limpiarFiltro,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: reportesFiltrados.length,
                  itemBuilder: (context, index) {
                    final reporte = reportesFiltrados[index];
                    return ReporteInventarioCard(reporte: reporte);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
