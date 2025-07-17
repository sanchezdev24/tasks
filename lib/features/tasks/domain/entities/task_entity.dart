import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;
  final int priority; // 1: Low, 2: Medium, 3: High

  const TaskEntity({
    required this.id,
    required this.name,
    this.description,
    required this.isCompleted,
    required this.createdAt,
    this.completedAt,
    this.priority = 2,
  });

  TaskEntity copyWith({
    String? id,
    String? name,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
    int? priority,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      priority: priority ?? this.priority,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    isCompleted,
    createdAt,
    completedAt,
    priority,
  ];
}