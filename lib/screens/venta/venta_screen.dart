import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectofinal/models/filtro_venta.dart';
import 'package:proyectofinal/models/sucursal.dart';
import 'package:proyectofinal/screens/venta/venta_form_screen.dart';
import 'package:proyectofinal/viewmodels/sucursal_viewmodel.dart';
import 'package:proyectofinal/viewmodels/usuario_viewmodel.dart';
import 'package:proyectofinal/viewmodels/venta_viewmodel.dart';
import 'package:proyectofinal/widgets/venta/filtro_ventas_dialog.dart';
import 'package:proyectofinal/widgets/venta/venta_card.dart';

class VentaScreen extends StatefulWidget {
  const VentaScreen({super.key});

  @override
  State<VentaScreen> createState() => _VentaScreenState();
}

class _VentaScreenState extends State<VentaScreen> {
  late VentaViewModel viewModel;
  late SucursalViewModel sucursalViewModel;
  String titulo = 'Mis Ventas';
  bool hayFiltrosActivos = false;

  DateTime? fechaSeleccionada;
  Sucursal? sucursalSeleccionada;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final usuarioViewModel = Provider.of<UsuarioViewModel>(
      context,
      listen: false,
    );
    viewModel = Provider.of<VentaViewModel>(context, listen: false);

    sucursalViewModel = Provider.of<SucursalViewModel>(context, listen: false);
    await sucursalViewModel.cargarSucursales(); // Cargar sucursales al iniciar

    if (usuarioViewModel.usuario!.esAdmin) {
      setState(() {
        titulo = 'Ventas Realizadas';
      });
    }

    await viewModel.cargarVentas(usuario: usuarioViewModel.usuario!);
    setState(() {}); // Para forzar rebuild luego de cargar
  }

  void _filtrarVentas() {
    final FiltroVenta filtro = FiltroVenta(
      fecha: fechaSeleccionada,
      idSucursal: sucursalSeleccionada?.idSucursal,
    );
    viewModel.filtrarVentas(filtro: filtro);

    setState(() {
      hayFiltrosActivos =
          fechaSeleccionada != null || sucursalSeleccionada != null;
    });
  }

  Widget _buildFiltros() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton.icon(
          icon: Icon(
            Icons.filter_alt_outlined,
            color:
                hayFiltrosActivos
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.primary,
          ),
          label: Text(
            'Filtros',
            style: TextStyle(
              color:
                  hayFiltrosActivos
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.primary,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                hayFiltrosActivos
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: _mostrarDialogoFiltros,
        ),
      ),
    );
  }

  void _mostrarDialogoFiltros() {
    showDialog(
      context: context,
      builder:
          (context) => FiltroVentasDialog(
            fechaInicial: fechaSeleccionada,
            sucursalInicial: sucursalSeleccionada,
            sucursales: sucursalViewModel.sucursales,
            onAplicar: (fecha, sucursal) {
              setState(() {
                fechaSeleccionada = fecha;
                sucursalSeleccionada = sucursal;
              });
              _filtrarVentas();
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(              
      appBar: AppBar(title: Text(titulo, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),)),
      body: Consumer<VentaViewModel>(
        builder: (context, vm, child) {
          return Column(
            children: [
              _buildFiltros(),
              Expanded(
                child:
                    vm.ventasFiltradas.isEmpty
                        ? const Center(
                          child: Text('No hay ventas registradas.'),
                        )
                        : RefreshIndicator(
                          onRefresh: _loadData,
                          child: ListView.builder(
                            itemCount: vm.ventasFiltradas.length,
                            itemBuilder: (context, index) {
                              final venta = vm.ventasFiltradas[index];
                              return VentaCard(venta: venta);
                            },
                          ),
                        ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(VentaFormScreen.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
