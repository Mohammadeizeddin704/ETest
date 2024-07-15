import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:etest/features/auth/domain/entities/user_entity.dart';
import 'package:etest/features/auth/domain/usecases/add_fund.dart';
import 'package:etest/features/auth/domain/usecases/get_user.dart';
import 'package:etest/features/auth/domain/usecases/update_verification.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/strings/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/strings/messages.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late UserEntity user;
  final GetUserUsecase getUser;
  final UpdateVerificationUsecase updateVerification;
  final AddFundUsecase addFund;

  AuthBloc({
    required this.getUser,
    required this.updateVerification,
    required this.addFund,
  }) : super(AuthInitial()) {
    on<GetUserEvent>(_onGetUserEvent);
    on<AddFundEvent>(_onAddFundEvent);
    on<UpdateUserVerificationEvent>(_onVerifyUserEvent);
  }

  AuthState _mapFailureOrUserToState(Either<Failure, UserEntity> either) {
    return either.fold(
          (failure) =>
          ErrorUserState(message: _mapFailureToMessage(failure)),
          (user) {
        this.user = user;
        return LoadedUserState(user: user);
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case EmptyCacheFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return "Unexpected Error , Please try again later .";
    }
  }

  FutureOr<void> _onGetUserEvent(GetUserEvent event,
      Emitter<AuthState> emit) async {
    emit(LoadingUserState());
    final failureOrUser = await getUser();
    emit(_mapFailureOrUserToState(failureOrUser));
  }

  FutureOr<void> _onAddFundEvent(AddFundEvent event,
      Emitter<AuthState> emit) async {
    final failureOrDoneMessage = await addFund(event.amount);
    return failureOrDoneMessage.fold(
          (failure) =>
          emit(ErrorUserState(
            message: _mapFailureToMessage(failure),
          )), (_) {
      UserSuccessfullyState(message:ADD_FUND_SUCCESS_MESSAGE);
      add(GetUserEvent());
    },
    );
  }

  FutureOr<void> _onVerifyUserEvent(UpdateUserVerificationEvent event,
      Emitter<AuthState> emit) async {
    final failureOrDoneMessage = await updateVerification(event.isVerify);
    return failureOrDoneMessage.fold(
          (failure) =>
          emit(ErrorUserState(
            message: _mapFailureToMessage(failure),
          )), (_) {
      UserSuccessfullyState(message:VERIFICATION_UPDATE_SUCCESS_MESSAGE);
      add(GetUserEvent());
    },
    );
  }
}
