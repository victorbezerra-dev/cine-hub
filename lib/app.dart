import 'package:flutter/material.dart';
import 'core/route/app_route.dart';

class CineHubApp extends StatelessWidget {
  const CineHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'CineHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
    );
  }
}
