import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prepp/core/router/app_router.dart';
import 'package:prepp/core/theme/app_theme.dart';
import 'package:prepp/core/theme/theme_cubit.dart';
import 'package:prepp/features/home_screen/presentation/bloc/video_bloc/video_bloc.dart';
import 'core/di/di.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await setupLocator();

  runApp(const Prepp());
}

class Prepp extends StatelessWidget {
  const Prepp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => locator<ThemeCubit>()),
        BlocProvider(create: (_) => locator<VideoBloc>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeState) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
