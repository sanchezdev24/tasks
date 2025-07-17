import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../models/task_model.dart';

abstract class TaskLocalDatasource {
  Future<Either<Failure, List<TaskModel>>> getAllTasks();
  Future<Either<Failure, TaskModel>> getTaskById(String id);
  Future<Either<Failure, void>> saveTasks(List<TaskModel> tasks);
  Future<Either<Failure, void>> addTask(TaskModel task);
  Future<Either<Failure, void>> updateTask(TaskModel task);
  Future<Either<Failure, void>> deleteTask(String id);
}