import '../../repositories/top_up_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../entities/beneficiary_entity.dart';

class AddBeneficiaryUsecase {
  final TopUpRepository repository;

  AddBeneficiaryUsecase(this.repository);

  Future<Either<Failure, Unit>> call(
      BeneficiaryEntity beneficiaryEntity) async {
    return await repository.addBeneficiary(beneficiaryEntity);
  }
}
