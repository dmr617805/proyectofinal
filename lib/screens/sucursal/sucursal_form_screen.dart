import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectofinal/models/sucursal.dart';
import 'package:proyectofinal/viewmodels/sucursal_viewmodel.dart';
import 'package:proyectofinal/widgets/comun/boton_guardar.dart';
import 'package:proyectofinal/widgets/comun/screen_appbar.dart';

class SucursalFormScreen extends StatefulWidget {
  static const String routeName = '/sucursal_form';
  final Sucursal? sucursal;
  const SucursalFormScreen({super.key, this.sucursal});

  @override
  State<SucursalFormScreen> createState() => _SucursalFormScreenState();
}

class _SucursalFormScreenState extends State<SucursalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _ubicacionController;
  bool _guardandoSucursal = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.sucursal != null ? widget.sucursal!.nombre : '');
    _ubicacionController = TextEditingController(text: widget.sucursal != null ? widget.sucursal!.ubicacion : '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _ubicacionController.dispose();
    super.dispose();
  }

  void _guardarSucursal() async {
    if (_formKey.currentState!.validate()) {

      setState(() {
        _guardandoSucursal = true;
      });

      final sucursal = Sucursal(
        idSucursal: widget.sucursal?.idSucursal,
        nombre: _nombreController.text,
        ubicacion: _ubicacionController.text,
        isActive: widget.sucursal?.isActive ?? true,
      );

      await Provider.of<SucursalViewModel>(context, listen: false).guardar(sucursal);;
      
      if (mounted) {
        setState(() {
          _guardandoSucursal = false;
        });
      }
      
      Navigator.pop(context); // Volver a la pantalla anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.sucursal != null;

    return Scaffold(
      appBar: ScreenAppbar(
        title: esEdicion ? 'Editar Sucursal' : 'Nueva Sucursal',        
      ),  
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo obligatorio'
                            : null,
              ),
              TextFormField(
                controller: _ubicacionController,
                decoration: InputDecoration(labelText: 'Ubicación'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo obligatorio'
                            : null,
              ),
              SizedBox(height: 20),
              BotonGuardar(
                isLoading: _guardandoSucursal,
                texto: esEdicion ? 'Actualizar' : 'Guardar',
                onPressed: _guardarSucursal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
