
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../constants/app_constants.dart';

class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  late final Logger _logger;
  late final File _logFile;

  // Singleton pattern
  factory AppLogger() => _instance;

  AppLogger._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      output: MultiOutput([
        ConsoleOutput(),
        FileOutput(file: _logFile),
      ]),
    );
  }

  Future<void> initialize() async {
    final appDir = await getApplicationDocumentsDirectory();
    final logDir = Directory('${appDir.path}/${AppConstants.logDir}');
    
    if (!await logDir.exists()) {
      await logDir.create(recursive: true);
    }
    
    _logFile = File('${logDir.path}/${AppConstants.logFile}');
  }

  void debug(String message) => _logger.d(message);
  void info(String message) => _logger.i(message);
  void warning(String message) => _logger.w(message);
  void error(String message, [dynamic error, StackTrace? stackTrace]) => 
      _logger.e(message, error: error, stackTrace: stackTrace);
}
