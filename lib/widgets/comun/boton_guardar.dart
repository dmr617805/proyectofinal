import 'package:flutter/material.dart';

class BotonGuardar extends StatelessWidget {

  final VoidCallback? onPressed;
  final bool isLoading;
  final String texto;

  
  const BotonGuardar({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.texto = 'Guardar',
  });

@override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        icon: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Icon(Icons.save, size: 28),
        label: Text(
          isLoading ? 'Guardando...' : texto,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(          
 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: isLoading ? null : onPressed,
      ),
    );
  }

}

