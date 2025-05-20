import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'video_seek_bar.dart';

class VideoControlsOverlay extends StatelessWidget {
  final String title;
  final bool isMuted;
  final VoidCallback onMuteToggle;
  final VideoPlayerController controller;

  const VideoControlsOverlay({
    super.key,
    required this.title,
    required this.isMuted,
    required this.onMuteToggle,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            VideoSeekBar(controller: controller, onSeek: () {}),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
