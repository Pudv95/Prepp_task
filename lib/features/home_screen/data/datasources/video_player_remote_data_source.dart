import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'video_dto.dart';

part 'video_player_remote_data_source.g.dart';

@RestApi(baseUrl: "http://crick.anaskhan.co.in",)
abstract class VideoPlayerRemoteDataSource {
  @factoryMethod
  factory VideoPlayerRemoteDataSource(Dio dio) = _VideoPlayerRemoteDataSource;

  @GET("/")
  Future<List<VideoDTO>> getVideos();
}
