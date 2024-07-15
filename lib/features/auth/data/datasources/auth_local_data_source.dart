import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel> getCachedUser();

  Future<Unit> addFund(double amount);

  Future<Unit> updateVerification(bool isVerified);
}

const CACHED_USER = "CACHED_USER";

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel> getCachedUser() {
    final jsonString = sharedPreferences.getString(CACHED_USER);
    print(jsonString);
    if (jsonString != null) {
      return Future.value(UserModel.fromJson(json.decode(jsonString)));
    } else {
      UserModel userModel =
          UserModel(name: "Mohamad", isVerified: true, id: 1, balance: 0);
      sharedPreferences.setString(CACHED_USER, json.encode(userModel));

      return Future.value(userModel);
    }
  }

  @override
  Future<Unit> addFund(double amount) async {
    final jsonString = sharedPreferences.getString(CACHED_USER);
    if (jsonString != null) {
      UserModel userModel = UserModel.fromJson(json.decode(jsonString));
      userModel.balance += amount;

      sharedPreferences.setString(CACHED_USER, json.encode(userModel));
    }
    return Future.value(unit);
  }

  @override
  Future<Unit> updateVerification(bool isVerified) {
    final jsonString = sharedPreferences.getString(CACHED_USER);
    if (jsonString != null) {
      UserModel userModel = UserModel.fromJson(json.decode(jsonString));
      userModel.isVerified = isVerified;
      sharedPreferences.setString(CACHED_USER, json.encode(userModel));
    }
    return Future.value(unit);
  }
}
