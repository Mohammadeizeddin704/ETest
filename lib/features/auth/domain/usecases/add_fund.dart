import 'package:dartz/dartz.dart';
import 'package:etest/features/auth/domain/repositories/auth_repository.dart';
import '../../../../../core/error/failures.dart';

class AddFundUsecase {
  final AuthRepository repository;

  AddFundUsecase(this.repository);

  Future<Either<Failure, Unit>> call(double amount) async {
    return await repository.addFund(amount);
  }
}
