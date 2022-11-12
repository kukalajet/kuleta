part of 'invoice_bloc.dart';

enum InvoicesStatus { initial, loading, success, failure }

class InvoiceState extends Equatable {
  const InvoiceState({
    this.invoices = const <GroupedByDateInvoices>[],
    this.invoicesStatus = InvoicesStatus.initial,
    this.hasReachedMax = false,
  });

  final List<GroupedByDateInvoices> invoices;
  final InvoicesStatus invoicesStatus;
  final bool hasReachedMax;

  InvoiceState copyWith({
    List<GroupedByDateInvoices>? invoices,
    InvoicesStatus? invoicesStatus,
    bool? hasReachedMax,
  }) {
    return InvoiceState(
      invoices: invoices ?? this.invoices,
      invoicesStatus: invoicesStatus ?? this.invoicesStatus,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [invoices, invoicesStatus, hasReachedMax];
}
