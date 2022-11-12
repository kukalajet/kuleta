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
}
