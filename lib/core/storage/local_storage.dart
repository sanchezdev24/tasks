import 'package:dartz/dartz.dart';

import '../errors/failures.dart';

abstract class LocalStorage {
  Future<Either<Failure, void>> saveString(String key, String value);
  Future<Either<Failure, String?>> getString(String key);
  Future<Either<Failure, void>> remove(String key);
  Future<Either<Failure, void>> clear();
}