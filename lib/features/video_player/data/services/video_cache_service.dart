import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:video_player/video_player.dart';
import 'dart:developer' as developer;

class VideoCacheService {
  static const String _boxName = 'videoCache';
  Box<String>? _cacheBox;
  final Map<String, VideoPlayerController> _activeControllers = {};
  bool _isInitialized = false;
  Directory? _cacheDirectory;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      _cacheBox = await Hive.openBox<String>(_boxName);
      _cacheDirectory = await getApplicationDocumentsDirectory();
      _isInitialized = true;
      developer.log('VideoCacheService initialized successfully');
    } catch (e, stackTrace) {
      developer.log(
        'Error initializing VideoCacheService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  String _getCacheKey(String url) {
    return sha256.convert(utf8.encode(url)).toString();
  }

  Future<String?> getCachedVideoPath(String url) async {
    if (!_isInitialized) await init();
    final cacheKey = _getCacheKey(url);
    final cachedPath = _cacheBox?.get(cacheKey);

    if (cachedPath != null && File(cachedPath).existsSync()) {
      developer.log('📦 Cache HIT for video: $url');
      return cachedPath;
    } else {
      developer.log('❌ Cache MISS for video: $url');
      return null;
    }
  }

  Future<String> cacheVideo(String url) async {
    if (!_isInitialized) await init();

    final cacheKey = _getCacheKey(url);
    final cachedPath = await getCachedVideoPath(url);

    if (cachedPath != null && File(cachedPath).existsSync()) {
      developer.log('🔄 Using cached video from: $cachedPath');
      return cachedPath;
    }

    try {
      developer.log('⬇️ Downloading video from: $url');
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to download video: ${response.statusCode}');
      }

      if (_cacheDirectory == null) {
        throw Exception('Cache directory not initialized');
      }

      final filePath = '${_cacheDirectory!.path}/$cacheKey.mp4';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      await _cacheBox?.put(cacheKey, filePath);
      developer.log('✅ Video downloaded and cached successfully at: $filePath');
      return filePath;
    } catch (e, stackTrace) {
      developer.log('❌ Error caching video', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<VideoPlayerController> getVideoController(String url) async {
    if (!_isInitialized) await init();

    if (_activeControllers.containsKey(url)) {
      developer.log('🎥 Reusing existing controller for video: $url');
      return _activeControllers[url]!;
    }

    try {
      final cachedPath = await getCachedVideoPath(url);
      VideoPlayerController controller;

      if (cachedPath != null && File(cachedPath).existsSync()) {
        developer.log('🎬 Loading video from cache: $cachedPath');
        controller = VideoPlayerController.file(File(cachedPath));
      } else {
        developer.log(
          '📥 Downloading and creating new controller for video: $url',
        );
        final filePath = await cacheVideo(url);
        controller = VideoPlayerController.file(File(filePath));
      }

      _activeControllers[url] = controller;
      return controller;
    } catch (e, stackTrace) {
      developer.log(
        '❌ Error getting video controller',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  void disposeController(String url) {
    developer.log('🗑️ Disposing controller for video: $url');
    _activeControllers[url]?.dispose();
    _activeControllers.remove(url);
  }

  Future<void> clearCache() async {
    if (!_isInitialized) await init();

    try {
      if (_cacheDirectory == null) {
        throw Exception('Cache directory not initialized');
      }

      developer.log('🧹 Starting cache cleanup...');
      int deletedFiles = 0;
      for (var key in _cacheBox?.keys ?? []) {
        final path = _cacheBox?.get(key);
        if (path != null) {
          final file = File(path);
          if (file.existsSync()) {
            await file.delete();
            deletedFiles++;
          }
        }
      }
      await _cacheBox?.clear();
      developer.log(
        '✨ Cache cleared successfully. Deleted $deletedFiles files.',
      );
    } catch (e, stackTrace) {
      developer.log('❌ Error clearing cache', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
