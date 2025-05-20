import 'package:equatable/equatable.dart';

class VideoEntity extends Equatable {
  final int id;
  final String title;
  final String thumbnail;
  final String videoUrl;

  const VideoEntity({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.videoUrl,
  });

  @override
  List<Object?> get props => [id, title, thumbnail, videoUrl];
}
