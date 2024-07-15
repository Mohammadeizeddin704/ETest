import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:etest/core/error/failures.dart';
import 'package:etest/core/strings/failures.dart';
import 'package:etest/core/strings/messages.dart';
import 'package:etest/features/auth/domain/entities/user_entity.dart';
import 'package:etest/features/top_up/domain/entities/beneficiary_entity.dart';
import 'package:etest/features/top_up/domain/entities/transaction_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:etest/features/top_up/domain/usecases/top_up/add_transaction.dart';
import 'package:etest/features/top_up/domain/usecases/top_up/get_transactions.dart';

part 'top_up_event.dart';

part 'top_up_state.dart';

class TopUpBloc extends Bloc<TopUpEvent, TopUpState> {
  final AddTransactionUsecase addTransaction;
  final GetTransactionsUsecase getTransactions;
  late List<TransactionEntity> transactions;

  TopUpBloc({required this.addTransaction, required this.getTransactions})
      : super(LoadingTransactionsState()) {
    transactions = [];
    on<RequestTopUpEvent>(_onRequestTopUp);
    on<GetTransactionsEvent>(_onGetTransactionsEvent);
  }

  FutureOr<void> _onGetTransactionsEvent(
      GetTransactionsEvent event, Emitter<TopUpState> emit) async {
    emit(LoadingTransactionsState());
    final failureOrDoneMessage = await getTransactions();
    return failureOrDoneMessage.fold(
      (failure) => emit(ErrorTransactionState(
        message: _mapFailureToMessage(failure),
      )),
      (data) {
        data.sort((a, b) => b.date.compareTo(a.date));
        transactions = data;
        emit(LoadedTransactionsState(data));
      },
    );
  }

  //Add Transaction
  FutureOr<void> _onRequestTopUp(
      RequestTopUpEvent event, Emitter<TopUpState> emit) async {
    emit(LoadingTransactionsState());

    try {
      List<BeneficiaryEntity> beneficiaries = event.beneficiaries;

      // Find the beneficiary
      BeneficiaryEntity? beneficiary;
      for (var element in beneficiaries) {
        if (element.id == event.beneficiaryId) {
          beneficiary = element;
        }
      }

      // Calculate total top-up amount for the beneficiary in the current month
      final currentMonthTopUps = transactions
          .where((t) =>
              t.beneficiaryId == beneficiary?.id &&
              t.date.month == DateTime.now().month &&
              t.date.year == DateTime.now().year)
          .toList();

      final currentMonthTotal =
          currentMonthTopUps.fold(0.0, (sum, topUp) => sum + topUp.amount);

      // Calculate total top-up amount for all beneficiaries in the current month
      final totalTopUpThisMonth = transactions
          .where((t) =>
              t.date.month == DateTime.now().month &&
              t.date.year == DateTime.now().year)
          .fold(0.0, (sum, topUp) => sum + topUp.amount);

      final transactionAmount = event.amount + 1; // Including the AED 1 charge

      // Check if user has enough balance
      if (event.user.balance < transactionAmount) {
        emit(const TopUpFailureState(message: INSUFFICENT_BALANCE_MESSAGE));
        return;
      }

      // Check beneficiary limit
      if (event.user.isVerified) {
        if (currentMonthTotal + event.amount > 500) {
          emit(const TopUpFailureState(
              message: VERIFIED_USER_LIMIT_ERROR_MESSAGE));
          return;
        }
      } else {
        if (currentMonthTotal + event.amount > 1000) {
          emit(const TopUpFailureState(
              message: NON_VERIFIED_USER_ERROR_MESSAGE));
          return;
        }
      }

      // Check total limit for all beneficiaries
      if (totalTopUpThisMonth + event.amount > 3000) {
        emit(const TopUpFailureState(message: USER_TOTOAL_LIMIT_ERROR_MESSAGE));
        return;
      }

      // Perform the top-up
      final newTopUp = TransactionEntity(
        id: DateTime.now().toString(),
        beneficiaryId: event.beneficiaryId,
        amount: event.amount,
        date: DateTime.now(),
      );
      addTransaction(newTopUp);
      emit(TopUpSuccessState(
          message: TRANSACTION_ADD_SUCCESS_MESSAGE,
          totalAmount: transactionAmount));
      add(const GetTransactionsEvent());
    } catch (e) {
      emit(const TopUpFailureState(message: TRANSACTION_ERROR_MESSAGE));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return "Unexpected Error , Please try again later .";
    }
  }
}
