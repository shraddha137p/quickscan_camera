import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      dateTimeFormat: DateTimeFormat.dateAndTime,
    ),
  );

  static void info(String message) {
    _logger.i(message);
  }

  static void debug(String message) {
    _logger.d(message);
  }

  static void warning(String message) {
    _logger.w(message);
  }

  static void error(
      String message, [
        Object? error,
        StackTrace? stackTrace,
      ]) {
    _logger.e(
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void verbose(String message) {
    _logger.t(message);
  }

  static void separator() {
    _logger.i('────────────────────────────────────');
  }
}