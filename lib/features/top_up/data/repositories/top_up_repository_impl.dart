import 'package:dartz/dartz.dart';
import 'package:etest/features/top_up/data/models/beneficiary.dart';
import 'package:etest/features/top_up/data/models/transaction.dart';
import 'package:etest/features/top_up/domain/entities/transaction_entity.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/beneficiary_entity.dart';
import '../../domain/repositories/top_up_repository.dart';
import '../datasources/top_up_local_data_source.dart';
import '../datasources/top_up_remote_data_source.dart';

class TopUpRepositoryImpl implements TopUpRepository {
  final TopUpRemoteDataSource remoteDataSource;
  final TopUpLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TopUpRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, List<BeneficiaryEntity>>> getBeneficiaries() async {
    if (await networkInfo.isConnected) {
      try {
        //we can change local, remote or any other data source
        // final remoteBeneficiaries = await remoteDataSource.getCachedBeneficiaries();
        final localBeneficiaries =
            await localDataSource.getCachedBeneficiaries();
        return Right(localBeneficiaries);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      //No internet
      try {
        final localBeneficiaries =
            await localDataSource.getCachedBeneficiaries();
        return Right(localBeneficiaries);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> addBeneficiary(
      BeneficiaryEntity beneficiaryEntity) async {
    final BeneficiaryModel beneficiaryModel = BeneficiaryModel(
        name: beneficiaryEntity.name,
        phone: beneficiaryEntity.phone,
        id: beneficiaryEntity.id);

    if (await networkInfo.isConnected) {
      try {
        await localDataSource.addBeneficiary(beneficiaryModel);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteBeneficiary(String? beneficiaryId) async {
    if (await networkInfo.isConnected) {
      try {
        await localDataSource.deleteBeneficiary(beneficiaryId);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addTransaction(TransactionEntity transactionEntity) async{
    final TransactionModel transactionModel = TransactionModel(
        date: transactionEntity.date,
        amount: transactionEntity.amount,
        beneficiaryId: transactionEntity.beneficiaryId,
        id: transactionEntity.id);

    if (await networkInfo.isConnected) {
      try {
        await localDataSource.addTransaction(transactionModel);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactions()async {
    if (await networkInfo.isConnected) {
      try {
        //we can change local, remote or any other data source
        // final remoteTransactions = await remoteDataSource.getTransactions();
        final localTransactions =
            await localDataSource.getCachedTransactions();
        return Right(localTransactions);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      //No internet
      try {
        final localTransactions =
            await localDataSource.getCachedTransactions();
        return Right(localTransactions);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }
}
