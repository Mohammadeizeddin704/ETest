import 'dart:convert';
import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  Future<UserModel> getUser();

  Future<Unit> addFund(double amount);

  Future<Unit> updateVerification(bool isVerified);
}

const BASE_URL = "auth";

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> getUser() async {
    //here we can point to our APIs
    final response = await client.get(
      Uri.parse("$BASE_URL/getUser"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);

      return UserModel.fromJson(decodedJson);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> addFund(double amount) async {
    final response = await client.put(Uri.parse("$BASE_URL/updateAmount"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"amount": amount}));
    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> updateVerification(bool isVerified) async {
    final response = await client.put(Uri.parse("$BASE_URL/updateVerification"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"isVerified": isVerified}));
    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }
}
