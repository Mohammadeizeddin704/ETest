import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:etest/features/top_up/data/models/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/beneficiary.dart';

abstract class TopUpLocalDataSource {
  Future<List<BeneficiaryModel>> getCachedBeneficiaries();

  Future<Unit> addBeneficiary(BeneficiaryModel beneficiaryModel);

  Future<Unit> deleteBeneficiary(String? beneficiaryId);

  Future<Unit> addTransaction(TransactionModel transactionModel);

  Future<List<TransactionModel>> getCachedTransactions();
}

const CACHED_BENEFICIARIES = "CACHED_BENEFICIARIES";
const CACHED_TRANSACTIONS = "CACHED_TRANSACTIONS";

class TopUpLocalDataSourceImpl implements TopUpLocalDataSource {
  final SharedPreferences sharedPreferences;

  TopUpLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<BeneficiaryModel>> getCachedBeneficiaries() async {
    final jsonString = sharedPreferences.getString(CACHED_BENEFICIARIES);
    if (jsonString != null) {
      return (json.decode(jsonString) as List)
          .map((e) => BeneficiaryModel.fromJson(e))
          .toList();
    } else {
      // throw EmptyCacheException();
      return Future.value([]);
    }
  }

  @override
  Future<Unit> addBeneficiary(BeneficiaryModel beneficiaryModel) {
    final jsonOldBeneficiaries =
        sharedPreferences.getString(CACHED_BENEFICIARIES) ?? "[]";
    List<BeneficiaryModel> beneficiaries =
        (json.decode(jsonOldBeneficiaries) as List)
            .map((e) => BeneficiaryModel.fromJson(e))
            .toList();
    beneficiaries.add(beneficiaryModel);

    sharedPreferences.setString(
        CACHED_BENEFICIARIES, json.encode(beneficiaries));

    return Future.value(unit);
  }

  @override
  Future<Unit> deleteBeneficiary(String? beneficiaryId) {
    final jsonOldBeneficiaries =
        sharedPreferences.getString(CACHED_BENEFICIARIES) ?? "[]";
    List<BeneficiaryModel> beneficiaries =
        (json.decode(jsonOldBeneficiaries) as List)
            .map((e) => BeneficiaryModel.fromJson(e))
            .toList();
    beneficiaries.removeWhere((element) => element.id == beneficiaryId);

    sharedPreferences.setString(
        CACHED_BENEFICIARIES, json.encode(beneficiaries));

    return Future.value(unit);
  }

  @override
  Future<Unit> addTransaction(TransactionModel transactionModel) {
    final jsonOldTransactions =
        sharedPreferences.getString(CACHED_TRANSACTIONS) ?? "[]";
    List<TransactionModel> transactions =
        (json.decode(jsonOldTransactions) as List)
            .map((e) => TransactionModel.fromJson(e))
            .toList();
    transactions.add(transactionModel);

    sharedPreferences.setString(CACHED_TRANSACTIONS, json.encode(transactions));

    return Future.value(unit);
  }

  @override
  Future<List<TransactionModel>> getCachedTransactions() async {
    final jsonString = sharedPreferences.getString(CACHED_TRANSACTIONS);
    if (jsonString != null) {
      return (json.decode(jsonString) as List)
          .map((e) => TransactionModel.fromJson(e))
          .toList();
    } else {
      return Future.value([]);
    }
  }
}
