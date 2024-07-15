import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel(
      {int? id,
      required String name,
      required bool isVerified,
      required double balance})
      : super(id: id, name: name, isVerified: isVerified, balance: balance);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        name: json['name'],
        isVerified: json['isVerified'],
        balance: json['balance']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isVerified': isVerified,
      'balance': balance
    };
  }
}
