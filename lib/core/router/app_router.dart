import 'package:go_router/go_router.dart';
import 'package:prepp/features/home_screen/presentation/screens/video_grid_screen.dart';
import 'package:prepp/features/video_player/presentation/pages/videos_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const VideoGridScreen()),
    GoRoute(
      path: '/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return VideosScreen(initialVideoIndex: int.parse(id!));
      },
    ),
  ],
);
