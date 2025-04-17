import 'package:flutter/material.dart';

class TotalesWidget extends StatelessWidget {
   final int totalProductos;
  final double totalPagar;

  const TotalesWidget({
    super.key,
    required this.totalProductos,
    required this.totalPagar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '# Productos: $totalProductos',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          Text(
            'Total a pagar: \$${totalPagar.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 6, 7, 6),
            ),
          ),
        ],
      ),
    );
  }
}