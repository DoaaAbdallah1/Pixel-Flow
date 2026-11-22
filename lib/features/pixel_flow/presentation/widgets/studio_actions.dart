
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class StudioActions extends StatelessWidget {
  final bool isSaving;
  final bool isSharing;

  final VoidCallback onSave;
  final VoidCallback onShare;

  const StudioActions({
    super.key,
    required this.isSaving,
    required this.isSharing,
    required this.onSave,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final isProcessing = isSaving || isSharing;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: isProcessing ? null : onSave,
            icon: isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.download_outlined),
            label: const Text('Save'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white24),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: isProcessing ? null : onShare,
            icon: isSharing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.share_outlined),
            label: const Text('Share'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.pink,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ],
    );
  }
}
