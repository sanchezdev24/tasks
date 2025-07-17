import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class UpdateTaskUsecase {
  final TaskRepository repository;

  UpdateTaskUsecase(this.repository);

  Future<Either<Failure, void>> call(TaskEntity task) async {
    return await repository.updateTask(task);
  }
}