import 'package:flutter/material.dart';
import '../../domain/entities/video_entity.dart';

class VideoTile extends StatelessWidget {
  final VideoEntity video;
  final VoidCallback onTap;

  const VideoTile({super.key, required this.video, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: GridTile(
        footer: Container(
          color: Colors.black54,
          padding: const EdgeInsets.all(4),
          child: Text(
            video.title,
            style: const TextStyle(color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        child: Image.network(video.thumbnail, fit: BoxFit.cover),
      ),
    );
  }
}
