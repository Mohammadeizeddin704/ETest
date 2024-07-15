import '../repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

class GetUserUsecase {
  final AuthRepository repository;

  GetUserUsecase(this.repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.getUser();
  }
}
