part of 'detail_bloc.dart';

enum AdditionStatus { initial, loading, success, failure }

enum RemovalStatus { initial, loading, success, failure }

class DetailState extends Equatable {
  const DetailState({
    this.invoiceToAdd,
    this.invoiceToRemove,
    this.additionStatus = AdditionStatus.initial,
    this.removalStatus = RemovalStatus.initial,
  });

  final Invoice? invoiceToAdd;
  final AdditionStatus additionStatus;
  final Invoice? invoiceToRemove;
  final RemovalStatus removalStatus;

  DetailState copyWith({
    Invoice? invoiceToAdd,
    Invoice? invoiceToRemove,
    AdditionStatus? additionStatus,
    RemovalStatus? removalStatus,
  }) {
    return DetailState(
      invoiceToAdd: invoiceToAdd ?? this.invoiceToAdd,
      invoiceToRemove: invoiceToRemove ?? this.invoiceToRemove,
      additionStatus: additionStatus ?? this.additionStatus,
      removalStatus: removalStatus ?? this.removalStatus,
    );
  }

  @override
  String toString() {
    return '''DetailState { invoiceToAdd: $invoiceToAdd, invoiceToRemove: $invoiceToRemove, additionStatus: $additionStatus, removalStatus: $removalStatus }''';
  }

  @override
  List<Object?> get props => [
        invoiceToAdd,
        invoiceToRemove,
        additionStatus,
        removalStatus,
      ];
}
