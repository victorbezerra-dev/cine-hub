import 'package:flutter/material.dart';

class PosterFallback extends StatelessWidget {
  const PosterFallback({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade900,
      child: Center(child: Icon(icon, size: 36, color: Colors.white70)),
    );
  }
}
