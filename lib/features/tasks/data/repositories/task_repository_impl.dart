import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDatasource localDatasource;

  TaskRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, List<TaskEntity>>> getAllTasks() async {
    final result = await localDatasource.getAllTasks();
    return result.fold(
          (failure) => Left(failure),
          (tasks) => Right(tasks.cast<TaskEntity>()),
    );
  }

  @override
  Future<Either<Failure, TaskEntity>> getTaskById(String id) async {
    final result = await localDatasource.getTaskById(id);
    return result.fold(
          (failure) => Left(failure),
          (task) => Right(task),
    );
  }

  @override
  Future<Either<Failure, void>> addTask(TaskEntity task) async {
    final taskModel = TaskModel.fromEntity(task);
    return await localDatasource.addTask(taskModel);
  }

  @override
  Future<Either<Failure, void>> updateTask(TaskEntity task) async {
    final taskModel = TaskModel.fromEntity(task);
    return await localDatasource.updateTask(taskModel);
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    return await localDatasource.deleteTask(id);
  }

  @override
  Future<Either<Failure, void>> toggleTaskStatus(String id) async {
    final taskResult = await localDatasource.getTaskById(id);
    return taskResult.fold(
          (failure) => Left(failure),
          (task) async {
        final updatedTask = TaskModel.fromEntity(
          task.copyWith(
            isCompleted: !task.isCompleted,
            completedAt: !task.isCompleted ? DateTime.now() : null,
          ),
        );
        return await localDatasource.updateTask(updatedTask);
      },
    );
  }
}