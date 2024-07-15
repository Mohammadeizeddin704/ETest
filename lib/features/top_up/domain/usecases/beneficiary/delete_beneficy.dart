import '../../repositories/top_up_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';

class DeleteBeneficiaryUsecase {
  final TopUpRepository repository;

  DeleteBeneficiaryUsecase(this.repository);

  Future<Either<Failure, Unit>> call(
      String? beneficiaryId) async {
    return await repository.deleteBeneficiary(beneficiaryId);
  }
}
