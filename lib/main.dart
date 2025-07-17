import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasks/routes/app_pages.dart';
import 'package:tasks/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/tasks/data/datasources/task_local_datasource.dart';
import 'features/tasks/data/datasources/task_local_datasource_impl.dart';
import 'features/tasks/data/repositories/task_repository_impl.dart';
import 'features/tasks/domain/repositories/task_repository.dart';
import 'features/tasks/domain/usecases/add_task_usecase.dart';
import 'features/tasks/domain/usecases/delete_task_usecase.dart';
import 'features/tasks/domain/usecases/get_all_tasks_usecase.dart';
import 'features/tasks/domain/usecases/toggle_task_status_usecase.dart';
import 'features/tasks/domain/usecases/update_task_usecase.dart';
import 'features/tasks/presentation/controllers/task_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences first
  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize dependencies manually
  await initializeDependencies(sharedPreferences);

  runApp(MyApp());
}

Future<void> initializeDependencies(SharedPreferences sharedPreferences) async {
  // Put SharedPreferences
  Get.put<SharedPreferences>(sharedPreferences);

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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Task App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.taskList,
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
    );
  }
}