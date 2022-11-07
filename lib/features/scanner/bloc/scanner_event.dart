part of 'scanner_bloc.dart';

abstract class ScannerEvent extends Equatable {
  const ScannerEvent();

  @override
  List<Object> get props => [];
}

class ValueScanned extends ScannerEvent {
  const ValueScanned(this.value);

  final String value;

  @override
  List<Object> get props => [value];
}

class ResetScannedValue extends ScannerEvent {}
