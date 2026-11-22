import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/artwork_export_service.dart';
import '../../domain/entities/artwork_stroke.dart';
import '../widgets/artwork_canvas.dart';
import '../widgets/color_picker.dart';
import '../widgets/studio_actions.dart';
import '../widgets/studio_header.dart';

class ArtStudioPage extends StatefulWidget {
  const ArtStudioPage({super.key});

  @override
  State<ArtStudioPage> createState() => _ArtStudioPageState();
}

class _ArtStudioPageState extends State<ArtStudioPage> {
  final GlobalKey _artworkKey = GlobalKey();

  final ArtworkExportService _exportService = ArtworkExportService();

  List<ArtworkStroke> _strokes = [];

  int? _activeStrokeIndex;

  Color _selectedColor = AppColors.pink;

  bool _isSaving = false;
  bool _isSharing = false;

  final List<Color> _colors = const [
    AppColors.pink,
    AppColors.purple,
    AppColors.blue,
    AppColors.green,
    AppColors.yellow,
    AppColors.white,
  ];

  void _startDrawing(Offset position) {
    final stroke = ArtworkStroke(color: _selectedColor, points: [position]);

    setState(() {
      _strokes = [..._strokes, stroke];
      _activeStrokeIndex = _strokes.length - 1;
    });
  }

  void _updateDrawing(Offset position) {
    final index = _activeStrokeIndex;

    if (index == null) return;

    final currentStroke = _strokes[index];
    final previousPoint = currentStroke.points.last;

    // Avoid storing unnecessary nearby points.
    if ((position - previousPoint).distance < 2) return;

    final updatedStrokes = [..._strokes];

    updatedStrokes[index] = currentStroke.addPoint(position);

    setState(() {
      _strokes = updatedStrokes;
    });
  }

  void _finishDrawing() {
    _activeStrokeIndex = null;
  }

  void _clearArtwork() {
    setState(() {
      _strokes = [];
      _activeStrokeIndex = null;
    });
  }

  void _selectColor(Color color) {
    setState(() {
      _selectedColor = color;
    });
  }

  Future<void> _saveArtwork() async {
    if (_isSaving || _isSharing) return;

    setState(() => _isSaving = true);

    try {
      final bytes = await _exportService.capture(_artworkKey);
      await _exportService.save(bytes);

      if (!mounted) return;

      _showMessage(
        title: 'Artwork Saved!',
        message: 'Your artwork is now in your gallery.',
      );
    } catch (error) {
      if (!mounted) return;

      _showMessage(
        title: 'Error,Could not save artwork: $error',
        message: "Please try again later.",
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _shareArtwork() async {
    if (_isSaving || _isSharing) return;

    setState(() => _isSharing = true);

    try {
      final bytes = await _exportService.capture(_artworkKey);
      await _exportService.share(bytes);
    } catch (error) {
      if (!mounted) return;

      _showMessage(
        title: 'Ready to Share!',
        message: 'Your artwork is ready to share.',
        icon: Icons.share_rounded,
      );
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  void _showMessage({
    required String title,
    required String message,
    IconData icon = Icons.check_circle_rounded,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.zero,
          duration: const Duration(seconds: 3),
          content: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF171221),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.pink.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.pink, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth > 600 ? 32.0 : 16.0;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  StudioHeader(onClear: _clearArtwork),

                  Expanded(
                    child: ArtworkCanvas(
                      repaintKey: _artworkKey,
                      strokes: _strokes,
                      onPointerDown: _startDrawing,
                      onPointerMove: _updateDrawing,
                      onPointerUp: _finishDrawing,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: ColorPicker(
                      colors: _colors,
                      selectedColor: _selectedColor,
                      onColorSelected: _selectColor,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: StudioActions(
                      isSaving: _isSaving,
                      isSharing: _isSharing,
                      onSave: _saveArtwork,
                      onShare: _shareArtwork,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
