import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoSeekBar extends StatefulWidget {
  final VideoPlayerController controller;
  final VoidCallback onSeek;

  const VideoSeekBar({
    super.key,
    required this.controller,
    required this.onSeek,
  });

  @override
  State<VideoSeekBar> createState() => _VideoSeekBarState();
}

class _VideoSeekBarState extends State<VideoSeekBar> {
  bool _isDragging = false;
  Duration? _dragPosition;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller,
      builder: (context, VideoPlayerValue value, child) {
        final position = _isDragging ? _dragPosition : value.position;
        final duration = value.duration;
        final progress = position?.inMilliseconds.toDouble() ?? 0.0;
        final total = duration.inMilliseconds.toDouble();
        final width = MediaQuery.of(context).size.width;
        final progressWidth = (progress / total) * width;

        return Container(
          height: 40, // Increased height to accommodate thumb
          width: double.infinity,
          color: Colors.transparent,
          child: Stack(
            children: [
              // Background track
              Positioned(
                top: 19, // Center the track
                left: 0,
                right: 0,
                child: Container(
                  height: 2,
                  color: Colors.grey.withOpacity(0.3),
                ),
              ),
              // Progress bar
              Positioned(
                top: 19,
                left: 0,
                child: Container(
                  height: 2,
                  width: progressWidth,
                  color: Colors.white,
                ),
              ),
              // Thumb
              Positioned(
                top: 10,
                left: progressWidth - 10, // Center the thumb on the progress
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              // Gesture detector for seeking
              GestureDetector(
                onHorizontalDragStart: (details) {
                  setState(() {
                    _isDragging = true;
                  });
                  widget.controller.pause();
                },
                onHorizontalDragUpdate: (details) {
                  final box = context.findRenderObject() as RenderBox;
                  final Offset localPosition = box.globalToLocal(
                    details.globalPosition,
                  );
                  final double relativePosition =
                      (localPosition.dx / box.size.width).clamp(0.0, 1.0);
                  final Duration newPosition = Duration(
                    milliseconds:
                        (relativePosition * duration.inMilliseconds).toInt(),
                  );
                  setState(() {
                    _dragPosition = newPosition;
                  });
                  widget.controller.seekTo(newPosition);
                },
                onHorizontalDragEnd: (details) {
                  setState(() {
                    _isDragging = false;
                    _dragPosition = null;
                  });
                  widget.controller.play();
                  widget.onSeek();
                },
                onTapDown: (details) {
                  final box = context.findRenderObject() as RenderBox;
                  final Offset localPosition = box.globalToLocal(
                    details.globalPosition,
                  );
                  final double relativePosition =
                      (localPosition.dx / box.size.width).clamp(0.0, 1.0);
                  final Duration newPosition = Duration(
                    milliseconds:
                        (relativePosition * duration.inMilliseconds).toInt(),
                  );
                  widget.controller.seekTo(newPosition);
                  widget.onSeek();
                },
                child: Container(
                  color: Colors.transparent,
                  height: 40,
                  width: double.infinity,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
