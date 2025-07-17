import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class AddTaskUsecase {
  final TaskRepository repository;

  AddTaskUsecase(this.repository);

  Future<Either<Failure, void>> call(TaskEntity task) async {
    return await repository.addTask(task);
  }
}