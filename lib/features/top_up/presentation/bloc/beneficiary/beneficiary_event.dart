part of 'beneficiary_bloc.dart';

abstract class BeneficiaryEvent extends Equatable {
  const BeneficiaryEvent();

  @override
  List<Object> get props => [];
}

class GetBeneficiariesEvent extends BeneficiaryEvent {
  const GetBeneficiariesEvent();
}

class AddBeneficiaryEvent extends BeneficiaryEvent {
  final BeneficiaryEntity beneficiary;

  const AddBeneficiaryEvent({required this.beneficiary});

  @override
  List<Object> get props => [beneficiary];
}

class DeleteBeneficiaryEvent extends BeneficiaryEvent {
  final String? beneficiaryId;

  const DeleteBeneficiaryEvent({required this.beneficiaryId});

}
