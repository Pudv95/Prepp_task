import '../entities/video_entity.dart';

abstract class VideoPlayerRepository {
  Future<List<VideoEntity>> getVideos();
}
