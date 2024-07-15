
import '../../domain/entities/beneficiary_entity.dart';

class BeneficiaryModel extends BeneficiaryEntity {
  const BeneficiaryModel({String? id, required String name, required String phone})
      : super(id: id, name: name, phone: phone);

  factory BeneficiaryModel.fromJson(Map<String, dynamic> json) {
    return BeneficiaryModel(
        id: json['id'], name: json['name'], phone: json['phone']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'phone': phone};
  }
}
