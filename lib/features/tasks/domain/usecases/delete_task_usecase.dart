import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/task_repository.dart';

class DeleteTaskUsecase {
  final TaskRepository repository;

  DeleteTaskUsecase(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteTask(id);
  }
}