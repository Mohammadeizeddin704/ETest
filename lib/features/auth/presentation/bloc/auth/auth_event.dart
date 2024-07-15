part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class GetUserEvent extends AuthEvent {}

class AddFundEvent extends AuthEvent {
  double amount;

  AddFundEvent({required this.amount});
}

class UpdateUserVerificationEvent extends AuthEvent {
  bool isVerify;

  UpdateUserVerificationEvent({required this.isVerify});
}
