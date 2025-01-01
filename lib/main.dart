import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

import 'core/constants/app_constants.dart';
import 'core/utils/logger.dart';
import 'core/utils/platform_utils.dart';
import 'presentation/screens/home_screen.dart';

// Global logger instance
final logger = AppLogger();

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize logger
      await logger.initialize();
      logger.info('Starting ${AppConstants.appName} v${AppConstants.appVersion}');
      logger.info('Platform: ${PlatformUtils.platformName}');

      // Set preferred orientations nur für Mobile
      if (PlatformUtils.isMobile) {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }

      // Platform specific initialization
      if (PlatformUtils.isWindows) {
        // Windows specific setup
        await _initializeWindows();
      } else if (PlatformUtils.isAndroid) {
        // Android specific setup
        await _initializeAndroid();
      }

      // Error handling für Flutter Errors
      FlutterError.onError = (FlutterErrorDetails details) {
        logger.error('Flutter Error', details.exception, details.stack);
      };

      runApp(const AudiobookMemeReader());
    },
    (error, stackTrace) {
      // Catch alle errors die nicht von Flutter gefangen werden
      logger.error('Uncaught error', error, stackTrace);
    },
  );
}

Future<void> _initializeWindows() async {
  logger.info('Initializing Windows specific features');
  // Hier später Windows-spezifische Initialisierung
}

Future<void> _initializeAndroid() async {
  logger.info('Initializing Android specific features');
  // Hier später Android-spezifische Initialisierung
}

class AudiobookMemeReader extends StatelessWidget {
  const AudiobookMemeReader({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        // Platform specific theme adjustments
        platform: PlatformUtils.isWindows 
          ? TargetPlatform.windows 
          : TargetPlatform.android,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        platform: PlatformUtils.isWindows 
          ? TargetPlatform.windows 
          : TargetPlatform.android,
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
      builder: (context, child) {
        // Platform specific UI adjustments
        Widget finalWidget = child!;
        
        if (PlatformUtils.isMobile) {
          finalWidget = ScrollConfiguration(
            behavior: ScrollBehavior().copyWith(overscroll: false),
            child: finalWidget,
          );
        }
        
        return finalWidget;
      },
    );
  }
}
