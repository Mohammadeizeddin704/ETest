import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, UserEntity>> getUser() async {
    if (await networkInfo.isConnected) {
      try {
        //we can change local, remote or any other data source
        // final remoteUser = await remoteDataSource.getUser();
        final localUser = await localDataSource.getCachedUser();
        return Right(localUser);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      //No internet
      try {
        final localUser = await localDataSource.getCachedUser();
        return Right(localUser);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> addFund(double amount) async {
    if (await networkInfo.isConnected) {
      try {
        await localDataSource.addFund(amount);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateVerification(bool isVerified) async {
    if (await networkInfo.isConnected) {
      try {
        await localDataSource.updateVerification(isVerified);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
