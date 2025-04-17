import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectofinal/models/cliente.dart';
import 'package:proyectofinal/models/detalle_venta.dart';
import 'package:proyectofinal/models/producto.dart';
import 'package:proyectofinal/models/sucursal.dart';
import 'package:proyectofinal/models/venta.dart';
import 'package:proyectofinal/viewmodels/cliente_viewmodel.dart';
import 'package:proyectofinal/viewmodels/producto_viewmodel.dart';
import 'package:proyectofinal/viewmodels/sucursal_viewmodel.dart';
import 'package:proyectofinal/viewmodels/venta_viewmodel.dart';
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
  String? formaPagoSeleccionada;
  Producto? productoSeleccionado;
  final TextEditingController cantidadController = TextEditingController();
  final List<DetalleVenta> detalles = [];


  final formasDePago = ['Efectivo', 'Tarjeta', 'Transferencia'];

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

  void agregarProducto(Producto producto, int cantidad) {
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

  void eliminarProducto(int index) {
  setState(() {
    detalles.removeAt(index);
  });
}

  double calcularTotal() {
    return detalles.fold(0.0, (total, d) => total + d.precioUnitario * d.cantidad);
  }

  int calcularCantidadTotal() {
    return detalles.fold(0, (sum, d) => sum + d.cantidad);
  }

  void guardarVenta() async {
    if (clienteSeleccionado == null ||
        sucursalSeleccionada == null ||
        formaPagoSeleccionada == null ||
        detalles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos.')),
      );
      return;
    }

    final venta = Venta(
      idCliente: clienteSeleccionado!.idCliente!,
      idSucursal: sucursalSeleccionada!.idSucursal!,
      idMetodoPago: 1,
      total: calcularTotal(),
      fecha: DateTime.now(),
    );

    await Provider.of<VentaViewModel>(
      context,
      listen: false,
    ).registrarVenta(venta, detalles);

    Navigator.pop(context);
  }

  @override
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
              items: clienteVM.clientes
                  .map((cliente) => DropdownMenuItem(
                        value: cliente,
                        child: Text(cliente.nombre),
                      ))
                  .toList(),
              onChanged: (cliente) => setState(() => clienteSeleccionado = cliente),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Sucursal>(
              decoration: const InputDecoration(labelText: 'Sucursal'),
              value: sucursalSeleccionada,
              items: sucursalVM.sucursales
                  .map((sucursal) => DropdownMenuItem(
                        value: sucursal,
                        child: Text(sucursal.nombre),
                      ))
                  .toList(),
              onChanged: (sucursal) => setState(() => sucursalSeleccionada = sucursal),
            ),
            const SizedBox(height: 8),

            /// Agregar producto
            AgregarProductoWidget(
              productos: productoVM.productos,
              onAgregar: agregarProducto,
            ),

            const Divider(),

            ListaDetalleProductosWidget(
              detalles: detalles,
              onEliminar: eliminarProducto,
            ),

            const SizedBox(height: 16),

            /// Forma de pago y resumen
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Forma de pago'),
              value: formaPagoSeleccionada,
              items: formasDePago
                  .map((fp) => DropdownMenuItem(value: fp, child: Text(fp)))
                  .toList(),
              onChanged: (fp) => setState(() => formaPagoSeleccionada = fp),
            ),
            const SizedBox(height: 16),
            TotalesWidget(
              totalProductos: calcularCantidadTotal(),
              totalPagar: calcularTotal(),
            ),            
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Guardar Venta'),
                onPressed: guardarVenta,
              ),
            ),
          ],
        ),
      ),

    );
  }
}
