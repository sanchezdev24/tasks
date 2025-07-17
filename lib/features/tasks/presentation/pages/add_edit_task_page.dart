import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../domain/entities/task_entity.dart';
import '../controllers/task_controller.dart';

class AddEditTaskPage extends StatefulWidget {
  final TaskEntity? task;

  const AddEditTaskPage({Key? key, this.task}) : super(key: key);

  @override
  State<AddEditTaskPage> createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final TaskController _taskController = Get.find<TaskController>();

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  int _selectedPriority = 2; // Medium priority by default
  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    if (_isEditing) {
      _nameController.text = widget.task!.name;
      _descriptionController.text = widget.task!.description ?? '';
      _selectedPriority = widget.task!.priority;
    }

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Tarea' : 'Nueva Tarea'),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildFormCard(),
                      SizedBox(height: 24),
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información de la Tarea',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CustomTextField(
              label: 'Nombre de la tarea *',
              hint: 'Ingresa el nombre de la tarea',
              controller: _nameController,
              validator: Validators.validateTaskName,
              prefixIcon: Icons.task_alt,
              autofocus: !_isEditing,
            ),
            SizedBox(height: 16),
            CustomTextField(
              label: 'Descripción (opcional)',
              hint: 'Describe los detalles de la tarea',
              controller: _descriptionController,
              validator: Validators.validateTaskDescription,
              prefixIcon: Icons.description,
              maxLines: 3,
              maxLength: 200,
            ),
            SizedBox(height: 20),
            _buildPrioritySelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prioridad',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        SizedBox(height: 12),
        Row(
          children: [
            _buildPriorityChip(1, 'Baja', AppColors.successColor),
            SizedBox(width: 12),
            _buildPriorityChip(2, 'Media', AppColors.warningColor),
            SizedBox(width: 12),
            _buildPriorityChip(3, 'Alta', AppColors.errorColor),
          ],
        ),
      ],
    );
  }

  Widget _buildPriorityChip(int priority, String label, Color color) {
    final isSelected = _selectedPriority == priority;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPriority = priority;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : color,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Obx(() {
      return Column(
        children: [
          CustomButton(
            text: _isEditing ? 'Actualizar Tarea' : 'Crear Tarea',
            onPressed: _taskController.isLoading ? null : _handleSubmit,
            isLoading: _taskController.isLoading,
            icon: _isEditing ? Icons.update : Icons.add,
          ),
          if (_isEditing) ...[
            SizedBox(height: 12),
            CustomButton(
              text: 'Eliminar Tarea',
              onPressed: _taskController.isLoading ? null : _handleDelete,
              isSecondary: true,
              icon: Icons.delete,
            ),
          ],
        ],
      );
    });
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      if (_isEditing) {
        final updatedTask = widget.task!.copyWith(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          priority: _selectedPriority,
        );
        await _taskController.updateTask(updatedTask);
      } else {
        await _taskController.addTask(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          priority: _selectedPriority,
        );
      }

      if (_taskController.errorMessage.isEmpty) {
        Get.back();
      }
    }
  }

  void _handleDelete() {
    Get.dialog(
      AlertDialog(
        title: Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de que quieres eliminar esta tarea?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await _taskController.deleteTask(widget.task!.id);
              if (_taskController.errorMessage.isEmpty) {
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorColor,
            ),
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}