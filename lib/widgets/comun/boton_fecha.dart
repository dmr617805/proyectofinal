import 'package:flutter/material.dart';

class BotonFecha extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onPressed;

  const BotonFecha({
    super.key,
    required this.label,
    required this.date,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label),
        ElevatedButton.icon(
          icon: const Icon(Icons.date_range),
          label: Text('${date.day}-${date.month}-${date.year}'),
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
