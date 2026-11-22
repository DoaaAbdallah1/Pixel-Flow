import 'package:flutter/material.dart';

import 'core/constants/app_colors.dart';
import 'features/pixel_flow/presentation/pages/art_studio_page.dart';

void main() {
  runApp(const PixelFlowApp());
}

class PixelFlowApp extends StatelessWidget {
  const PixelFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pixel Flow',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ),
      home: const ArtStudioPage(),
    );
  }
}