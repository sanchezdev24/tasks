class AppConstants {
  static const String appName = 'Task App';
  static const String tasksKey = 'tasks_key';
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration staggerDelay = Duration(milliseconds: 100);

  // Validation
  static const int maxTaskNameLength = 50;
  static const int minTaskNameLength = 3;

  // Storage
  static const String tasksStorageKey = 'user_tasks';
}