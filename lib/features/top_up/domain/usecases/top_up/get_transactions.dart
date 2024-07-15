import 'package:etest/features/top_up/domain/entities/transaction_entity.dart';

import '../../repositories/top_up_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';

class GetTransactionsUsecase {
  final TopUpRepository repository;

  GetTransactionsUsecase(this.repository);

  Future<Either<Failure, List<TransactionEntity>>> call() async {
    return await repository.getTransactions();
  }
}
