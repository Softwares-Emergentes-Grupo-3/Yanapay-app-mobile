import 'package:flutter/material.dart';

class AddGreenhouseCard extends StatelessWidget {
  const AddGreenhouseCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.primary,
            colors.tertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.add,
            color: colors.secondary,
          ),
        ),
      ),
    );
  }
}
