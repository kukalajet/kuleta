import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

import 'item.dart';
import 'payment_method.dart';
import 'seller.dart';
import 'tax.dart';

part 'invoice.g.dart';

@Collection(ignore: <String>{'props'})
class Invoice extends Equatable {
  Invoice({
    required this.id,
    this.totalPrice,
    this.totalPriceWithoutVAT,
    this.totalVATAmount,
    this.cashRegister,
    this.invoiceOrderNumber,
    this.dateTimeCreated,
    this.iic,
    this.tin,
    this.seller,
    this.paymentMethod = const <PaymentMethod>[],
    this.items = const <Item>[],
    this.sameTaxes = const <Tax>[],
  });

  final Id id;
  final double? totalPrice;
  final double? totalPriceWithoutVAT;
  final double? totalVATAmount;
  final String? cashRegister;
  final int? invoiceOrderNumber;
  final DateTime? dateTimeCreated;
  final String? iic;
  final String? tin;
  final Seller? seller;
  final List<PaymentMethod> paymentMethod;
  final List<Item> items;
  final List<Tax> sameTaxes;

  factory Invoice.fromJson(
    Map<String, dynamic> json,
    String iic,
    String tin,
  ) {
    final paymentMethodJson = json['paymentMethod'];
    final paymentMethod = paymentMethodJson != null
        ? List<PaymentMethod>.from(
            paymentMethodJson.map((item) => PaymentMethod.fromJson(item)))
        : null;

    final itemsJson = json['items'];
    final items = itemsJson != null
        ? List<Item>.from(
            itemsJson.map((item) => Item.fromJson(item)),
          )
        : null;

    final sameTaxesJson = json['sameTaxes'];
    final sameTaxes = sameTaxesJson != null
        ? List<Tax>.from(
            sameTaxesJson.map((item) => Tax.fromJson(item)),
          )
        : null;

    final sellerId = int.parse(tin.substring(1, tin.length - 1));
    final seller = Seller.fromJsonAndId(json['seller'], sellerId);
    final dateTimeCreated = DateTime.tryParse(json['dateTimeCreated']);
    final invoice = Invoice(
      id: json['id'],
      totalPrice: json['totalPrice']?.toDouble(),
      totalPriceWithoutVAT: json['totalPriceWithoutVAT']?.toDouble(),
      totalVATAmount: json['totalVATAmount']?.toDouble(),
      cashRegister: json['cashRegister'],
      invoiceOrderNumber: json['invoiceOrderNumber'],
      dateTimeCreated: dateTimeCreated,
      iic: iic,
      tin: tin,
      seller: seller,
      paymentMethod: paymentMethod ?? [],
      items: items ?? [],
      sameTaxes: sameTaxes ?? [],
    );

    return invoice;
  }

  @override
  List<Object?> get props => [
        id,
        totalPrice,
        totalPriceWithoutVAT,
        totalVATAmount,
        cashRegister,
        invoiceOrderNumber,
        dateTimeCreated,
        iic,
        tin,
        seller,
        paymentMethod,
        items,
        sameTaxes
      ];
}
