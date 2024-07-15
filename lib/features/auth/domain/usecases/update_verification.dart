import 'package:dartz/dartz.dart';
import 'package:etest/features/auth/domain/repositories/auth_repository.dart';
import '../../../../../core/error/failures.dart';

class UpdateVerificationUsecase {
  final AuthRepository repository;

  UpdateVerificationUsecase(this.repository);

  Future<Either<Failure, Unit>> call(bool isVerified) async {
    return await repository.updateVerification(isVerified);
  }
}
