
import 'package:flutter/material.dart';

class StudioHeader extends StatelessWidget {
  final VoidCallback onClear;

  const StudioHeader({
    super.key,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
      
        vertical: 16,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PIXEL FLOW',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'CREATE WITH LIGHT',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 9,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClear,
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.white70,
            ),
            tooltip: 'Clear artwork',
          ),
        ],
      ),
    );
  }
}
