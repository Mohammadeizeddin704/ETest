import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:etest/features/top_up/data/models/transaction.dart';

import '../../../../core/error/exceptions.dart';
import '../models/beneficiary.dart';
import 'package:http/http.dart' as http;

abstract class TopUpRemoteDataSource {
  Future<List<BeneficiaryModel>> getBeneficiaries();

  Future<Unit> addBeneficiary(BeneficiaryModel beneficiaryModel);

  Future<Unit> deleteBeneficiary(String beneficiaryId);

  Future<Unit> addTransaction(TransactionModel transactionModel);

  Future<List<TransactionModel>> getCachedTransactions();
}

const BASE_URL = "topUp";

class TopUpRemoteDataSourceImpl implements TopUpRemoteDataSource {
  final http.Client client;

  TopUpRemoteDataSourceImpl({required this.client});

  @override
  Future<List<BeneficiaryModel>> getBeneficiaries() async {
    //here we can point to our APIs
    final response = await client.get(
      Uri.parse("$BASE_URL/getBeneficiaries"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((e) => BeneficiaryModel.fromJson(e))
          .toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> addBeneficiary(BeneficiaryModel beneficiaryModel) async {
    //here we can point to our APIs
    final response = await client.post(Uri.parse("$BASE_URL/addBeneficiary"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(beneficiaryModel.toJson()));
    if (response.statusCode == 201) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> deleteBeneficiary(String beneficiaryId) async {
    //here we can point to our APIs
    final response = await client.delete(
        Uri.parse("$BASE_URL/deleteBeneficiary"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"beneficiaryId": beneficiaryId}));
    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> addTransaction(TransactionModel transactionModel) async {
    //here we can point to our APIs
    final response = await client.post(Uri.parse("$BASE_URL/addTransaction"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(transactionModel.toJson()));
    if (response.statusCode == 201) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TransactionModel>> getCachedTransactions() async {
    //here we can point to our APIs
    final response = await client.get(
      Uri.parse("$BASE_URL/getTransactions"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((e) => TransactionModel.fromJson(e))
          .toList();
    } else {
      throw ServerException();
    }
  }
}
