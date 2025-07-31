import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks/core/utils/extensions.dart';
import 'package:tasks/features/tasks/presentation/widgets/task_status_toggle.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/task_entity.dart';
import '../controllers/task_controller.dart';
import '../pages/add_edit_task_page.dart';

class TaskItemWidget extends StatelessWidget {
  final TaskEntity task;
  final int index;
  final TaskController controller = Get.find<TaskController>();

  TaskItemWidget({
    Key? key,
    required this.task,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Dismissible(
                key: Key(task.id),
                direction: DismissDirection.endToStart,
                background: _buildDismissBackground(),
                confirmDismiss: (direction) => _confirmDelete(),
                onDismissed: (direction) async {
                  await controller.deleteTask(task.id);
                },
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () => _navigateToEdit(),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: task.isCompleted
                            ? LinearGradient(
                          colors: [
                            AppColors.successColor.withOpacity(0.1),
                            AppColors.successColor.withOpacity(0.05),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                            : null,
                      ),
                      child: Row(
                        children: [
                          TaskStatusToggle(
                            isCompleted: task.isCompleted,
                            onToggle: () => controller.toggleTaskStatus(task.id),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.name,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    decoration: task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: task.isCompleted
                                        ? AppColors.textSecondaryColor
                                        : null,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (task.description?.isNotEmpty == true) ...[
                                  SizedBox(height: 4),
                                  Text(
                                    task.description!,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: task.isCompleted
                                          ? AppColors.textLightColor
                                          : AppColors.textSecondaryColor,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    _buildPriorityChip(),
                                    Spacer(),
                                    Text(
                                      task.createdAt.timeAgo,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.textLightColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: AppColors.textLightColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPriorityChip() {
    Color color;
    String text;
    IconData icon;

    switch (task.priority) {
      case 1:
        color = AppColors.successColor;
        text = 'Baja';
        icon = Icons.keyboard_arrow_down;
        break;
      case 3:
        color = AppColors.errorColor;
        text = 'Alta';
        icon = Icons.keyboard_arrow_up;
        break;
      default:
        color = AppColors.warningColor;
        text = 'Media';
        icon = Icons.remove;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.errorColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delete, color: Colors.white, size: 32),
          SizedBox(height: 4),
          Text(
            'Eliminar',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _confirmDelete() {
    return Get.dialog<bool>(
      AlertDialog(
        title: Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de que quieres eliminar "${task.name}"?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorColor,
            ),
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _navigateToEdit() {
    Get.to(
      () => AddEditTaskPage(task: task),
      transition: Transition.rightToLeft,
      duration: Duration(milliseconds: 300),
    );
  }
}