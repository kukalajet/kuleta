part of 'detail_bloc.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();

  @override
  List<Object> get props => [];
}

class AddInvoice extends DetailEvent {
  const AddInvoice(this.value);

  final Invoice value;

  @override
  List<Object> get props => [value];
}

class DeleteInvoice extends DetailEvent {
  const DeleteInvoice(this.value);

  final Invoice value;

  @override
  List<Object> get props => [value];
}
