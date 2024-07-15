import 'package:etest/features/auth/domain/usecases/add_fund.dart';
import 'package:etest/features/auth/domain/usecases/update_verification.dart';
import 'package:etest/features/top_up/data/repositories/top_up_repository_impl.dart';
import 'package:etest/features/top_up/domain/repositories/top_up_repository.dart';
import 'package:etest/features/top_up/domain/usecases/beneficiary/add_beneficy.dart';
import 'package:etest/features/top_up/domain/usecases/beneficiary/delete_beneficy.dart';
import 'package:etest/features/top_up/domain/usecases/beneficiary/get_beneficiars.dart';
import 'package:etest/features/top_up/domain/usecases/top_up/add_transaction.dart';
import 'package:etest/features/top_up/domain/usecases/top_up/get_transactions.dart';
import 'package:etest/features/top_up/presentation/bloc/beneficiary/beneficiary_bloc.dart';
import 'package:etest/features/top_up/presentation/bloc/top_up/top_up_bloc.dart';

import 'core/network/network_info.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_user.dart';
import 'features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/top_up/data/datasources/top_up_local_data_source.dart';
import 'features/top_up/data/datasources/top_up_remote_data_source.dart';

final sl = GetIt.instance;

Future<void> init() async {
//! Features - auth

  /// Bloc

  sl.registerFactory(
      () => AuthBloc(getUser: sl(), addFund: sl(), updateVerification: sl()));
  sl.registerFactory(() => BeneficiaryBloc(
      addBeneficiary: sl(), deleteBeneficiary: sl(), getBeneficiaries: sl()));
  sl.registerFactory(
      () => TopUpBloc(addTransaction: sl(), getTransactions: sl()));

  /// Usecases
  //Auth
  sl.registerLazySingleton(() => GetUserUsecase(sl()));
  sl.registerLazySingleton(() => AddFundUsecase(sl()));
  sl.registerLazySingleton(() => UpdateVerificationUsecase(sl()));

  //Beneficiary
  sl.registerLazySingleton(() => AddBeneficiaryUsecase(sl()));
  sl.registerLazySingleton(() => DeleteBeneficiaryUsecase(sl()));
  sl.registerLazySingleton(() => GetBeneficiariesUsecase(sl()));

  //Transaction
  sl.registerLazySingleton(() => AddTransactionUsecase(sl()));
  sl.registerLazySingleton(() => GetTransactionsUsecase(sl()));

  /// Repository

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
      remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));
  sl.registerLazySingleton<TopUpRepository>(() => TopUpRepositoryImpl(
      localDataSource: sl(), networkInfo: sl(), remoteDataSource: sl()));

  /// Datasources

  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(sharedPreferences: sl()));

  sl.registerLazySingleton<TopUpRemoteDataSource>(
      () => TopUpRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<TopUpLocalDataSource>(
      () => TopUpLocalDataSourceImpl(sharedPreferences: sl()));

  ///! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  ///! External

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
