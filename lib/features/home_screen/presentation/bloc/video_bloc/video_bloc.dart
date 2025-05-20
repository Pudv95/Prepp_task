import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:prepp/features/home_screen/domain/entities/video_entity.dart';
import 'package:prepp/features/home_screen/domain/repositories/video_player_repository.dart';

part 'video_event.dart';
part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final VideoPlayerRepository _videoRepository;

  VideoBloc(this._videoRepository) : super(VideoInitial()) {
    if (kDebugMode) {
      print('🔄 VideoBloc created: ${hashCode}');
    }
    on<LoadVideoEvent>(_onVideoLoadedEvent);
  }

  @override
  void onChange(Change<VideoState> change) {
    super.onChange(change);
    if (kDebugMode) {
      print(
        '🔄 VideoBloc state changed: ${change.currentState.runtimeType} -> ${change.nextState.runtimeType}',
      );
    }
  }

  Future<void> _onVideoLoadedEvent(
    LoadVideoEvent event,
    Emitter<VideoState> emit,
  ) async {
    if (kDebugMode) {
      print('📥 VideoBloc received VideoLoadedEvent');
    }
    emit(VideoLoading());
    try {
      final videos = await _videoRepository.getVideos();
      if (kDebugMode) {
        print('✅ VideoBloc loaded ${videos.length} videos');
      }
      emit(VideoLoaded(videos: videos));
    } catch (e) {
      if (kDebugMode) {
        print('❌ VideoBloc error: $e');
      }
      emit(VideoError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    if (kDebugMode) {
      print('🔒 VideoBloc closed: ${hashCode}');
    }
    return super.close();
  }
}
