// ignore_for_file: avoid_dynamic_calls

import 'package:equatable/equatable.dart';
import 'package:invoice_repository/src/models/item.dart';
import 'package:invoice_repository/src/models/payment_method.dart';
import 'package:invoice_repository/src/models/seller.dart';
import 'package:invoice_repository/src/models/tax.dart';
import 'package:isar/isar.dart';

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
  final List<PaymentMethod> paymentMethod;
  final List<Item> items;
  final List<Tax> sameTaxes;

  final seller = IsarLink<Seller>();

  factory Invoice.fromJson(
    Map<String, dynamic> json,
    String iic,
    String tin,
  ) {
    final paymentMethodJson = json['paymentMethod'];
    final paymentMethod = paymentMethodJson != null
        ? List<PaymentMethod>.from(
            paymentMethodJson.map(
              (item) => PaymentMethod.fromJson(item),
            ),
          )
        : null;

    final itemsJson = json['items'];
    final items = itemsJson != null
        ? List<Item>.from(
            itemsJson.map(
              (item) => Item.fromJson(item),
            ),
          )
        : null;

    final sameTaxesJson = json['sameTaxes'];
    final sameTaxes = sameTaxesJson != null
        ? List<Tax>.from(
            sameTaxesJson.map(
              (item) => Tax.fromJson(item),
            ),
          )
        : null;

    final sellerId = int.parse(tin.substring(1, tin.length - 1));
    final seller = Seller.fromJsonAndId(json['seller'], sellerId);
    final dateTimeCreated = DateTime.tryParse(json['dateTimeCreated']);

    final invoice = Invoice(
      // in some cases, invoice's `id` receives a `null` value
      // to fix it we "convert" `tin` to an int until we don't find a better way
      id: json['id'] ?? int.parse(tin.substring(1, tin.length - 1)),
      totalPrice: json['totalPrice']?.toDouble(),
      totalPriceWithoutVAT: json['totalPriceWithoutVAT']?.toDouble(),
      totalVATAmount: json['totalVATAmount']?.toDouble(),
      cashRegister: json['cashRegister'],
      invoiceOrderNumber: json['invoiceOrderNumber'],
      dateTimeCreated: dateTimeCreated,
      iic: iic,
      tin: tin,
      paymentMethod: paymentMethod ?? [],
      items: items ?? [],
      sameTaxes: sameTaxes ?? [],
    )..seller.value = seller;

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
