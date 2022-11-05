import 'package:equatable/equatable.dart';

class Item extends Equatable {
  const Item({
    this.id,
    this.name,
    this.code,
    this.unit,
    this.quantity,
    this.unitPriceBeforeVat,
    this.unitPriceAfterVat,
    this.priceBeforeVat,
    this.vatRate,
    this.vatAmount,
    this.priceAfterVat,
    this.investment,
  });

  final int? id;
  final String? name;
  final String? code;
  final String? unit;
  final double? quantity;
  final double? unitPriceBeforeVat;
  final double? unitPriceAfterVat;
  final double? priceBeforeVat;
  final double? vatRate;
  final double? vatAmount;
  final double? priceAfterVat;
  final bool? investment;

  factory Item.fromJson(Map<String, dynamic> json) {
    final item = Item(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      unit: json['unit'],
      quantity: json['quantity']?.toDouble(),
      unitPriceBeforeVat: json['unitPriceBeforeVat']?.toDouble(),
      unitPriceAfterVat: json['unitPriceAfterVat']?.toDouble(),
      priceBeforeVat: json['priceBeforeVat']?.toDouble(),
      vatRate: json['vatRate']?.toDouble(),
      vatAmount: json['vatAmount']?.toDouble(),
      priceAfterVat: json['priceAfterVat']?.toDouble(),
      investment: json['investment'],
    );

    return item;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        unit,
        quantity,
        unitPriceAfterVat,
        unitPriceAfterVat,
        priceBeforeVat,
        vatRate,
        vatAmount,
        priceAfterVat,
        investment
      ];
}
