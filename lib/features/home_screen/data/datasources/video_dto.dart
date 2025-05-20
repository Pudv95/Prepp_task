import '../../domain/entities/video_entity.dart';

class VideoDTO {
  final int id;
  final String title;
  final String thumbnail;
  final String videoUrl;

  VideoDTO({required this.id, required this.title, required this.thumbnail, required this.videoUrl});

  factory VideoDTO.fromJson(Map<String, dynamic> json) {
    return VideoDTO(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      videoUrl: json['videoUrl'],
    );
  }

  VideoEntity toEntity() {
    return VideoEntity(
      id: id,
      title: title,
      thumbnail: thumbnail,
      videoUrl: videoUrl,
    );
  }
}
