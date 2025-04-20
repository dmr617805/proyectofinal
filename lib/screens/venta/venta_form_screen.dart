import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectofinal/models/cliente.dart';
import 'package:proyectofinal/models/detalle_venta.dart';
import 'package:proyectofinal/models/metodo_pago.dart';
import 'package:proyectofinal/models/producto.dart';
import 'package:proyectofinal/models/reporte_inventario.dart';
import 'package:proyectofinal/models/sucursal.dart';
import 'package:proyectofinal/models/venta.dart';
import 'package:proyectofinal/viewmodels/cliente_viewmodel.dart';
import 'package:proyectofinal/viewmodels/producto_viewmodel.dart';
import 'package:proyectofinal/viewmodels/sucursal_viewmodel.dart';
import 'package:proyectofinal/viewmodels/usuario_viewmodel.dart';
import 'package:proyectofinal/viewmodels/venta_viewmodel.dart';
import 'package:proyectofinal/widgets/comun/boton_guardar.dart';
import 'package:proyectofinal/widgets/comun/screen_appbar.dart';
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
    if (!_validarFormulario()) return;

    try {
      setState(() => _guardandoVenta = true);

      final inventario = await Provider.of<ProductoViewModel>(context,listen: false,).obtenerReporteInventario();
      if (!_verificarStock(inventario)) return;

      final venta = _construirVenta();

      final ventaViewModel = Provider.of<VentaViewModel>(context,listen: false,);
      await ventaViewModel.registrarVenta(venta, detalles);

      if (!mounted) return;

      _mostrarSnackBar('Pago registrado exitosamente', 'exitoso');

      await Future.delayed(const Duration(seconds: 2));
      Navigator.pop(context);

    } catch (e) {
      _mostrarSnackBar('Ocurrió un error: ${e.toString()}', 'error');
    } finally {
      if (mounted) {
        setState(() => _guardandoVenta = false);
      }
    }
  }

  void _mostrarSnackBar(String mensaje, String  tipo) {
    if (!mounted) return;

    Color colorDeFondo = Colors.blue;
    switch (tipo) {
      case 'error':
        colorDeFondo = const Color.fromARGB(255, 231, 119, 111);
        break;
      case 'advertencia':
        colorDeFondo = const Color.fromARGB(255, 241, 228, 155);
        break;
      case 'exitoso':
        colorDeFondo = const Color.fromARGB(255, 111, 240, 115);
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje, style: TextStyle(color:  Colors.black, fontSize: 14),),
        backgroundColor: colorDeFondo,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  bool _validarFormulario() {
    if (clienteSeleccionado == null) {
      _mostrarSnackBar('Seleccione un cliente', 'advertencia');
      return false;
    }
    if (sucursalSeleccionada == null) {
      _mostrarSnackBar('Seleccione una sucursal','advertencia');
      return false;
    }
    if (detalles.isEmpty) {
      _mostrarSnackBar('Agregue al menos un producto', 'advertencia');
      return false;
    }
    if (metodoPagoSeleccionado == null) {
      _mostrarSnackBar('Seleccione un método de pago', 'advertencia');
      return false;
    }
    return true;
  }


  bool _verificarStock(List<ReporteInventario> inventario) {
    for (var detalle in detalles) {
      final producto = inventario.firstWhere(
        (p) =>
            p.idProducto == detalle.idProducto &&
            p.idSucursal == sucursalSeleccionada!.idSucursal,
        orElse: () => throw Exception('Producto no encontrado'),
      );

      if (producto.cantidadDisponible < detalle.cantidad) {
        _mostrarSnackBar('No hay suficiente stock para ${producto.producto}', 'advertencia');
        return false;
      }
    }
    return true;
  }

  Venta _construirVenta() {
    final usuarioViewModel = Provider.of<UsuarioViewModel>(context,listen: false,);

    return Venta(
      idCliente: clienteSeleccionado!.idCliente!,
      idSucursal: sucursalSeleccionada!.idSucursal!,
      idMetodoPago: metodoPagoSeleccionado!.idMetodoPago!,
      idUsuario: usuarioViewModel.usuario!.idUsuario!,
      total: _calcularTotal(),
      fecha: DateTime.now(),
      usuario: usuarioViewModel.usuario,
    );
  }

  @override
  Widget build(BuildContext context) {
    final clienteVM = Provider.of<ClienteViewModel>(context);
    final sucursalVM = Provider.of<SucursalViewModel>(context);
    final productoVM = Provider.of<ProductoViewModel>(context);

    return Scaffold(
      appBar: ScreenAppbar(title: 'Registrar Venta'),
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
