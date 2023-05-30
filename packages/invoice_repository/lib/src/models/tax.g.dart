// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const TaxSchema = Schema(
  name: r'Tax',
  id: 545028431726408781,
  properties: {
    r'hashCode': PropertySchema(
      id: 0,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'id': PropertySchema(
      id: 1,
      name: r'id',
      type: IsarType.long,
    ),
    r'numberOfItems': PropertySchema(
      id: 2,
      name: r'numberOfItems',
      type: IsarType.double,
    ),
    r'priceBeforeVat': PropertySchema(
      id: 3,
      name: r'priceBeforeVat',
      type: IsarType.double,
    ),
    r'stringify': PropertySchema(
      id: 4,
      name: r'stringify',
      type: IsarType.bool,
    ),
    r'vatAmount': PropertySchema(
      id: 5,
      name: r'vatAmount',
      type: IsarType.double,
    ),
    r'vatRate': PropertySchema(
      id: 6,
      name: r'vatRate',
      type: IsarType.double,
    )
  },
  estimateSize: _taxEstimateSize,
  serialize: _taxSerialize,
  deserialize: _taxDeserialize,
  deserializeProp: _taxDeserializeProp,
);

int _taxEstimateSize(
  Tax object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _taxSerialize(
  Tax object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.hashCode);
  writer.writeLong(offsets[1], object.id);
  writer.writeDouble(offsets[2], object.numberOfItems);
  writer.writeDouble(offsets[3], object.priceBeforeVat);
  writer.writeBool(offsets[4], object.stringify);
  writer.writeDouble(offsets[5], object.vatAmount);
  writer.writeDouble(offsets[6], object.vatRate);
}

Tax _taxDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Tax(
    id: reader.readLongOrNull(offsets[1]),
    numberOfItems: reader.readDoubleOrNull(offsets[2]),
    priceBeforeVat: reader.readDoubleOrNull(offsets[3]),
    vatAmount: reader.readDoubleOrNull(offsets[5]),
    vatRate: reader.readDoubleOrNull(offsets[6]),
  );
  return object;
}

P _taxDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (reader.readBoolOrNull(offset)) as P;
    case 5:
      return (reader.readDoubleOrNull(offset)) as P;
    case 6:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension TaxQueryFilter on QueryBuilder<Tax, Tax, QFilterCondition> {
  QueryBuilder<Tax, Tax, QAfterFilterCondition> hashCodeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> idEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> idGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> idLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> idBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> numberOfItemsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'numberOfItems',
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> numberOfItemsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'numberOfItems',
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> numberOfItemsEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'numberOfItems',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> numberOfItemsGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'numberOfItems',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> numberOfItemsLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'numberOfItems',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> numberOfItemsBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'numberOfItems',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> priceBeforeVatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'priceBeforeVat',
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> priceBeforeVatIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'priceBeforeVat',
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> priceBeforeVatEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priceBeforeVat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> priceBeforeVatGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'priceBeforeVat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> priceBeforeVatLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'priceBeforeVat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> priceBeforeVatBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'priceBeforeVat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> stringifyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'stringify',
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> stringifyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'stringify',
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> stringifyEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stringify',
        value: value,
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> vatAmountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'vatAmount',
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> vatAmountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'vatAmount',
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> vatAmountEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vatAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> vatAmountGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vatAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> vatAmountLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vatAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> vatAmountBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vatAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> vatRateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'vatRate',
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> vatRateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'vatRate',
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> vatRateEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vatRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> vatRateGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vatRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> vatRateLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vatRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Tax, Tax, QAfterFilterCondition> vatRateBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vatRate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension TaxQueryObject on QueryBuilder<Tax, Tax, QFilterCondition> {}
