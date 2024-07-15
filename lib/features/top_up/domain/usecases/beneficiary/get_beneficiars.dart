import '../../repositories/top_up_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../entities/beneficiary_entity.dart';

class GetBeneficiariesUsecase {
  final TopUpRepository repository;

  GetBeneficiariesUsecase(this.repository);

  Future<Either<Failure, List<BeneficiaryEntity>>> call() async {
    return await repository.getBeneficiaries();
  }
}
