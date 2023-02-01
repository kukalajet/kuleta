import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:invoice_repository/invoice_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'invoice_event.dart';

part 'invoice_state.dart';

const _shouldBeOnboardedKey = 'should-be-onboarded';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  InvoiceBloc({
    required InvoiceRepository invoiceRepository,
    required SharedPreferences sharedPreferences,
  })  : _invoiceRepository = invoiceRepository,
        _sharedPreferences = sharedPreferences,
        super(const InvoiceState()) {
    on<InvoicesFetched>(_onInvoicesFetched);
    on<RemoveInvoiceFromState>(_onRemoveInvoiceFromState);
    on<AddInvoiceToState>(_onAddInvoiceToState);
    on<TotalAmountSpentLastWeekFetched>(_onTotalAmountSpentLastWeekFetched);
    on<TotalAmountSpentLastMonthFetched>(_onTotalAmountSpentLastMonthFetched);
    on<ShouldBeOnboardedFetched>(_onShouldShowOnboardingFetched);
  }

  final InvoiceRepository _invoiceRepository;
  final SharedPreferences _sharedPreferences;

  Future<void> _onShouldShowOnboardingFetched(
    ShouldBeOnboardedFetched event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(
      state.copyWith(shouldBeOnboardedStatus: ShouldBeOnboardedStatus.loading),
    );

    await Future<void>.delayed(const Duration(seconds: 2));

    try {
      final shouldBeOnboarded =
          _sharedPreferences.getBool(_shouldBeOnboardedKey) ?? true;
      if (shouldBeOnboarded) {
        await _sharedPreferences.setBool(_shouldBeOnboardedKey, false);
      }

      emit(
        state.copyWith(
          shouldBeOnboarded: shouldBeOnboarded,
          shouldBeOnboardedStatus: ShouldBeOnboardedStatus.success,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          shouldBeOnboardedStatus: ShouldBeOnboardedStatus.failure,
        ),
      );
    }
  }

  Future<void> _onInvoicesFetched(
    InvoicesFetched event,
    Emitter<InvoiceState> emit,
  ) async {
    if (state.hasReachedMax) {
      return;
    }

    try {
      if (state.invoicesStatus == InvoicesStatus.initial) {
        final invoices = await _invoiceRepository.getGroupedByDateInvoices();
        final newState = state.copyWith(
          invoices: invoices,
          invoicesStatus: InvoicesStatus.success,
          hasReachedMax: false,
        );
        emit(newState);

        // check again for invoices when not `initial` status
        await _onInvoicesFetched(event, emit);
        return;
      }

      final currentLength = state.invoices.fold<int>(0, (total, element) {
        final length = element.invoices.length;
        return total + length;
      });

      final newInvoices = await _invoiceRepository.getGroupedByDateInvoices(
        startIndex: currentLength,
      );
      if (newInvoices.isEmpty) {
        final newState = state.copyWith(
          invoicesStatus: InvoicesStatus.success,
          hasReachedMax: true,
        );
        emit(newState);
        return;
      }

      if (newInvoices.first.dateTime.isSameDate(state.invoices.last.dateTime)) {
        state.invoices.last.invoices.addAll(newInvoices.first.invoices);
        newInvoices.removeAt(0);
      }

      final newState = state.copyWith(
        invoices: List.of(state.invoices)..addAll(newInvoices),
        invoicesStatus: InvoicesStatus.success,
        hasReachedMax: false,
      );
      emit(newState);
    } on Exception {
      final newState = state.copyWith(invoicesStatus: InvoicesStatus.failure);
      emit(newState);
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
    if (index == -1) {
      return;
    }

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

  Future<void> _onAddInvoiceToState(
    AddInvoiceToState event,
    Emitter<InvoiceState> emit,
  ) async {
    final invoice = event.value;
    //check if invoice exists or not in db
    final invoiceExists = await _invoiceRepository.findById(invoice.id);
    if (invoiceExists) {
      final invoices = List<GroupedByDateInvoices>.of(state.invoices);
      emit(state.copyWith(invoices: invoices));
      return;
    }

    final dateTime = invoice.dateTimeCreated;
    var total = 0.0;
    total += invoice.totalPrice!;
    final invoices = List<GroupedByDateInvoices>.of(state.invoices);
    final index =
        invoices.indexWhere((item) => dateTime!.isSameDate(item.dateTime));
    if (index == -1) {
      final newGroupedByDateInvoices = GroupedByDateInvoices(
        dateTime: dateTime!,
        invoices: [invoice],
        total: total,
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

  Future<void> _onTotalAmountSpentLastMonthFetched(
    TotalAmountSpentLastMonthFetched event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(
      state.copyWith(
        totalAmountSpentLastMonthStatus:
            TotalAmountSpentLastMonthStatus.initial,
      ),
    );

    try {
      final totalAmountSpentLastMonth =
          await _invoiceRepository.getTotalAmountSpentLastMonth();

      emit(
        state.copyWith(
          totalAmountSpentLastMonth: totalAmountSpentLastMonth,
          totalAmountSpentLastMonthStatus:
              TotalAmountSpentLastMonthStatus.success,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          totalAmountSpentLastMonth: double.nan,
          totalAmountSpentLastMonthStatus:
              TotalAmountSpentLastMonthStatus.failure,
        ),
      );
    }
  }

  Future<void> _onTotalAmountSpentLastWeekFetched(
    TotalAmountSpentLastWeekFetched event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(
      state.copyWith(
        totalAmountSpentLastWeekStatus: TotalAmountSpentLastWeekStatus.initial,
      ),
    );

    try {
      final totalAmountSpentLastWeek =
          await _invoiceRepository.getTotalAmountSpentLastWeek();

      emit(
        state.copyWith(
          totalAmountSpentLastWeek: totalAmountSpentLastWeek,
          totalAmountSpentLastWeekStatus:
              TotalAmountSpentLastWeekStatus.success,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          totalAmountSpentLastWeek: double.nan,
          totalAmountSpentLastWeekStatus:
              TotalAmountSpentLastWeekStatus.failure,
        ),
      );
    }
  }
}
