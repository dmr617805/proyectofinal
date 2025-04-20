import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectofinal/viewmodels/metodo_pago_viewmodel.dart';
import 'package:proyectofinal/widgets/comun/screen_appbar.dart';
import 'package:proyectofinal/widgets/metodo_pago/metodo_pago_card.dart';

class MetodoPagoFormScreen extends StatefulWidget {
  static const String routeName = '/metodoPago_form';
  const MetodoPagoFormScreen({super.key});

  @override
  State<MetodoPagoFormScreen> createState() => _MetodoPagoFormScreenState();
}

class _MetodoPagoFormScreenState extends State<MetodoPagoFormScreen> {
  late MetodoPagoViewmodel viewModel;
  int? _idMetodoPagoSeleccionado;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    viewModel = Provider.of<MetodoPagoViewmodel>(context, listen: false);
    await viewModel.cargarMetodosPago();
  }

  void _onPress() {
    if (_idMetodoPagoSeleccionado != null) {
      final metodoSeleccionado = viewModel.metodosPago.firstWhere(
        (m) => m.idMetodoPago == _idMetodoPagoSeleccionado,
      );
      Navigator.pop(context, metodoSeleccionado);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un método de pago.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScreenAppbar(title: 'Método de Pago'),
      body: Consumer<MetodoPagoViewmodel>(
        builder: (context, vm, child) {
          if (vm.metodosPago.isEmpty) {
            return const Center(child: Text('No hay métodos de pago'));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListView.builder(
                    itemCount: vm.metodosPago.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final metodoPago = vm.metodosPago[index];
                      return MetodoPagoCard(
                        metodoPago: metodoPago,
                        isSelect:
                            _idMetodoPagoSeleccionado ==
                            metodoPago.idMetodoPago,
                        onTap: () {
                          setState(() {
                            _idMetodoPagoSeleccionado = metodoPago.idMetodoPago;
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: const Text('Seleccionar método de pago'),
                      onPressed: _onPress,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
