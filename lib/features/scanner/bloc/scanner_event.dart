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

class TINChanged extends ScannerEvent {
  const TINChanged(this.value);

  final String value;

  @override
  List<Object> get props => [value];
}

class IICChanged extends ScannerEvent {
  const IICChanged(this.value);

  final String value;

  @override
  List<Object> get props => [value];
}

class DateCreatedChanged extends ScannerEvent {
  const DateCreatedChanged(this.value);

  final DateTime value;

  @override
  List<Object> get props => [value];
}

class TimeCreatedChanged extends ScannerEvent {
  const TimeCreatedChanged(this.value);

  final TimeOfDay value;

  @override
  List<Object> get props => [value];
}
