import 'package:injectable/injectable.dart';
import '../../domain/entities/video_entity.dart';
import '../datasources/video_dto.dart';
import '../datasources/video_player_remote_data_source.dart';
import '../../domain/repositories/video_player_repository.dart';

@Injectable(as: VideoPlayerRepository)
class VideoPlayerRepositoryImpl implements VideoPlayerRepository {
  final VideoPlayerRemoteDataSource remoteDataSource;

  VideoPlayerRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<VideoEntity>> getVideos() async {
    try {
      List<VideoDTO> videoDTOs = await remoteDataSource.getVideos();
      return videoDTOs.map((dto) => dto.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get video URL: $e');
    }
  }
}
