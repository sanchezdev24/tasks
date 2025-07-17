import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

class DuplicateTaskFailure extends Failure {
  const DuplicateTaskFailure(String message) : super(message);
}

class TaskNotFoundFailure extends Failure {
  const TaskNotFoundFailure(String message) : super(message);
}