import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'tax.g.dart';

@Embedded(ignore: <String>{'props'})
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
      numberOfItems: (json['numberOfItems'] as int?)?.toDouble(),
      priceBeforeVat: (json['priceBeforeVat'] as int?)?.toDouble(),
      vatRate: (json['vatRate'] as int?)?.toDouble(),
      vatAmount: (json['vatAmount'] as int?)?.toDouble(),
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
