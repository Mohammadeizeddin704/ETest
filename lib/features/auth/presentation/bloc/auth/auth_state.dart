part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class LoadingUserState extends AuthState {}

class LoadedUserState extends AuthState {
  final UserEntity user;

  LoadedUserState({required this.user});

  @override
  List<Object> get props => [user];
}

class ErrorUserState extends AuthState {
  final String message;

  ErrorUserState({required this.message});

  @override
  List<Object> get props => [message];
}

class UserSuccessfullyState extends AuthState {
  final String message;

  UserSuccessfullyState({required this.message});

  @override
  List<Object> get props => [message];
}
