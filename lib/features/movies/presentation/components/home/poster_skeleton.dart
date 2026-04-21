import 'package:flutter/material.dart';

import 'shimmer_box.dart';

class PosterSkeleton extends StatelessWidget {
  const PosterSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(18)),
      child: ShimmerBox(),
    );
  }
}
