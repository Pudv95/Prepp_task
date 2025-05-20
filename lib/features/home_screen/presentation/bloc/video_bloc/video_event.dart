part of 'video_bloc.dart';

@immutable
sealed class VideoEvent {}

class LoadVideoEvent extends VideoEvent {}
