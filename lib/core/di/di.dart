import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:prepp/core/theme/theme_cubit.dart';
import 'package:prepp/core/theme/theme_storage.dart';
import 'package:prepp/features/home_screen/data/datasources/video_player_remote_data_source.dart';
import 'package:prepp/features/home_screen/data/repositories/video_player_repository_impl.dart';
import 'package:prepp/features/home_screen/domain/repositories/video_player_repository.dart';
import 'package:prepp/features/home_screen/presentation/bloc/video_bloc/video_bloc.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  final dio = Dio();

  locator.registerLazySingleton(() => dio);

  // Bloc for themes
  locator.registerLazySingleton<ThemeStorage>(() => ThemeStorage());
  locator.registerSingleton<ThemeCubit>(ThemeCubit(locator<ThemeStorage>()));

  // Bloc repository for videos
  locator.registerLazySingleton<VideoPlayerRepository>(
    () => VideoPlayerRepositoryImpl(locator<VideoPlayerRemoteDataSource>()),
  );
  locator.registerLazySingleton<VideoPlayerRemoteDataSource>(
    () => VideoPlayerRemoteDataSource(locator<Dio>()),
  );
  locator.registerLazySingleton<VideoBloc>(
    () => VideoBloc(locator<VideoPlayerRepository>()),
  );

  // Debug: Verify VideoBloc registration
  if (kDebugMode) {
    try {
      final videoBloc = locator<VideoBloc>();
      print('✅ VideoBloc successfully registered: ${videoBloc.hashCode}');

      // Verify repository injection
      final repository = locator<VideoPlayerRepository>();
      print(
        '✅ VideoPlayerRepository successfully registered: ${repository.hashCode}',
      );

      // Verify remote data source injection
      final remoteDataSource = locator<VideoPlayerRemoteDataSource>();
      print(
        '✅ VideoPlayerRemoteDataSource successfully registered: ${remoteDataSource.hashCode}',
      );
    } catch (e) {
      print('❌ Error verifying VideoBloc registration: $e');
    }
  }
}
