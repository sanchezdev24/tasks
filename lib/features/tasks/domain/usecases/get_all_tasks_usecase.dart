import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class GetAllTasksUsecase {
  final TaskRepository repository;

  GetAllTasksUsecase(this.repository);

  Future<Either<Failure, List<TaskEntity>>> call() async {
    return await repository.getAllTasks();
  }
}