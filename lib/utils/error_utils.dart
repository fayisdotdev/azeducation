import 'package:flutter/foundation.dart';

/// Maps technical errors to user-friendly messages for UI display.
String getFriendlyErrorMessage(Object error) {
  final msg = error.toString();
  if (msg.contains('SocketException')) {
    return 'No internet connection. Please check your network.';
  }
  if (msg.contains('permission denied')) {
    return 'You do not have permission to perform this action.';
  }
  if (msg.contains('timeout')) {
    return 'The request timed out. Please try again.';
  }
  if (msg.contains('SupabaseException')) {
    return 'A server error occurred. Please try again later.';
  }
  // Add more mappings as needed
  return 'Something went wrong. Please try again.';
}

/// Logs technical error details for developers (terminal/debug console).
void logError(Object error, [StackTrace? stackTrace, String? context]) {
  debugPrint('ERROR${context != null ? ' ($context)' : ''}: $error');
  if (stackTrace != null) debugPrint(stackTrace.toString());
}
