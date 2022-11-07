part of 'scanner_bloc.dart';

enum ScannerStatus { initial, success, failure }

enum ScannedValueStatus { initial, valid, invalid }

enum InsertionValueStatus { initial, valid, invalid }

enum FetchingInvoiceStatus { initial, success, failure }

class ScannerState extends Equatable {
  const ScannerState({
    this.scannedValue = '',
    this.fetchedInvoice,
    this.fetchingInvoiceStatus = FetchingInvoiceStatus.initial,
    this.scannerStatus = ScannerStatus.initial,
    this.scannedValueStatus = ScannedValueStatus.initial,
    this.insertionValueStatus = InsertionValueStatus.initial,
  });

  final String scannedValue;
  final Invoice? fetchedInvoice;
  final FetchingInvoiceStatus fetchingInvoiceStatus;
  final ScannerStatus scannerStatus;
  final ScannedValueStatus scannedValueStatus;
  final InsertionValueStatus insertionValueStatus;

  ScannerState copyWith({
    ScannerStatus? scannerStatus,
    String? scannedValue,
    Invoice? fetchedInvoice,
    FetchingInvoiceStatus? fetchingInvoiceStatus,
    ScannedValueStatus? scannedValueStatus,
    InsertionValueStatus? insertionValueStatus,
  }) {
    return ScannerState(
      scannerStatus: scannerStatus ?? this.scannerStatus,
      scannedValue: scannedValue ?? this.scannedValue,
      fetchedInvoice: fetchedInvoice ?? this.fetchedInvoice,
      fetchingInvoiceStatus:
          fetchingInvoiceStatus ?? this.fetchingInvoiceStatus,
      scannedValueStatus: scannedValueStatus ?? this.scannedValueStatus,
      insertionValueStatus: insertionValueStatus ?? this.insertionValueStatus,
    );
  }

  ScannerState reset() {
    return const ScannerState();
  }

  @override
  String toString() {
    return '''ScannerStatus { scannerStatus: $scannerStatus, scannedValue: $scannedValue, fetchedInvoice: $fetchedInvoice, fetchingInvoiceStatus: $fetchingInvoiceStatus, scannedValueStatus: $scannedValueStatus, insertionValueStatus: $insertionValueStatus }''';
  }

  @override
  List<Object?> get props => [
        scannerStatus,
        scannedValue,
        fetchedInvoice,
        fetchingInvoiceStatus,
        scannedValueStatus,
        insertionValueStatus,
      ];
}
