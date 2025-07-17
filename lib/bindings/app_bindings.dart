import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/tasks/data/datasources/task_local_datasource.dart';
import '../features/tasks/data/datasources/task_local_datasource_impl.dart';
import '../features/tasks/data/repositories/task_repository_impl.dart';
import '../features/tasks/domain/repositories/task_repository.dart';
import '../features/tasks/domain/usecases/add_task_usecase.dart';
import '../features/tasks/domain/usecases/delete_task_usecase.dart';
import '../features/tasks/domain/usecases/get_all_tasks_usecase.dart';
import '../features/tasks/domain/usecases/toggle_task_status_usecase.dart';
import '../features/tasks/domain/usecases/update_task_usecase.dart';
import '../features/tasks/presentation/controllers/task_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // External dependencies - Initialize SharedPreferences first
    _initializeSharedPreferences();
  }

  void _initializeSharedPreferences() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.put<SharedPreferences>(sharedPreferences);

    // Initialize other dependencies after SharedPreferences is ready
    _initializeDependencies();
  }

  void _initializeDependencies() {
    // Data sources
    Get.lazyPut<TaskLocalDatasource>(
          () => TaskLocalDatasourceImpl(
        sharedPreferences: Get.find<SharedPreferences>(),
      ),
    );

    // Repositories
    Get.lazyPut<TaskRepository>(
          () => TaskRepositoryImpl(
        localDatasource: Get.find<TaskLocalDatasource>(),
      ),
    );

    // Use cases
    Get.lazyPut(() => GetAllTasksUsecase(Get.find<TaskRepository>()));
    Get.lazyPut(() => AddTaskUsecase(Get.find<TaskRepository>()));
    Get.lazyPut(() => UpdateTaskUsecase(Get.find<TaskRepository>()));
    Get.lazyPut(() => DeleteTaskUsecase(Get.find<TaskRepository>()));
    Get.lazyPut(() => ToggleTaskStatusUsecase(Get.find<TaskRepository>()));

    // Controllers
    Get.put(
      TaskController(
        getAllTasksUsecase: Get.find<GetAllTasksUsecase>(),
        addTaskUsecase: Get.find<AddTaskUsecase>(),
        updateTaskUsecase: Get.find<UpdateTaskUsecase>(),
        deleteTaskUsecase: Get.find<DeleteTaskUsecase>(),
        toggleTaskStatusUsecase: Get.find<ToggleTaskStatusUsecase>(),
      ),
    );
  }
}