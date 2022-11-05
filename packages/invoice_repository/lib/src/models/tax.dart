import 'package:equatable/equatable.dart';

class Tax extends Equatable {
  const Tax({
    this.id,
    this.numberOfItems,
    this.priceBeforeVat,
    this.vatRate,
    this.vatAmount,
  });

  final int? id;
  final double? numberOfItems;
  final double? priceBeforeVat;
  final double? vatRate;
  final double? vatAmount;

  factory Tax.fromJson(Map<String, dynamic> json) {
    final tax = Tax(
      id: json['id'],
      numberOfItems: json['numberOfItems']?.toDouble(),
      priceBeforeVat: json['priceBeforeVat']?.toDouble(),
      vatRate: json['vatRate']?.toDouble(),
      vatAmount: json['vatAmount']?.toDouble(),
    );

    return tax;
  }

  @override
  List<Object?> get props => [
        id,
        numberOfItems,
        priceBeforeVat,
        vatRate,
        vatAmount,
      ];
}
