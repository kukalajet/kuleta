import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:invoice_repository/invoice_repository.dart';

part 'detail_event.dart';

part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  DetailBloc({
    required InvoiceRepository invoiceRepository,
  })  : _invoiceRepository = invoiceRepository,
        super(const DetailState()) {
    on<AddInvoice>(_onAddInvoice);
    on<DeleteInvoice>(_onDeleteInvoice);
  }

  final InvoiceRepository _invoiceRepository;

  Future<void> _onAddInvoice(
    AddInvoice event,
    Emitter<DetailState> emit,
  ) async {
    final invoice = event.value;
    emit(
      state.copyWith(
        additionStatus: AdditionStatus.loading,
        invoiceToAdd: invoice,
      ),
    );

    try {
      final added = await _invoiceRepository.storeInvoice(invoice);
      if (added == false) {
        emit(state.copyWith(additionStatus: AdditionStatus.failure));
        return;
      }

      await Future<void>.delayed(const Duration(seconds: 1));

      emit(state.copyWith(additionStatus: AdditionStatus.success));
    } on Exception {
      emit(state.copyWith(additionStatus: AdditionStatus.failure));
    }
  }

  Future<void> _onDeleteInvoice(
    DeleteInvoice event,
    Emitter<DetailState> emit,
  ) async {
    final invoice = event.value;
    final id = invoice.id;

    emit(
      state.copyWith(
        removalStatus: RemovalStatus.loading,
        invoiceToRemove: invoice,
      ),
    );

    try {
      final deleted = await _invoiceRepository.removeStoredInvoice(id);

      if (deleted == false) {
        emit(state.copyWith(removalStatus: RemovalStatus.failure));
        return;
      }

      await Future<void>.delayed(const Duration(seconds: 1));

      emit(state.copyWith(removalStatus: RemovalStatus.success));
    } on Exception {
      emit(state.copyWith(removalStatus: RemovalStatus.failure));
    }
  }
}
