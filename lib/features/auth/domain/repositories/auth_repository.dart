import '../entities/user_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> getUser();
  Future<Either<Failure, Unit>> addFund(double amount);
  Future<Either<Failure, Unit>> updateVerification(bool isVerified);
}
