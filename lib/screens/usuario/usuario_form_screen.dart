import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectofinal/models/usuario.dart';
import 'package:proyectofinal/viewmodels/usuario_viewmodel.dart';
import 'package:proyectofinal/widgets/comun/boton_guardar.dart';
import 'package:proyectofinal/widgets/comun/screen_appbar.dart';


class UsuarioFormScreen extends StatefulWidget {
  static const String routeName = '/usuario_form';
  final Usuario? usuario;

  const UsuarioFormScreen({super.key, this.usuario});

  @override
  State<UsuarioFormScreen> createState() => _UsuarioFormScreenState();
}

class _UsuarioFormScreenState extends State<UsuarioFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nombreController;
  late TextEditingController _apellidoPaternoController;
  late TextEditingController _apellidoMaternoController;
  late TextEditingController _correoController;
  late TextEditingController _passwordController;

  String? _rolSeleccionado;
  bool _guardandoUsuario = false;

  final List<String> _roles = ['administrador', 'vendedor'];

  @override
  void initState() {
    super.initState();

    _nombreController = TextEditingController(text: widget.usuario?.nombre ?? '');
    _apellidoPaternoController = TextEditingController(text: widget.usuario?.apellidoPaterno ?? '');
    _apellidoMaternoController = TextEditingController(text: widget.usuario?.apellidoMaterno ?? '');
    _correoController = TextEditingController(text: widget.usuario?.correo ?? '');
    _passwordController = TextEditingController(); // Por seguridad, no se llena desde usuario
    _rolSeleccionado = widget.usuario?.rol;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoPaternoController.dispose();
    _apellidoMaternoController.dispose();
    _correoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _guardarUsuario() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _guardandoUsuario = true;
      });

      final usuario = Usuario(
        idUsuario: widget.usuario?.idUsuario,
        nombre: _nombreController.text,
        apellidoPaterno: _apellidoPaternoController.text,
        apellidoMaterno: _apellidoMaternoController.text,
        correo: _correoController.text,
        password: _passwordController.text,
        rol: _rolSeleccionado!,
        isActive: widget.usuario?.isActive ?? true,
      );

      await Provider.of<UsuarioViewModel>(context, listen: false).guardar(usuario);

      if (mounted) {
        setState(() {
          _guardandoUsuario = false;
        });
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.usuario != null;

    return Scaffold(
      appBar: ScreenAppbar(
        title: esEdicion ? 'Editar Usuario' : 'Nuevo Usuario',        
      ),  
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: _apellidoPaternoController,
                decoration: const InputDecoration(labelText: 'Apellido Paterno'),
                validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: _apellidoMaternoController,
                decoration: const InputDecoration(labelText: 'Apellido Materno'),
              ),
              TextFormField(
                controller: _correoController,
                decoration: const InputDecoration(labelText: 'Correo'),
                validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                validator: (value) {
                  if (!esEdicion && (value == null || value.isEmpty)) {
                    return 'Campo obligatorio';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _rolSeleccionado,
                decoration: const InputDecoration(labelText: 'Rol'),
                items: _roles
                    .map((rol) => DropdownMenuItem<String>(
                          value: rol,
                          child: Text(rol[0].toUpperCase() + rol.substring(1)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _rolSeleccionado = value;
                  });
                },
                validator: (value) => value == null || value.isEmpty ? 'Seleccione un rol' : null,
              ),
              const SizedBox(height: 20),
              BotonGuardar(
                isLoading: _guardandoUsuario,
                texto: esEdicion ? 'Actualizar' : 'Guardar',
                onPressed: _guardarUsuario,
              ),
            ],
          ),
        ),
      ),
    );
  }
}