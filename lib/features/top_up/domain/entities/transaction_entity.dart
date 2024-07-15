import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final String? id;
  final String beneficiaryId;
  final double amount;
  final DateTime date;

  const TransactionEntity({
    required this.id,
    required this.beneficiaryId,
    required this.amount,
    required this.date,
  });

  @override
  List<Object?> get props => [id, beneficiaryId, amount, date];
}
