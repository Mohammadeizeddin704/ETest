import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int? id;
  final String name;
  bool isVerified;
  double balance;

  UserEntity(
      {this.id,
      required this.name,
      required this.isVerified,
      required this.balance});

  @override
  List<Object?> get props => [id, name, isVerified, balance];
}
