import 'package:equatable/equatable.dart';
import 'package:invoice_repository/invoice_repository.dart';

class GroupedByDateInvoices extends Equatable {
  GroupedByDateInvoices({
    required this.dateTime,
    required this.invoices,
  });

  final DateTime dateTime;
  final List<Invoice> invoices;

  GroupedByDateInvoices copyWith({
    DateTime? dateTime,
    List<Invoice>? invoices,
  }) {
    return GroupedByDateInvoices(
      dateTime: dateTime ?? this.dateTime,
      invoices: invoices ?? this.invoices,
    );
  }

  @override
  List<Object> get props => [dateTime, invoices];
}
