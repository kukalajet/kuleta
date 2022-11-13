part of 'invoice_bloc.dart';

enum InvoicesStatus { initial, loading, success, failure }

enum TotalAmountSpentLastWeekStatus { initial, loading, success, failure }

enum TotalAmountSpentLastMonthStatus { initial, loading, success, failure }

class InvoiceState extends Equatable {
  const InvoiceState({
    this.invoices = const <GroupedByDateInvoices>[],
    this.invoicesStatus = InvoicesStatus.initial,
    this.hasReachedMax = false,
    this.totalAmountSpentLastWeek = double.nan,
    this.totalAmountSpentLastWeekStatus =
        TotalAmountSpentLastWeekStatus.initial,
    this.totalAmountSpentLastMonth = double.nan,
    this.totalAmountSpentLastMonthStatus =
        TotalAmountSpentLastMonthStatus.initial,
  });

  final List<GroupedByDateInvoices> invoices;
  final InvoicesStatus invoicesStatus;
  final bool hasReachedMax;
  final double totalAmountSpentLastWeek;
  final TotalAmountSpentLastWeekStatus totalAmountSpentLastWeekStatus;
  final double totalAmountSpentLastMonth;
  final TotalAmountSpentLastMonthStatus totalAmountSpentLastMonthStatus;

  InvoiceState copyWith({
    List<GroupedByDateInvoices>? invoices,
    InvoicesStatus? invoicesStatus,
    bool? hasReachedMax,
    double? totalAmountSpentLastWeek,
    TotalAmountSpentLastWeekStatus? totalAmountSpentLastWeekStatus,
    double? totalAmountSpentLastMonth,
    TotalAmountSpentLastMonthStatus? totalAmountSpentLastMonthStatus,
  }) {
    final totalAmountSpentLastWeek1 =
        totalAmountSpentLastWeek ?? this.totalAmountSpentLastWeek;
    final totalAmountSpentLastWeekStatus1 =
        totalAmountSpentLastWeekStatus ?? this.totalAmountSpentLastWeekStatus;
    final totalAmountSpentLastMonth1 =
        totalAmountSpentLastMonth ?? this.totalAmountSpentLastMonth;
    final totalAmountSpentLastMonthStatus1 =
        totalAmountSpentLastMonthStatus ?? this.totalAmountSpentLastMonthStatus;

    return InvoiceState(
      invoices: invoices ?? this.invoices,
      invoicesStatus: invoicesStatus ?? this.invoicesStatus,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      totalAmountSpentLastWeek: totalAmountSpentLastWeek1,
      totalAmountSpentLastWeekStatus: totalAmountSpentLastWeekStatus1,
      totalAmountSpentLastMonth: totalAmountSpentLastMonth1,
      totalAmountSpentLastMonthStatus: totalAmountSpentLastMonthStatus1,
    );
  }

  @override
  List<Object> get props => [
        invoices,
        invoicesStatus,
        hasReachedMax,
        totalAmountSpentLastWeek,
        totalAmountSpentLastWeekStatus,
        totalAmountSpentLastMonth,
        totalAmountSpentLastMonthStatus,
      ];
}
