import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'seller.g.dart';

@Collection(ignore: <String>{'props'})
class Seller extends Equatable {
  const Seller({
    this.id = Isar.autoIncrement,
    this.idType,
    this.idNum,
    this.name,
    this.address,
    this.town,
    this.country,
  });

  final Id id;
  final String? idType;
  final String? idNum;
  final String? name;
  final String? address;
  final String? town;
  final String? country;

  factory Seller.fromJsonAndId(Map<String, dynamic> json, int id) {
    final seller = Seller(
      id: id,
      idType: json['idType'],
      idNum: json['idNum'],
      name: json['name'],
      address: json['address'],
      town: json['town'],
      country: json['country'],
    );

    return seller;
  }

  @override
  List<Object?> get props => [id, idType, idNum, name, address, town, country];
}
