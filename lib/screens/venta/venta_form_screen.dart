import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectofinal/models/cliente.dart';
import 'package:proyectofinal/models/detalle_venta.dart';
import 'package:proyectofinal/models/metodo_pago.dart';
import 'package:proyectofinal/models/producto.dart';
import 'package:proyectofinal/models/sucursal.dart';
import 'package:proyectofinal/models/venta.dart';
import 'package:proyectofinal/viewmodels/cliente_viewmodel.dart';
import 'package:proyectofinal/viewmodels/producto_viewmodel.dart';
import 'package:proyectofinal/viewmodels/sucursal_viewmodel.dart';
import 'package:proyectofinal/viewmodels/usuario_viewmodel.dart';
import 'package:proyectofinal/viewmodels/venta_viewmodel.dart';
import 'package:proyectofinal/widgets/comun/boton_guardar.dart';
import 'package:proyectofinal/widgets/metodo_pago/metodo_pago_selector.dart';
import 'package:proyectofinal/widgets/venta/agregar_producto_widget.dart';
import 'package:proyectofinal/widgets/venta/lista_detalle_productos_widget.dart';
import 'package:proyectofinal/widgets/venta/totales_widget.dart';

class VentaFormScreen extends StatefulWidget {
  static const String routeName = '/venta_form';
  const VentaFormScreen({super.key});

  @override
  State<VentaFormScreen> createState() => _VentaFormScreenState();
}

class _VentaFormScreenState extends State<VentaFormScreen> {
  Cliente? clienteSeleccionado;
  Sucursal? sucursalSeleccionada;
  Producto? productoSeleccionado;
  MetodoPago? metodoPagoSeleccionado;
  final TextEditingController cantidadController = TextEditingController();
  final List<DetalleVenta> detalles = [];
  bool _guardandoVenta = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  @override
  void dispose() {
    cantidadController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    await Provider.of<ClienteViewModel>(context, listen: false).cargarClientes();
    await Provider.of<SucursalViewModel>(context, listen: false).cargarSucursales();
    await Provider.of<ProductoViewModel>(context, listen: false).cargarProductosConInventario();
  }

  void _agregarProducto(Producto producto, int cantidad) {
    final index = detalles.indexWhere(
      (d) => d.idProducto == producto.idProducto,
    );
    if (index >= 0) {
      detalles[index] = detalles[index].copyWith(
        cantidad: detalles[index].cantidad + cantidad,
      );
    } else {
      detalles.add(
        DetalleVenta(
          idProducto: producto.idProducto!,
          cantidad: cantidad,
          precioUnitario: producto.precio!, // Suponiendo que existe este campo
          producto: producto,
        ),
      );
    }
    setState(() {});
  }

  void _eliminarProducto(int index) {
    setState(() {
      detalles.removeAt(index);
    });
  }

  double _calcularTotal() {
    return detalles.fold(0.0, (total, d) => total + d.precioUnitario * d.cantidad);
  }

  int _calcularCantidadTotal() {
    return detalles.fold(0, (sum, d) => sum + d.cantidad);
  }

  void _guardarVenta() async {
    if (clienteSeleccionado == null ||
        sucursalSeleccionada == null ||
        metodoPagoSeleccionado == null ||
        detalles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos.')),
      );
      return;
    }

    final inventario =
        await Provider.of<ProductoViewModel>(
          context,
          listen: false,
        ).obtenerReporteInventario();
    for (var detalle in detalles) {
      final producto = inventario.firstWhere(
        (p) =>
            p.idProducto == detalle.idProducto &&
            p.idSucursal == sucursalSeleccionada!.idSucursal,
        orElse: () => throw Exception('Producto no encontrado'),
      );
      if (producto.cantidadDisponible < detalle.cantidad) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No hay suficiente stock para ${producto.producto}'),
          ),
        );
        return;
      }
    }

    setState(() {
      _guardandoVenta = true;
    });

    final usuarioViewModel = Provider.of<UsuarioViewModel>(context, listen: false);

    final venta = Venta(
      idCliente: clienteSeleccionado!.idCliente!,
      idSucursal: sucursalSeleccionada!.idSucursal!,
      idMetodoPago: metodoPagoSeleccionado!.idMetodoPago!,
      idUsuario: usuarioViewModel.usuario!.idUsuario!,
      total: _calcularTotal(),
      fecha: DateTime.now(),
      usuario: usuarioViewModel.usuario,
    );

    await Provider.of<VentaViewModel>(
      context,
      listen: false,
    ).registrarVenta(venta, detalles);

    if (mounted) {
      setState(() {
        _guardandoVenta = false;
      });
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final clienteVM = Provider.of<ClienteViewModel>(context);
    final sucursalVM = Provider.of<SucursalViewModel>(context);
    final productoVM = Provider.of<ProductoViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Venta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<Cliente>(
              decoration: const InputDecoration(labelText: 'Cliente'),
              value: clienteSeleccionado,
              items:
                  clienteVM.clientes
                      .map(
                        (cliente) => DropdownMenuItem(
                          value: cliente,
                          child: Text(cliente.nombre),
                        ),
                      )
                      .toList(),
              onChanged:
                  (cliente) => setState(() => clienteSeleccionado = cliente),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Sucursal>(
              decoration: const InputDecoration(labelText: 'Sucursal'),
              value: sucursalSeleccionada,
              items:
                  sucursalVM.sucursales
                      .map(
                        (sucursal) => DropdownMenuItem(
                          value: sucursal,
                          child: Text(sucursal.nombre),
                        ),
                      )
                      .toList(),
              onChanged:
                  (sucursal) => setState(() => sucursalSeleccionada = sucursal),
            ),
            const SizedBox(height: 8),

            /// Agregar producto
            AgregarProductoWidget(
              productos: productoVM.productos,
              onAgregar: _agregarProducto,
            ),

            const Divider(),

            ListaDetalleProductosWidget(
              detalles: detalles,
              onEliminar: _eliminarProducto,
            ),

            const SizedBox(height: 16),

            /// Metodo de pago
            MetodoPagoSelector(
              metodoPagoSeleccionado: metodoPagoSeleccionado,
              onMetodoSeleccionado: (metodo) {
                setState(() {
                  metodoPagoSeleccionado = metodo;
                });
              },
            ),
            const SizedBox(height: 16),
            TotalesWidget(
              totalProductos: _calcularCantidadTotal(),
              totalPagar: _calcularTotal(),
            ),
            const SizedBox(height: 16),
            BotonGuardar(
              isLoading: _guardandoVenta,
              texto: 'Crear Venta',
              onPressed: _guardarVenta,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
