import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class TaskStatusToggle extends StatefulWidget {
  final bool isCompleted;
  final VoidCallback onToggle;

  const TaskStatusToggle({
    Key? key,
    required this.isCompleted,
    required this.onToggle,
  }) : super(key: key);

  @override
  State<TaskStatusToggle> createState() => _TaskStatusToggleState();
}

class _TaskStatusToggleState extends State<TaskStatusToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isCompleted) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(TaskStatusToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCompleted != oldWidget.isCompleted) {
      if (widget.isCompleted) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onToggle();
        // Animation will be triggered by didUpdateWidget
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value * 0.1,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isCompleted
                      ?   AppColors.successColor
                      : Colors.transparent,
                  border: Border.all(
                    color: widget.isCompleted
                        ? AppColors.successColor
                        : AppColors.textLightColor,
                    width: 2,
                  ),
                ),
                child: widget.isCompleted
                    ? Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.white,
                )
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}