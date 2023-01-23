import 'package:equatable/equatable.dart';
import 'package:invoice_repository/invoice_repository.dart';

class GroupedByDateInvoices extends Equatable {
  GroupedByDateInvoices({
    required this.dateTime,
    required this.invoices,
    required this.total,
  });

  final DateTime dateTime;
  final List<Invoice> invoices;
  final num total;

  GroupedByDateInvoices copyWith({
    DateTime? dateTime,
    List<Invoice>? invoices,
    double? total,
  }) {
    return GroupedByDateInvoices(
      dateTime: dateTime ?? this.dateTime,
      invoices: invoices ?? this.invoices,
      total: total ?? this.total,
    );
  }

  @override
  List<Object> get props => [dateTime, invoices];
}
