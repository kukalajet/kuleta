import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';
import 'package:invoice_repository/invoice_repository.dart';
import 'package:kuleta/features/scanner/models/models.dart';

part 'scanner_event.dart';

part 'scanner_state.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  ScannerBloc({required InvoiceRepository invoiceRepository})
      : _invoiceRepository = invoiceRepository,
        super(const ScannerState()) {
    on<ValueScanned>(_onValueScanned);
    on<ResetScannedValue>(_onResetScannedValue);
    on<TINChanged>(_onTINChanged);
    on<IICChanged>(_onIICChanged);
    on<DateCreatedChanged>(_onDateCreatedChanged);
    on<TimeCreatedChanged>(_onTimeCreatedChanged);
    on<ManuallyFetchInvoice>(_onFetchInvoice);
  }

  final InvoiceRepository _invoiceRepository;

  Future<void> _onValueScanned(
    ValueScanned event,
    Emitter<ScannerState> emit,
  ) async {
    final value = event.value;
    emit(
      state.copyWith(
        scannedValue: value,
        scannerStatus: ScannerStatus.success,
      ),
    );

    final query = value.split('?')[1];
    final parameters = _getQueryParameters(query);
    final iic = parameters['iic'];
    final tin = parameters['tin'];
    final dateTimeCreated = parameters['crtd'];

    if (iic == null || tin == null || dateTimeCreated == null) {
      emit(state.copyWith(scannedValueStatus: ScannedValueStatus.invalid));
      return;
    } else {
      emit(state.copyWith(scannedValueStatus: ScannedValueStatus.valid));
    }

    final invoice = await _invoiceRepository.getInvoiceFromService(
      iic: iic,
      dateTimeCreated: dateTimeCreated,
      tin: tin,
    );

    emit(
      state.copyWith(
        fetchingInvoiceStatus: FetchingInvoiceStatus.success,
        fetchedInvoice: invoice,
      ),
    );
  }

  Future<void> _onResetScannedValue(
    ResetScannedValue event,
    Emitter<ScannerState> emit,
  ) async {
    emit(state.reset());
  }

  void _onTINChanged(TINChanged event, Emitter<ScannerState> emit) {
    final tin = TIN.dirty(event.value);
    emit(
      state.copyWith(
        tin: tin,
        manualAdditionStatus: Formz.validate([
          tin,
          state.iic,
          state.dateCreated,
          state.timeCreated,
        ]),
      ),
    );
  }

  void _onIICChanged(IICChanged event, Emitter<ScannerState> emit) {
    final iic = IIC.dirty(event.value);
    emit(
      state.copyWith(
        iic: iic,
        manualAdditionStatus: Formz.validate([
          state.tin,
          iic,
          state.dateCreated,
          state.timeCreated,
        ]),
      ),
    );
  }

  void _onDateCreatedChanged(
    DateCreatedChanged event,
    Emitter<ScannerState> emit,
  ) {
    final dateCreated = DateCreated.dirty(event.value);
    emit(
      state.copyWith(
        dateCreated: dateCreated,
        manualAdditionStatus: Formz.validate([
          state.tin,
          state.iic,
          dateCreated,
          state.timeCreated,
        ]),
      ),
    );
  }

  void _onTimeCreatedChanged(
    TimeCreatedChanged event,
    Emitter<ScannerState> emit,
  ) {
    final timeCreated = TimeCreated.dirty(
      event.value,
      state.dateCreated.value,
    );

    emit(
      state.copyWith(
        timeCreated: timeCreated,
        manualAdditionStatus: Formz.validate([
          state.tin,
          state.iic,
          state.dateCreated,
          timeCreated,
        ]),
      ),
    );
  }

  Future<void> _onFetchInvoice(
    ManuallyFetchInvoice event,
    Emitter<ScannerState> emit,
  ) async {
    if (state.manualAdditionStatus.isValidated) {
      emit(
        state.copyWith(manualAdditionStatus: FormzStatus.submissionInProgress),
      );

      final iic = state.iic.value;
      final tin = state.tin.value;
      final dateCreated = state.dateCreated.value;
      final timeCreated = state.timeCreated.value;

      final formatter = NumberFormat('00');

      final year = dateCreated?.year;
      final month = formatter.format(dateCreated?.month);
      final day = formatter.format(dateCreated?.day);
      final hour = timeCreated?.hour;
      final minute = timeCreated?.minute;

      final dateTimeCreated = '$year-$month-${day}T$hour:$minute:00+02.00';

      try {
        final invoice = await _invoiceRepository.getInvoiceFromService(
          iic: iic,
          dateTimeCreated: dateTimeCreated,
          tin: tin,
        );

        emit(
          state.copyWith(
            manualAdditionStatus: FormzStatus.submissionSuccess,
            fetchingInvoiceStatus: FetchingInvoiceStatus.success,
            fetchedInvoice: invoice,
          ),
        );
      } on Exception {
        emit(
          state.copyWith(manualAdditionStatus: FormzStatus.submissionFailure),
        );
      }
    }
  }

  Map<String, String> _getQueryParameters(String query) {
    return query.split('&').fold({}, (map, element) {
      final index = element.indexOf('=');
      if (index == -1) {
        if (element != '') {
          map[element] = '';
          return map;
        }
      }

      final key = element.substring(0, index);
      final value = element.substring(index + 1);
      map[key] = value;

      return map;
    });
  }
}
