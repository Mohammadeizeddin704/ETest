import 'package:etest/features/top_up/domain/entities/transaction_entity.dart';

import '../entities/beneficiary_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class TopUpRepository {
  ///Beneficiary
  Future<Either<Failure, List<BeneficiaryEntity>>> getBeneficiaries();

  Future<Either<Failure, Unit>> addBeneficiary(
      BeneficiaryEntity beneficiaryEntity);

  Future<Either<Failure, Unit>> deleteBeneficiary(String? beneficiaryId);

  ///TopUp
  Future<Either<Failure, List<TransactionEntity>>> getTransactions();

  Future<Either<Failure, Unit>> addTransaction(
      TransactionEntity transactionEntity);
}
