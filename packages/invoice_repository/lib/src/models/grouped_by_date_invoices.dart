import 'package:invoice_repository/invoice_repository.dart';

class GroupedByDateInvoices {
  GroupedByDateInvoices({
    required this.dateTime,
    required this.invoices,
  });

  final DateTime dateTime;
  final List<Invoice> invoices;
}
