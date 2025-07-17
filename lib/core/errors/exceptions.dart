abstract class AppException implements Exception {
  final String message;
  final int? code;

  const AppException(this.message, {this.code});
}

class CacheException extends AppException {
  const CacheException(String message) : super(message);
}

class ValidationException extends AppException {
  const ValidationException(String message) : super(message);
}

class DuplicateTaskException extends AppException {
  const DuplicateTaskException(String message) : super(message);
}

class TaskNotFoundException extends AppException {
  const TaskNotFoundException(String message) : super(message);
}