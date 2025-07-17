import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks/features/tasks/presentation/widgets/task_item_widget.dart';
import '../../../../core/widgets/animated_list_item.dart';
import '../controllers/task_controller.dart';

class TaskListWidget extends StatelessWidget {
  final TaskController controller = Get.find<TaskController>();

  TaskListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.filteredTasks.isEmpty) {
        return _buildEmptyState();
      }

      return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: controller.filteredTasks.length,
        itemBuilder: (context, index) {
          final task = controller.filteredTasks[index];
          return AnimatedListItem(
            index: index,
            child: TaskItemWidget(
              task: task,
              index: index,
            ),
          );
        },
      );
    });
  }

  Widget _buildEmptyState() {
    String message;
    IconData icon;

    switch (controller.currentFilter) {
      case TaskFilter.pending:
        message = 'No tienes tareas pendientes';
        icon = Icons.check_circle_outline;
        break;
      case TaskFilter.completed:
        message = 'No tienes tareas completadas';
        icon = Icons.assignment_turned_in;
        break;
      default:
        if (controller.searchQuery.isNotEmpty) {
          message = 'No se encontraron tareas con "${controller.searchQuery}"';
          icon = Icons.search_off;
        } else {
          message = 'No tienes tareas aún';
          icon = Icons.task_alt;
        }
    }

    return Center(
      child: TweenAnimationBuilder<double>(
        duration: Duration(milliseconds: 600),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Opacity(
              opacity: value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (controller.searchQuery.isEmpty &&
                      controller.currentFilter == TaskFilter.all) ...[
                    SizedBox(height: 8),
                    Text(
                      'Toca el botón + para crear tu primera tarea',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}