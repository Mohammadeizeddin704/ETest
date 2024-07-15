part of 'beneficiary_bloc.dart';

abstract class BeneficiaryState extends Equatable {
  const BeneficiaryState();

  @override
  List<Object> get props => [];
}

class LoadedBeneficiariesState extends BeneficiaryState {
  final List<BeneficiaryEntity> beneficiaries;

  const LoadedBeneficiariesState(this.beneficiaries);

  @override
  List<Object> get props => [beneficiaries];
}

class LoadingBeneficiaryState extends BeneficiaryState {}

class MaxBeneficiariesLimitState extends BeneficiaryState {
  final String message;
  const MaxBeneficiariesLimitState({required this.message});

  @override
  List<Object> get props => [message];
}

class ErrorBeneficiaryState extends BeneficiaryState {
  final String message;

  const ErrorBeneficiaryState({required this.message});

  @override
  List<Object> get props => [message];
}

class MessageBeneficiaryState extends BeneficiaryState {
  final String message;

  const MessageBeneficiaryState({required this.message});

  @override
  List<Object> get props => [message];
}
