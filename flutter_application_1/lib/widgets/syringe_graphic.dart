import 'package:flutter/material.dart';

class SyringeGraphic extends StatelessWidget {
  final double units;

  const SyringeGraphic({super.key, required this.units});

  @override
  Widget build(BuildContext context) {
    final fillPercent = (units.clamp(0, 100) / 100);

    return Column(
      children: [
        const Text(
          "Syringe visualization",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              width: 200,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black45),
              ),
            ),
            Container(
              width: 200 * fillPercent,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFF45CFDD),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          "${units.round()} units",
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}