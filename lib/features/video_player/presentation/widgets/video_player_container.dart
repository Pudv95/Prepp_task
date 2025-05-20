import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerContainer extends StatelessWidget {
  final VideoPlayerController? controller;

  const VideoPlayerContainer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return controller?.value.isInitialized ?? false
        ? AspectRatio(
          aspectRatio: controller!.value.aspectRatio,
          child: VideoPlayer(controller!),
        )
        : const Center(child: CircularProgressIndicator());
  }
}
