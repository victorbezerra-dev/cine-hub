import 'package:flutter/material.dart';

class EmptySectionState extends StatelessWidget {
  const EmptySectionState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(child: Text('No movies available right now.')),
    );
  }
}
