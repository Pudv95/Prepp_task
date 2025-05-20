import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prepp/features/home_screen/presentation/bloc/video_bloc/video_bloc.dart';
import '../widgets/video_player_with_gestures.dart';
import '../widgets/mute_icon_overlay.dart';
import '../widgets/speed_indicator.dart';
import '../widgets/video_controls_overlay.dart';
import '../../data/services/video_cache_service.dart';
import '../bloc/video_player_bloc.dart';

class VideosScreen extends StatefulWidget {
  final int? initialVideoIndex;

  const VideosScreen({super.key, this.initialVideoIndex});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  late final PageController _pageController;
  VideoCacheService? _cacheService;
  VideoPlayerBloc? _videoPlayerBloc;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.initialVideoIndex ?? 0,
    );
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      _cacheService = VideoCacheService();
      await _cacheService!.init();
      _videoPlayerBloc = VideoPlayerBloc(_cacheService!);
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      print('Error initializing services: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _videoPlayerBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return BlocProvider.value(
      value: _videoPlayerBloc!,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Videos',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.black,
        body: BlocBuilder<VideoBloc, VideoState>(
          builder: (context, state) {
            if (state is VideoLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is VideoLoaded) {
              return PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: state.videos.length,
                onPageChanged: (index) {
                  _videoPlayerBloc!.add(
                    InitializeVideoEvent(
                      videoUrl: state.videos[index].videoUrl,
                      videoId: state.videos[index].id,
                    ),
                  );
                  if (index > 0) {
                    _videoPlayerBloc!.add(
                      DisposeVideoEvent(videoId: state.videos[index - 1].id),
                    );
                  }
                  if (index < state.videos.length - 1) {
                    _videoPlayerBloc!.add(
                      DisposeVideoEvent(videoId: state.videos[index + 1].id),
                    );
                  }
                },
                itemBuilder: (context, index) {
                  final video = state.videos[index];
                  _videoPlayerBloc!.add(
                    InitializeVideoEvent(
                      videoUrl: video.videoUrl,
                      videoId: video.id,
                    ),
                  );

                  return BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
                    builder: (context, playerState) {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          VideoPlayerWithGestures(
                            controller: playerState.controllers[video.id],
                            onMuteToggle:
                                () => _videoPlayerBloc!.add(
                                  ToggleMuteEvent(videoId: video.id),
                                ),
                            onSpeedChange:
                                (start, isLeftEdge) => _videoPlayerBloc!.add(
                                  ChangeSpeedEvent(
                                    videoId: video.id,
                                    start: start,
                                    isLeftEdge: isLeftEdge,
                                  ),
                                ),
                            onPause: () {
                              final controller =
                                  playerState.controllers[video.id];
                              if (controller?.value.isInitialized ?? false) {
                                controller?.pause();
                              }
                            },
                            onPlay: () {
                              final controller =
                                  playerState.controllers[video.id];
                              if (controller?.value.isInitialized ?? false) {
                                controller?.play();
                              }
                            },
                          ),

                          if (playerState.showMuteIcon)
                            MuteIconOverlay(
                              isMuted: playerState.isMuted[video.id] ?? true,
                            ),

                          if (playerState.showSpeedIcon)
                            SpeedIndicator(
                              isLeftEdge: playerState.isLeftEdgeSpeed,
                            ),

                          if (playerState.controllers[video.id] != null)
                            VideoControlsOverlay(
                              title: video.title,
                              isMuted: playerState.isMuted[video.id] ?? true,
                              onMuteToggle:
                                  () => _videoPlayerBloc!.add(
                                    ToggleMuteEvent(videoId: video.id),
                                  ),
                              controller: playerState.controllers[video.id]!,
                            ),
                        ],
                      );
                    },
                  );
                },
              );
            } else if (state is VideoError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
