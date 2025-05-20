import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prepp/core/theme/theme_cubit.dart';
import 'package:prepp/features/home_screen/presentation/bloc/video_bloc/video_bloc.dart';
import '../widgets/video_tile.dart';

class VideoGridScreen extends StatefulWidget {
  const VideoGridScreen({super.key});

  @override
  State<VideoGridScreen> createState() => _VideoGridScreenState();
}

class _VideoGridScreenState extends State<VideoGridScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _showThemePopupMenu(BuildContext context, RenderBox button) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final buttonPosition = button.localToGlobal(Offset.zero, ancestor: overlay);
    final buttonSize = button.size;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        buttonPosition.dx,
        buttonPosition.dy + buttonSize.height,
        buttonPosition.dx + buttonSize.width,
        buttonPosition.dy + buttonSize.height + 48,
      ),
      items: [
        PopupMenuItem(
          child: const Text("Light Theme"),
          onTap: () => context.read<ThemeCubit>().setLightTheme(),
        ),
        PopupMenuItem(
          child: const Text("Dark Theme"),
          onTap: () => context.read<ThemeCubit>().setDarkTheme(),
        ),
        PopupMenuItem(
          child: const Text("System Default"),
          onTap: () => context.read<ThemeCubit>().setSystemTheme(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cricket Videos"),
        actions: [
          Builder(
            builder:
                (context) => IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    final RenderBox button =
                        context.findRenderObject()! as RenderBox;
                    _showThemePopupMenu(context, button);
                  },
                ),
          ),
        ],
      ),
      body: BlocBuilder<VideoBloc, VideoState>(
        builder: (context, state) {
          if (state is VideoInitial) {
            context.read<VideoBloc>().add(LoadVideoEvent());
            return const Center(child: CircularProgressIndicator());
          } else if (state is VideoLoaded) {
            final videos = state.videos;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: GridView.builder(
                itemCount: videos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return VideoTile(
                    video: video,
                    onTap: () => context.push('/$index'),
                  );
                },
              ),
            );
          } else if (state is VideoError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
