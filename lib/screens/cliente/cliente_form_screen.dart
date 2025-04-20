import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectofinal/models/cliente.dart';
import 'package:proyectofinal/viewmodels/cliente_viewmodel.dart';
import 'package:proyectofinal/widgets/comun/boton_guardar.dart';
import 'package:proyectofinal/widgets/comun/screen_appbar.dart';

class ClienteFormScreen extends StatefulWidget {
  static const String routeName = '/cliente_form';
  final Cliente? cliente;

  const ClienteFormScreen({super.key, this.cliente});

  @override
  State<ClienteFormScreen> createState() => _ClienteFormScreenState();
}

class _ClienteFormScreenState extends State<ClienteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _guardandoCliente = false;

  late TextEditingController _nombreController;
  late TextEditingController _correoController;
  late TextEditingController _telefonoController;
  late TextEditingController _direccionController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(
      text: widget.cliente?.nombre ?? '',
    );
    _correoController = TextEditingController(
      text: widget.cliente?.correo ?? '',
    );
    _telefonoController = TextEditingController(
      text: widget.cliente?.telefono ?? '',
    );
    _direccionController = TextEditingController(
      text: widget.cliente?.direccion ?? '',
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    super.dispose();
  }

  void _guardarCliente() async {
    if (_formKey.currentState!.validate()) {
      final cliente = Cliente(
        idCliente: widget.cliente?.idCliente,
        nombre: _nombreController.text.trim(),
        correo: _correoController.text.trim(),
        telefono: _telefonoController.text.trim(),
        direccion: _direccionController.text.trim(),
      );

      setState(() {
        _guardandoCliente = true;
      });

      await Provider.of<ClienteViewModel>(
        context,
        listen: false,
      ).guardar(cliente);

      if (mounted) {
        setState(() {
          _guardandoCliente = false;
        });
      }

      Navigator.pop(context); // Volver a la pantalla anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.cliente != null;

    return Scaffold(
      appBar: ScreenAppbar(
        title: esEdicion ? 'Editar Cliente' : 'Nuevo Cliente',        
      ),      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator:
                    (value) => value!.isEmpty ? 'Ingrese un nombre' : null,
              ),
              TextFormField(
                controller: _correoController,
                decoration: const InputDecoration(labelText: 'Correo'),
                validator:
                    (value) => value!.isEmpty ? 'Ingrese un correo' : null,
              ),
              TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                validator:
                    (value) => value!.isEmpty ? 'Ingrese un teléfono' : null,
              ),
              TextFormField(
                controller: _direccionController,
                decoration: const InputDecoration(labelText: 'Dirección'),
                validator:
                    (value) => value!.isEmpty ? 'Ingrese una dirección' : null,
              ),
              const SizedBox(height: 24),
              BotonGuardar(
                isLoading: _guardandoCliente,
                texto: esEdicion ? 'Actualizar' : 'Guardar',
                onPressed: _guardarCliente,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
