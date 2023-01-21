import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'item.g.dart';

@Embedded(ignore: <String>{'props'})
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
      quantity: (json['quantity'] as int?)?.toDouble(),
      unitPriceBeforeVat: (json['unitPriceBeforeVat'] as int?)?.toDouble(),
      unitPriceAfterVat: (json['unitPriceAfterVat'] as int?)?.toDouble(),
      priceBeforeVat: (json['priceBeforeVat'] as int?)?.toDouble(),
      vatRate: (json['vatRate'] as int?)?.toDouble(),
      vatAmount: (json['vatAmount'] as int?)?.toDouble(),
      priceAfterVat: (json['priceAfterVat'] as int?)?.toDouble(),
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
