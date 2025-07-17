import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/task_repository.dart';

class ToggleTaskStatusUsecase {
  final TaskRepository repository;

  ToggleTaskStatusUsecase(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.toggleTaskStatus(id);
  }
}