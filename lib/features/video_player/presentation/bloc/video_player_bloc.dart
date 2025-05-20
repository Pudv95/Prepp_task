import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import '../../data/services/video_cache_service.dart';
import 'dart:async';

// Events
abstract class VideoPlayerEvent {}

class InitializeVideoEvent extends VideoPlayerEvent {
  final String videoUrl;
  final int videoId;

  InitializeVideoEvent({required this.videoUrl, required this.videoId});
}

class DisposeVideoEvent extends VideoPlayerEvent {
  final int videoId;

  DisposeVideoEvent({required this.videoId});
}

class ToggleMuteEvent extends VideoPlayerEvent {
  final int videoId;

  ToggleMuteEvent({required this.videoId});
}

class ChangeSpeedEvent extends VideoPlayerEvent {
  final int videoId;
  final bool start;
  final bool isLeftEdge;

  ChangeSpeedEvent({
    required this.videoId,
    required this.start,
    required this.isLeftEdge,
  });
}

// State
class VideoPlayerState {
  final Map<int, VideoPlayerController> controllers;
  final Map<int, bool> isMuted;
  final Map<int, double> playbackSpeed;
  final bool showMuteIcon;
  final bool showSpeedIcon;
  final bool isLeftEdgeSpeed;
  final bool isInitialized;

  VideoPlayerState({
    required this.controllers,
    required this.isMuted,
    required this.playbackSpeed,
    this.showMuteIcon = false,
    this.showSpeedIcon = false,
    this.isLeftEdgeSpeed = false,
    this.isInitialized = false,
  });

  VideoPlayerState copyWith({
    Map<int, VideoPlayerController>? controllers,
    Map<int, bool>? isMuted,
    Map<int, double>? playbackSpeed,
    bool? showMuteIcon,
    bool? showSpeedIcon,
    bool? isLeftEdgeSpeed,
    bool? isInitialized,
  }) {
    return VideoPlayerState(
      controllers: controllers ?? this.controllers,
      isMuted: isMuted ?? this.isMuted,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      showMuteIcon: showMuteIcon ?? this.showMuteIcon,
      showSpeedIcon: showSpeedIcon ?? this.showSpeedIcon,
      isLeftEdgeSpeed: isLeftEdgeSpeed ?? this.isLeftEdgeSpeed,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

class VideoPlayerBloc extends Bloc<VideoPlayerEvent, VideoPlayerState> {
  final VideoCacheService _cacheService;
  Timer? _muteIconTimer;
  Timer? _speedIconTimer;

  VideoPlayerBloc(this._cacheService)
    : super(VideoPlayerState(controllers: {}, isMuted: {}, playbackSpeed: {})) {
    on<InitializeVideoEvent>(_onInitializeVideo);
    on<DisposeVideoEvent>(_onDisposeVideo);
    on<ToggleMuteEvent>(_onToggleMute);
    on<ChangeSpeedEvent>(_onChangeSpeed);
  }

  Future<void> _onInitializeVideo(
    InitializeVideoEvent event,
    Emitter<VideoPlayerState> emit,
  ) async {
    if (state.controllers.containsKey(event.videoId)) return;

    try {
      final controller = await _cacheService.getVideoController(event.videoUrl);
      await controller.initialize();
      controller.play();
      controller.setVolume(0);

      // Set up video looping
      controller.addListener(() {
        if (controller.value.position >= controller.value.duration) {
          controller.seekTo(Duration.zero);
          controller.play();
        }
      });

      final updatedControllers = Map<int, VideoPlayerController>.from(
        state.controllers,
      );
      final updatedIsMuted = Map<int, bool>.from(state.isMuted);
      final updatedPlaybackSpeed = Map<int, double>.from(state.playbackSpeed);

      updatedControllers[event.videoId] = controller;
      updatedIsMuted[event.videoId] = true;
      updatedPlaybackSpeed[event.videoId] = 1.0;

      emit(
        state.copyWith(
          controllers: updatedControllers,
          isMuted: updatedIsMuted,
          playbackSpeed: updatedPlaybackSpeed,
          isInitialized: true,
        ),
      );
    } catch (e) {
      print('Error initializing video controller: $e');
    }
  }

  void _onDisposeVideo(
    DisposeVideoEvent event,
    Emitter<VideoPlayerState> emit,
  ) {
    if (state.controllers.containsKey(event.videoId)) {
      final controller = state.controllers[event.videoId];
      if (controller != null) {
        _cacheService.disposeController(event.videoId.toString());
      }

      final updatedControllers = Map<int, VideoPlayerController>.from(
        state.controllers,
      );
      final updatedIsMuted = Map<int, bool>.from(state.isMuted);
      final updatedPlaybackSpeed = Map<int, double>.from(state.playbackSpeed);

      updatedControllers.remove(event.videoId);
      updatedIsMuted.remove(event.videoId);
      updatedPlaybackSpeed.remove(event.videoId);

      emit(
        state.copyWith(
          controllers: updatedControllers,
          isMuted: updatedIsMuted,
          playbackSpeed: updatedPlaybackSpeed,
        ),
      );
    }
  }

  Future<void> _onToggleMute(
    ToggleMuteEvent event,
    Emitter<VideoPlayerState> emit,
  ) async {
    if (!state.controllers.containsKey(event.videoId)) return;

    final updatedIsMuted = Map<int, bool>.from(state.isMuted);
    updatedIsMuted[event.videoId] = !(updatedIsMuted[event.videoId] ?? true);

    await state.controllers[event.videoId]?.setVolume(
      updatedIsMuted[event.videoId]! ? 0 : 1,
    );

    _muteIconTimer?.cancel();
    emit(state.copyWith(isMuted: updatedIsMuted, showMuteIcon: true));

    await Future.delayed(const Duration(seconds: 1));
    if (!isClosed) {
      emit(state.copyWith(showMuteIcon: false));
    }
  }

  Future<void> _onChangeSpeed(
    ChangeSpeedEvent event,
    Emitter<VideoPlayerState> emit,
  ) async {
    if (!state.controllers.containsKey(event.videoId)) return;

    final updatedPlaybackSpeed = Map<int, double>.from(state.playbackSpeed);

    if (event.start) {
      updatedPlaybackSpeed[event.videoId] = event.isLeftEdge ? 2.0 : 0.5;
      await state.controllers[event.videoId]?.setPlaybackSpeed(
        updatedPlaybackSpeed[event.videoId]!,
      );

      emit(
        state.copyWith(
          playbackSpeed: updatedPlaybackSpeed,
          showSpeedIcon: true,
          isLeftEdgeSpeed: event.isLeftEdge,
        ),
      );

      await Future.delayed(const Duration(seconds: 2));
      if (!isClosed) {
        emit(state.copyWith(showSpeedIcon: false));
      }
    } else {
      updatedPlaybackSpeed[event.videoId] = 1.0;
      await state.controllers[event.videoId]?.setPlaybackSpeed(1.0);

      emit(
        state.copyWith(
          playbackSpeed: updatedPlaybackSpeed,
          showSpeedIcon: false,
          isLeftEdgeSpeed: false,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _muteIconTimer?.cancel();
    _speedIconTimer?.cancel();
    return super.close();
  }
}
