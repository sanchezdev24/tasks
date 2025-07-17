import '../constants/app_constants.dart';

class Validators {
  static String? validateTaskName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre de la tarea es requerido';
    }

    if (value.length < AppConstants.minTaskNameLength) {
      return 'El nombre debe tener al menos ${AppConstants.minTaskNameLength} caracteres';
    }

    if (value.length > AppConstants.maxTaskNameLength) {
      return 'El nombre no puede exceder ${AppConstants.maxTaskNameLength} caracteres';
    }

    return null;
  }

  static String? validateTaskDescription(String? value) {
    if (value != null && value.length > 200) {
      return 'La descripción no puede exceder 200 caracteres';
    }
    return null;
  }
}