part of 'top_up_bloc.dart';

abstract class TopUpState extends Equatable {
  const TopUpState();

  @override
  List<Object> get props => [];
}

///Beneficiary

class MaxBeneficiariesLimitState extends TopUpState {
  final String message;

  const MaxBeneficiariesLimitState({required this.message});

  @override
  List<Object> get props => [message];
}

class ErrorBeneficiaryState extends TopUpState {
  final String message;

  const ErrorBeneficiaryState({required this.message});

  @override
  List<Object> get props => [message];
}

class MessageBeneficiaryState extends TopUpState {
  final String message;

  const MessageBeneficiaryState({required this.message});

  @override
  List<Object> get props => [message];
}

///Transactions
class LoadedTransactionsState extends TopUpState {
  final List<TransactionEntity> transactions;

  const LoadedTransactionsState(this.transactions);

  @override
  List<Object> get props => [transactions];
}

class LoadingTransactionsState extends TopUpState {}

class ErrorTransactionState extends TopUpState {
  final String message;

  const ErrorTransactionState({required this.message});

  @override
  List<Object> get props => [message];
}

class TopUpFailureState extends TopUpState {
  final String message;

  const TopUpFailureState({required this.message});

  @override
  List<Object> get props => [message];
}

class TopUpSuccessState extends TopUpState {
  final String message;
  final double totalAmount;

  const TopUpSuccessState({required this.message,required this.totalAmount});

  @override
  List<Object> get props => [message];
}
