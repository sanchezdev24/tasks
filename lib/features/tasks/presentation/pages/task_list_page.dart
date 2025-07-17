import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../controllers/task_controller.dart';
import '../widgets/add_task_fab.dart';
import '../widgets/task_list_widget.dart';

class TaskListPage extends StatelessWidget {
  final TaskController controller = Get.find<TaskController>();

  TaskListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Tareas'),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
        actions: [
          PopupMenuButton<TaskFilter>(
            icon: Icon(Icons.filter_list),
            onSelected: (filter) => controller.setFilter(filter),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: TaskFilter.all,
                child: Row(
                  children: [
                    Icon(Icons.list, size: 20),
                    SizedBox(width: 8),
                    Text('Todas'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: TaskFilter.pending,
                child: Row(
                  children: [
                    Icon(Icons.schedule, size: 20),
                    SizedBox(width: 8),
                    Text('Pendientes'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: TaskFilter.completed,
                child: Row(
                  children: [
                    Icon(Icons.check_circle, size: 20),
                    SizedBox(width: 8),
                    Text('Completadas'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.loadTasks(),
        color: AppColors.primaryColor,
        child: Column(
          children: [
            _buildStatsHeader(),
            _buildSearchBar(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading && controller.allTasks.isEmpty) {
                  return LoadingWidget(message: 'Cargando tareas...');
                }

                return TaskListWidget();
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: AddTaskFab(),
    );
  }

  Widget _buildStatsHeader() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Total',
                  controller.totalTasks.toString(),
                  Icons.list_alt,
                  AppColors.primaryColor,
                ),
                _buildStatItem(
                  'Pendientes',
                  controller.pendingTasks.toString(),
                  Icons.schedule,
                  AppColors.warningColor,
                ),
                _buildStatItem(
                  'Completadas',
                  controller.completedTasks.toString(),
                  Icons.check_circle,
                  AppColors.successColor,
                ),
              ],
            ),
            if (controller.totalTasks > 0) ...[
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progreso',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryColor,
                        ),
                      ),
                      Text(
                        '${controller.completionPercentage.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 800),
                    tween: Tween(begin: 0, end: controller.completionPercentage / 100),
                    builder: (context, value, child) {
                      return LinearProgressIndicator(
                        value: value,
                        backgroundColor: AppColors.textLightColor.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                        minHeight: 6,
                      );
                    },
                  ),
                ],
              ),
            ],
          ],
        );
      }),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        onChanged: (value) => controller.setSearchQuery(value),
        decoration: InputDecoration(
          hintText: 'Buscar tareas...',
          prefixIcon: Icon(Icons.search),
          filled: true,
          fillColor: Theme.of(Get.context!).cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}