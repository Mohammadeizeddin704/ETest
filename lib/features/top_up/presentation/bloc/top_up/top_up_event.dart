part of 'top_up_bloc.dart';

abstract class TopUpEvent extends Equatable {
  const TopUpEvent();

  @override
  List<Object> get props => [];
}

class GetTransactionsEvent extends TopUpEvent {
  const GetTransactionsEvent();
}

class RequestTopUpEvent extends TopUpEvent {
  final String beneficiaryId;
  final double amount;
  final UserEntity user;
  final List<BeneficiaryEntity> beneficiaries;

  const RequestTopUpEvent(
      {required this.beneficiaryId,
      required this.amount,
      required this.user,
      required this.beneficiaries});

  @override
  List<Object> get props => [beneficiaryId];
}

class DeleteBeneficiaryEvent extends TopUpEvent {
  final String? beneficiaryId;

  const DeleteBeneficiaryEvent({required this.beneficiaryId});
}
