import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:invoice_repository/invoice_repository.dart';

part 'invoice_event.dart';
part 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  InvoiceBloc({
    required InvoiceRepository invoiceRepository,
  })  : _invoiceRepository = invoiceRepository,
        super(const InvoiceState()) {
    on<InvoicesFetched>(_onInvoicesFetched);
    on<RemoveInvoiceFromState>(_onRemoveInvoiceFromState);
    on<AddInvoiceToState>(_onAddInvoiceToState);
  }

  final InvoiceRepository _invoiceRepository;

  Future<void> _onInvoicesFetched(
    InvoicesFetched event,
    Emitter<InvoiceState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      if (state.invoicesStatus == InvoicesStatus.initial) {
        final invoices = await _invoiceRepository.getGroupedByDateInvoices();
        final newState = state.copyWith(
          invoices: invoices,
          invoicesStatus: InvoicesStatus.success,
          hasReachedMax: false,
        );
        emit(newState);
        return;
      }

      final currentLength = state.invoices.fold<int>(0, (total, element) {
        final length = element.invoices.length;
        return total + length;
      });
      final invoices = await _invoiceRepository.getGroupedByDateInvoices(
        startIndex: currentLength,
      );

      emit(
        invoices.isEmpty
            ? state.copyWith(
                invoicesStatus: InvoicesStatus.success,
                hasReachedMax: true,
              )
            : state.copyWith(
                invoices: List.of(state.invoices)..addAll(invoices),
                invoicesStatus: InvoicesStatus.success,
                hasReachedMax: true,
              ),
      );
    } on Exception {
      emit(state.copyWith(invoicesStatus: InvoicesStatus.failure));
    }
  }

  void _onRemoveInvoiceFromState(
    RemoveInvoiceFromState event,
    Emitter<InvoiceState> emit,
  ) {
    final id = event.value.id;
    final dateTime = event.value.dateTimeCreated;

    final invoices = List<GroupedByDateInvoices>.of(state.invoices);
    final index =
        invoices.indexWhere((item) => dateTime!.isSameDate(item.dateTime));
    if (index == -1) return;

    final groupedByDateInvoices = List<Invoice>.from(invoices[index].invoices)
      ..removeWhere((item) => item.id == id);
    if (groupedByDateInvoices.isEmpty) {
      invoices.removeAt(index);
      emit(state.copyWith(invoices: invoices));
      return;
    }

    final newGroupedByDateInvoices =
        invoices[index].copyWith(invoices: groupedByDateInvoices);
    invoices[index] = newGroupedByDateInvoices;

    emit(state.copyWith(invoices: invoices));
  }

  void _onAddInvoiceToState(
    AddInvoiceToState event,
    Emitter<InvoiceState> emit,
  ) {
    final invoice = event.value;
    final dateTime = invoice.dateTimeCreated;

    final invoices = List<GroupedByDateInvoices>.of(state.invoices);
    final index =
        invoices.indexWhere((item) => dateTime!.isSameDate(item.dateTime));
    if (index == -1) {
      final newGroupedByDateInvoices = GroupedByDateInvoices(
        dateTime: dateTime!,
        invoices: [invoice],
      );
      invoices
        ..add(newGroupedByDateInvoices)
        ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

      emit(state.copyWith(invoices: invoices));
      return;
    }

    final newInvoices = List<Invoice>.from(invoices[index].invoices)
      ..add(invoice);
    final newGroupedByDateInvoices =
        invoices[index].copyWith(invoices: newInvoices);
    invoices[index] = newGroupedByDateInvoices;

    emit(state.copyWith(invoices: invoices));
  }
}
