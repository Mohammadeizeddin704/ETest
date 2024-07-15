import 'package:etest/features/top_up/domain/entities/transaction_entity.dart';

import '../../repositories/top_up_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';

class AddTransactionUsecase {
  final TopUpRepository repository;

  AddTransactionUsecase(this.repository);

  Future<Either<Failure, Unit>> call(
      TransactionEntity transactionEntity) async {
    return await repository.addTransaction(transactionEntity);
  }
}
