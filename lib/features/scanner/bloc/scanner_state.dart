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
    this.iic = const IIC.pure(),
    this.tin = const TIN.pure(),
    this.dateCreated = const DateCreated.pure(),
    this.timeCreated = const TimeCreated.pure(null),
    this.manualAdditionStatus = FormzStatus.pure,
  });

  final String scannedValue;
  final Invoice? fetchedInvoice;
  final FetchingInvoiceStatus fetchingInvoiceStatus;
  final ScannerStatus scannerStatus;
  final ScannedValueStatus scannedValueStatus;
  final InsertionValueStatus insertionValueStatus;
  final IIC iic;
  final TIN tin;
  final DateCreated dateCreated;
  final TimeCreated timeCreated;
  final FormzStatus manualAdditionStatus;

  ScannerState copyWith({
    ScannerStatus? scannerStatus,
    String? scannedValue,
    Invoice? fetchedInvoice,
    FetchingInvoiceStatus? fetchingInvoiceStatus,
    ScannedValueStatus? scannedValueStatus,
    InsertionValueStatus? insertionValueStatus,
    IIC? iic,
    TIN? tin,
    DateCreated? dateCreated,
    TimeCreated? timeCreated,
    FormzStatus? manualAdditionStatus,
  }) {
    return ScannerState(
      scannerStatus: scannerStatus ?? this.scannerStatus,
      scannedValue: scannedValue ?? this.scannedValue,
      fetchedInvoice: fetchedInvoice ?? this.fetchedInvoice,
      fetchingInvoiceStatus:
          fetchingInvoiceStatus ?? this.fetchingInvoiceStatus,
      scannedValueStatus: scannedValueStatus ?? this.scannedValueStatus,
      insertionValueStatus: insertionValueStatus ?? this.insertionValueStatus,
      iic: iic ?? this.iic,
      tin: tin ?? this.tin,
      dateCreated: dateCreated ?? this.dateCreated,
      timeCreated: timeCreated ?? this.timeCreated,
      manualAdditionStatus: manualAdditionStatus ?? this.manualAdditionStatus,
    );
  }

  ScannerState reset() {
    return const ScannerState();
  }

  @override
  String toString() {
    return '''ScannerStatus { scannerStatus: $scannerStatus, scannedValue: $scannedValue, fetchedInvoice: $fetchedInvoice, fetchingInvoiceStatus: $fetchingInvoiceStatus, scannedValueStatus: $scannedValueStatus, insertionValueStatus: $insertionValueStatus, iic: $iic, tin: $tin, dateCreated: $dateCreated, timeCreated: $timeCreated, manualAdditionStatus: $manualAdditionStatus }''';
  }

  @override
  List<Object?> get props => [
        scannerStatus,
        scannedValue,
        fetchedInvoice,
        fetchingInvoiceStatus,
        scannedValueStatus,
        insertionValueStatus,
        iic,
        tin,
        dateCreated,
        timeCreated,
        manualAdditionStatus,
      ];
}
