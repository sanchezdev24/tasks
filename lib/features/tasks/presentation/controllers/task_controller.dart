import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/usecases/add_task_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/get_all_tasks_usecase.dart';
import '../../domain/usecases/toggle_task_status_usecase.dart';
import '../../domain/usecases/update_task_usecase.dart';

enum TaskFilter { all, pending, completed }

class TaskController extends GetxController {
  final GetAllTasksUsecase getAllTasksUsecase;
  final AddTaskUsecase addTaskUsecase;
  final UpdateTaskUsecase updateTaskUsecase;
  final DeleteTaskUsecase deleteTaskUsecase;
  final ToggleTaskStatusUsecase toggleTaskStatusUsecase;

  TaskController({
    required this.getAllTasksUsecase,
    required this.addTaskUsecase,
    required this.updateTaskUsecase,
    required this.deleteTaskUsecase,
    required this.toggleTaskStatusUsecase,
  });

  // Observables
  final RxList<TaskEntity> _allTasks = <TaskEntity>[].obs;
  final RxList<TaskEntity> _filteredTasks = <TaskEntity>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final Rx<TaskFilter> _currentFilter = TaskFilter.all.obs;
  final RxString _searchQuery = ''.obs;

  // Getters
  List<TaskEntity> get allTasks => _allTasks;
  List<TaskEntity> get filteredTasks => _filteredTasks;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  TaskFilter get currentFilter => _currentFilter.value;
  String get searchQuery => _searchQuery.value;

  // Statistics
  int get totalTasks => _allTasks.length;
  int get completedTasks => _allTasks.where((task) => task.isCompleted).length;
  int get pendingTasks => _allTasks.where((task) => !task.isCompleted).length;
  double get completionPercentage =>
      totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0.0;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  Future<void> loadTasks() async {
    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await getAllTasksUsecase();
    result.fold(
          (failure) {
        _errorMessage.value = _getFailureMessage(failure);
        _isLoading.value = false;
      },
          (tasks) {
        _allTasks.value = tasks;
        _applyFiltersAndSearch();
        _isLoading.value = false;
      },
    );
  }

  Future<void> addTask({
    required String name,
    String? description,
    int priority = 2,
  }) async {
    _isLoading.value = true;

    final task = TaskEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      description: description?.trim(),
      isCompleted: false,
      createdAt: DateTime.now(),
      priority: priority,
    );

    final result = await addTaskUsecase(task);
    result.fold(
          (failure) {
        _errorMessage.value = _getFailureMessage(failure);
        Get.snackbar(
          'Error',
          _errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
          (_) {
        Get.snackbar(
          'Éxito',
          'Tarea agregada correctamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        loadTasks();
      },
    );

    _isLoading.value = false;
  }

  Future<void> updateTask(TaskEntity updatedTask) async {
    _isLoading.value = true;

    final result = await updateTaskUsecase(updatedTask);
    result.fold(
          (failure) {
        _errorMessage.value = _getFailureMessage(failure);
        Get.snackbar(
          'Error',
          _errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
          (_) {
        Get.snackbar(
          'Éxito',
          'Tarea actualizada correctamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        loadTasks();
      },
    );

    _isLoading.value = false;
  }

  Future<void> deleteTask(String id) async {
    final result = await deleteTaskUsecase(id);
    result.fold(
          (failure) {
        _errorMessage.value = _getFailureMessage(failure);
        Get.snackbar(
          'Error',
          _errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
          (_) {
        Get.snackbar(
          'Éxito',
          'Tarea eliminada correctamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        loadTasks();
      },
    );
  }

  Future<void> toggleTaskStatus(String id) async {
    final result = await toggleTaskStatusUsecase(id);
    result.fold(
          (failure) {
        _errorMessage.value = _getFailureMessage(failure);
        Get.snackbar(
          'Error',
          _errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
          (_) {
        loadTasks();
      },
    );
  }

  void setFilter(TaskFilter filter) {
    _currentFilter.value = filter;
    _applyFiltersAndSearch();
  }

  void setSearchQuery(String query) {
    _searchQuery.value = query;
    _applyFiltersAndSearch();
  }

  void _applyFiltersAndSearch() {
    List<TaskEntity> filtered = List.from(_allTasks);

    // Apply filter
    switch (_currentFilter.value) {
      case TaskFilter.pending:
        filtered = filtered.where((task) => !task.isCompleted).toList();
        break;
      case TaskFilter.completed:
        filtered = filtered.where((task) => task.isCompleted).toList();
        break;
      case TaskFilter.all:
        break;
    }

    // Apply search
    if (_searchQuery.value.isNotEmpty) {
      filtered = filtered.where((task) {
        return task.name.toLowerCase().contains(_searchQuery.value.toLowerCase()) ||
            (task.description?.toLowerCase().contains(_searchQuery.value.toLowerCase()) ?? false);
      }).toList();
    }

    // Sort by priority and creation date
    filtered.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      if (a.priority != b.priority) {
        return b.priority.compareTo(a.priority);
      }
      return b.createdAt.compareTo(a.createdAt);
    });

    _filteredTasks.value = filtered;
  }

  String _getFailureMessage(Failure failure) {
    switch (failure.runtimeType) {
      case DuplicateTaskFailure:
        return failure.message;
      case ValidationFailure:
        return failure.message;
      case TaskNotFoundFailure:
        return failure.message;
      case CacheFailure:
        return 'Error de almacenamiento local';
      default:
        return 'Ha ocurrido un error inesperado';
    }
  }

  void clearError() {
    _errorMessage.value = '';
  }
}