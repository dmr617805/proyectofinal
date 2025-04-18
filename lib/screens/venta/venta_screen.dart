import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectofinal/models/filtro_venta.dart';
import 'package:proyectofinal/models/sucursal.dart';
import 'package:proyectofinal/screens/venta/venta_form_screen.dart';
import 'package:proyectofinal/viewmodels/sucursal_viewmodel.dart';
import 'package:proyectofinal/viewmodels/usuario_viewmodel.dart';
import 'package:proyectofinal/viewmodels/venta_viewmodel.dart';
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
      hayFiltrosActivos = fechaSeleccionada != null || sucursalSeleccionada != null;
    });
  }

Widget _buildFiltros() {

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: ElevatedButton.icon(
        icon: Icon(
          Icons.filter_alt_outlined,
          color: hayFiltrosActivos
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.primary,
        ),
        label: Text(
          'Filtros',
          style: TextStyle(
            color: hayFiltrosActivos
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.primary,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: hayFiltrosActivos
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _mostrarBottomSheetFiltros,
      ),
    ),
  );
}

  void _mostrarBottomSheetFiltros() {

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: 36,
          ),
          child: Wrap(
            runSpacing: 24,
            children: [
              Text(
                'Filtrar ventas',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Divider(thickness: 1, color: Theme.of(context).dividerColor),
              FilledButton.icon(
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
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: Theme.of(context).colorScheme.copyWith(
                            primary: Theme.of(context).colorScheme.primary,
                            onPrimary: Theme.of(context).colorScheme.onPrimary,
                            surface: Theme.of(context).colorScheme.surface,
                            onSurface: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() {
                      fechaSeleccionada = picked;
                    });
                  }
                },
              ),
              DropdownButtonFormField<Sucursal>(
                decoration: const InputDecoration(labelText: 'Sucursal'),
                value: sucursalSeleccionada,
                isExpanded: true,
                items:
                    sucursalViewModel.sucursales
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
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        _filtrarVentas();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Aplicar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        setState(() {
                          fechaSeleccionada = null;
                          sucursalSeleccionada = null;
                        });
                        _filtrarVentas();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.clear),
                      label: const Text('Limpiar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
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
