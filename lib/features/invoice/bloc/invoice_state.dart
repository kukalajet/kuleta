part of 'invoice_bloc.dart';

enum InvoicesStatus { initial, loading, success, failure }

enum TotalAmountSpentLastWeekStatus { initial, loading, success, failure }

enum TotalAmountSpentLastMonthStatus { initial, loading, success, failure }

enum ShouldBeOnboardedStatus { initial, loading, success, failure }

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
    this.shouldBeOnboarded = false,
    this.shouldBeOnboardedStatus = ShouldBeOnboardedStatus.initial,
  });

  final List<GroupedByDateInvoices> invoices;
  final InvoicesStatus invoicesStatus;
  final bool hasReachedMax;
  final double totalAmountSpentLastWeek;
  final TotalAmountSpentLastWeekStatus totalAmountSpentLastWeekStatus;
  final double totalAmountSpentLastMonth;
  final TotalAmountSpentLastMonthStatus totalAmountSpentLastMonthStatus;
  final bool shouldBeOnboarded;
  final ShouldBeOnboardedStatus shouldBeOnboardedStatus;

  InvoiceState copyWith({
    List<GroupedByDateInvoices>? invoices,
    InvoicesStatus? invoicesStatus,
    bool? hasReachedMax,
    double? totalAmountSpentLastWeek,
    TotalAmountSpentLastWeekStatus? totalAmountSpentLastWeekStatus,
    double? totalAmountSpentLastMonth,
    TotalAmountSpentLastMonthStatus? totalAmountSpentLastMonthStatus,
    bool? shouldBeOnboarded,
    ShouldBeOnboardedStatus? shouldBeOnboardedStatus,
  }) {
    return InvoiceState(
      invoices: invoices ?? this.invoices,
      invoicesStatus: invoicesStatus ?? this.invoicesStatus,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      totalAmountSpentLastWeek:
          totalAmountSpentLastWeek ?? this.totalAmountSpentLastWeek,
      totalAmountSpentLastWeekStatus:
          totalAmountSpentLastWeekStatus ?? this.totalAmountSpentLastWeekStatus,
      totalAmountSpentLastMonth:
          totalAmountSpentLastMonth ?? this.totalAmountSpentLastMonth,
      totalAmountSpentLastMonthStatus: totalAmountSpentLastMonthStatus ??
          this.totalAmountSpentLastMonthStatus,
      shouldBeOnboarded: shouldBeOnboarded ?? this.shouldBeOnboarded,
      shouldBeOnboardedStatus:
          shouldBeOnboardedStatus ?? this.shouldBeOnboardedStatus,
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
        shouldBeOnboarded,
        shouldBeOnboardedStatus,
      ];
}
