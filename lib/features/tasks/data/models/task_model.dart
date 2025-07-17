import 'dart:convert';
import '../../domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required String id,
    required String name,
    String? description,
    required bool isCompleted,
    required DateTime createdAt,
    DateTime? completedAt,
    int priority = 2,
  }) : super(
    id: id,
    name: name,
    description: description,
    isCompleted: isCompleted,
    createdAt: createdAt,
    completedAt: completedAt,
    priority: priority,
  );

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      isCompleted: entity.isCompleted,
      createdAt: entity.createdAt,
      completedAt: entity.completedAt,
      priority: entity.priority,
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      isCompleted: json['isCompleted'],
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      priority: json['priority'] ?? 2,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'priority': priority,
    };
  }

  static List<TaskModel> fromJsonList(String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => TaskModel.fromJson(json)).toList();
  }

  static String toJsonList(List<TaskModel> tasks) {
    final List<Map<String, dynamic>> jsonList =
    tasks.map((task) => task.toJson()).toList();
    return json.encode(jsonList);
  }
}