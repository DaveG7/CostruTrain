import 'package:flutter/material.dart';

class SeedSplashScreen extends StatelessWidget {
  const SeedSplashScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
}
