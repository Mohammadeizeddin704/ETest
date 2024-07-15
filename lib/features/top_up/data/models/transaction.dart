import 'package:etest/features/top_up/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel(
      {String? id,
      required String beneficiaryId,
      required double amount,
      required DateTime date})
      : super(id: id, beneficiaryId: beneficiaryId, amount: amount, date: date);

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
        id: json['id'],
        beneficiaryId: json['beneficiaryId'],
        amount: json['amount'],
        date: DateTime.parse(json['date']));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'beneficiaryId': beneficiaryId,
      'amount': amount,
      'date': date.toString(),
    };
  }
}
