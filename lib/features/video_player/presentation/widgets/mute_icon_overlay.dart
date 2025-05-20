import 'package:flutter/material.dart';

class MuteIconOverlay extends StatelessWidget {
  final bool isMuted;

  const MuteIconOverlay({super.key, required this.isMuted});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          isMuted ? Icons.volume_off : Icons.volume_up,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}
