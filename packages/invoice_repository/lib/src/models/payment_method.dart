import 'package:equatable/equatable.dart';

class PaymentMethod extends Equatable {
  const PaymentMethod({
    this.id,
    this.type,
    this.amount,
    this.typeCode,
  });

  final int? id;
  final String? type;
  final double? amount;
  final String? typeCode;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    final paymentMethod = PaymentMethod(
      id: json['id'],
      type: json['type'],
      amount: json['amount']?.toDouble(),
      typeCode: json['typeCode'],
    );

    return paymentMethod;
  }

  @override
  List<Object?> get props => [id, type, amount, typeCode];
}
