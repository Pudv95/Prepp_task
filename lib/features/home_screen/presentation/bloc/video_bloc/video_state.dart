part of 'video_bloc.dart';

@immutable
sealed class VideoState {}

final class VideoInitial extends VideoState {}

final class VideoLoading extends VideoState {}

final class VideoLoaded extends VideoState {
  final List<VideoEntity> videos;
  VideoLoaded({required this.videos});
}

final class VideoError extends VideoState {
  final String message;
  VideoError({required this.message});
}
