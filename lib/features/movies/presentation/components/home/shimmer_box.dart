import 'package:flutter/material.dart';

class ShimmerBox extends StatefulWidget {
  const ShimmerBox({super.key, this.height, this.widthFactor});

  final double? height;
  final double? widthFactor;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = Colors.white.withValues(alpha: 0.06);
    final highlight = Colors.white.withValues(alpha: 0.16);

    return FractionallySizedBox(
      widthFactor: widget.widthFactor,
      alignment: Alignment.centerLeft,
      child: SizedBox(
        height: widget.height,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final slide = (_controller.value * 2) - 1;

            return DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  begin: Alignment(-1.8 + slide, -0.2),
                  end: Alignment(1.8 + slide, 0.2),
                  colors: [base, highlight, base],
                  stops: const [0.1, 0.3, 0.4],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
