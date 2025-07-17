import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasks/features/tasks/data/datasources/task_local_datasource.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../models/task_model.dart';

class TaskLocalDatasourceImpl implements TaskLocalDatasource {
  final SharedPreferences sharedPreferences;

  TaskLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<Either<Failure, List<TaskModel>>> getAllTasks() async {
    try {
      final jsonString = sharedPreferences.getString(AppConstants.tasksStorageKey);
      if (jsonString != null) {
        final tasks = TaskModel.fromJsonList(jsonString);
        return Right(tasks);
      }
      return Right([]);
    } catch (e) {
      return Left(CacheFailure('Error al obtener las tareas: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, TaskModel>> getTaskById(String id) async {
    try {
      final tasksResult = await getAllTasks();
      return tasksResult.fold(
            (failure) => Left(failure),
            (tasks) {
          final task = tasks.firstWhere(
                (task) => task.id == id,
            orElse: () => throw TaskNotFoundException('Tarea no encontrada'),
          );
          return Right(task);
        },
      );
    } on TaskNotFoundException catch (e) {
      return Left(TaskNotFoundFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Error al obtener la tarea: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> saveTasks(List<TaskModel> tasks) async {
    try {
      final jsonString = TaskModel.toJsonList(tasks);
      await sharedPreferences.setString(AppConstants.tasksStorageKey, jsonString);
      return Right(null);
    } catch (e) {
      return Left(CacheFailure('Error al guardar las tareas: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> addTask(TaskModel task) async {
    try {
      final tasksResult = await getAllTasks();
      return tasksResult.fold(
            (failure) => Left(failure),
            (tasks) async {
          // Validar nombre único
          final duplicateExists = tasks.any(
                (existingTask) => existingTask.name.toLowerCase() == task.name.toLowerCase(),
          );

          if (duplicateExists) {
            return Left(DuplicateTaskFailure('Ya existe una tarea con este nombre'));
          }

          tasks.add(task);
          return await saveTasks(tasks);
        },
      );
    } catch (e) {
      return Left(CacheFailure('Error al agregar la tarea: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateTask(TaskModel task) async {
    try {
      final tasksResult = await getAllTasks();
      return tasksResult.fold(
            (failure) => Left(failure),
            (tasks) async {
          // Validar nombre único (excluyendo la tarea actual)
          final duplicateExists = tasks.any(
                (existingTask) =>
            existingTask.id != task.id &&
                existingTask.name.toLowerCase() == task.name.toLowerCase(),
          );

          if (duplicateExists) {
            return Left(DuplicateTaskFailure('Ya existe una tarea con este nombre'));
          }

          final index = tasks.indexWhere((t) => t.id == task.id);
          if (index == -1) {
            return Left(TaskNotFoundFailure('Tarea no encontrada'));
          }

          tasks[index] = task;
          return await saveTasks(tasks);
        },
      );
    } catch (e) {
      return Left(CacheFailure('Error al actualizar la tarea: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    try {
      final tasksResult = await getAllTasks();
      return tasksResult.fold(
            (failure) => Left(failure),
            (tasks) async {
          final initialLength = tasks.length;
          tasks.removeWhere((task) => task.id == id);

          if (tasks.length == initialLength) {
            return Left(TaskNotFoundFailure('Tarea no encontrada'));
          }

          return await saveTasks(tasks);
        },
      );
    } catch (e) {
      return Left(CacheFailure('Error al eliminar la tarea: ${e.toString()}'));
    }
  }
}