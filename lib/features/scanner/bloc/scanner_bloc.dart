import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:invoice_repository/invoice_repository.dart';

part 'scanner_event.dart';
part 'scanner_state.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  ScannerBloc({required InvoiceRepository invoiceRepository})
      : _invoiceRepository = invoiceRepository,
        super(const ScannerState()) {
    on<ValueScanned>(_onValueScanned);
    on<ResetScannedValue>(_onResetScannedValue);
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
