import 'package:flutter/material.dart';
import 'syringe_graphic.dart';

class ResultCard extends StatelessWidget {
  final double unitsToDraw;
  final int dosesPerVial;

  const ResultCard({
    super.key,
    required this.unitsToDraw,
    required this.dosesPerVial,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Results",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              "Inject: ${unitsToDraw.round()} units on a 100-unit syringe.",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 8),
            Text(
              "Doses Available: $dosesPerVial full doses per vial.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            SyringeGraphic(units: unitsToDraw),
          ],
        ),
      ),
    );
  }
}