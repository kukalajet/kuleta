part of 'invoice_bloc.dart';

abstract class InvoiceEvent extends Equatable {
  const InvoiceEvent();

  @override
  List<Object> get props => [];
}

class InvoicesFetched extends InvoiceEvent {}

class AddInvoiceToState extends InvoiceEvent {
  const AddInvoiceToState(this.value);

  final Invoice value;

  @override
  List<Object> get props => [value];
}

class RemoveInvoiceFromState extends InvoiceEvent {
  const RemoveInvoiceFromState(this.value);

  final Invoice value;

  @override
  List<Object> get props => [value];
}

class TotalAmountSpentLastMonthFetched extends InvoiceEvent {}

class TotalAmountSpentLastWeekFetched extends InvoiceEvent {}

class ShouldBeOnboardedFetched extends InvoiceEvent {}
