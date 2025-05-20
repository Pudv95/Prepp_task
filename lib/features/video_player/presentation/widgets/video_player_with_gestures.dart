import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'video_player_container.dart';

class VideoPlayerWithGestures extends StatelessWidget {
  final VideoPlayerController? controller;
  final VoidCallback onMuteToggle;
  final Function(bool, bool) onSpeedChange;
  final VoidCallback onPause;
  final VoidCallback onPlay;

  const VideoPlayerWithGestures({
    super.key,
    required this.controller,
    required this.onMuteToggle,
    required this.onSpeedChange,
    required this.onPause,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final edgeWidth = screenWidth * 0.15; // 15% of screen width for edge areas

    return Stack(
      children: [
        // Video Player
        VideoPlayerContainer(controller: controller),

        // Middle area - hold to pause
        Positioned(
          left: edgeWidth,
          right: edgeWidth,
          top: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: onMuteToggle,
            onLongPressStart: (_) => onPause(),
            onLongPressEnd: (_) => onPlay(),
          ),
        ),

        // Left edge area - long press for 2x speed
        Positioned(
          left: 0,
          width: edgeWidth,
          top: 0,
          bottom: 0,
          child: GestureDetector(
            onLongPressStart: (_) => onSpeedChange(true, true),
            onLongPressEnd: (_) => onSpeedChange(false, true),
            onTap: onMuteToggle,
          ),
        ),

        // Right edge area - long press for 0.5x speed
        Positioned(
          right: 0,
          width: edgeWidth,
          top: 0,
          bottom: 0,
          child: GestureDetector(
            onLongPressStart: (_) => onSpeedChange(true, false),
            onLongPressEnd: (_) => onSpeedChange(false, false),
            onTap: onMuteToggle,
          ),
        ),
      ],
    );
  }
}
