// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_collection.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

extension GetLoanCollectionCollection on Isar {
  IsarCollection<LoanCollection> get loanCollections => this.collection();
}

const LoanCollectionSchema = CollectionSchema(
  name: r'LoanCollection',
  id: 1341771323827943027,
  properties: {
    r'accountNo': PropertySchema(
      id: 0,
      name: r'accountNo',
      type: IsarType.string,
    ),
    r'baseEmiAmount': PropertySchema(
      id: 1,
      name: r'baseEmiAmount',
      type: IsarType.double,
    ),
    r'customerId': PropertySchema(
      id: 2,
      name: r'customerId',
      type: IsarType.string,
    ),
    r'id': PropertySchema(id: 3, name: r'id', type: IsarType.string),
    r'principalOutstanding': PropertySchema(
      id: 4,
      name: r'principalOutstanding',
      type: IsarType.double,
    ),
    r'status': PropertySchema(id: 5, name: r'status', type: IsarType.string),
  },

  estimateSize: _loanCollectionEstimateSize,
  serialize: _loanCollectionSerialize,
  deserialize: _loanCollectionDeserialize,
  deserializeProp: _loanCollectionDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'customerId': IndexSchema(
      id: 1498639901530368639,
      name: r'customerId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'customerId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'accountNo': IndexSchema(
      id: 2373833044851941512,
      name: r'accountNo',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'accountNo',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'status': IndexSchema(
      id: -107785170620420283,
      name: r'status',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'status',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _loanCollectionGetId,
  getLinks: _loanCollectionGetLinks,
  attach: _loanCollectionAttach,
  version: '3.4.1',
);

int _loanCollectionEstimateSize(
  LoanCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accountNo.length * 3;
  bytesCount += 3 + object.customerId.length * 3;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.status.length * 3;
  return bytesCount;
}

void _loanCollectionSerialize(
  LoanCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accountNo);
  writer.writeDouble(offsets[1], object.baseEmiAmount);
  writer.writeString(offsets[2], object.customerId);
  writer.writeString(offsets[3], object.id);
  writer.writeDouble(offsets[4], object.principalOutstanding);
  writer.writeString(offsets[5], object.status);
}

LoanCollection _loanCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LoanCollection();
  object.accountNo = reader.readString(offsets[0]);
  object.baseEmiAmount = reader.readDouble(offsets[1]);
  object.customerId = reader.readString(offsets[2]);
  object.id = reader.readString(offsets[3]);
  object.isarId = id;
  object.principalOutstanding = reader.readDouble(offsets[4]);
  object.status = reader.readString(offsets[5]);
  return object;
}

P _loanCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _loanCollectionGetId(LoanCollection object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _loanCollectionGetLinks(LoanCollection object) {
  return [];
}

void _loanCollectionAttach(
  IsarCollection<dynamic> col,
  Id id,
  LoanCollection object,
) {
  object.isarId = id;
}

extension LoanCollectionByIndex on IsarCollection<LoanCollection> {
  Future<LoanCollection?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  LoanCollection? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<LoanCollection?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<LoanCollection?> getAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'id', values);
  }

  Future<int> deleteAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'id', values);
  }

  int deleteAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'id', values);
  }

  Future<Id> putById(LoanCollection object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(LoanCollection object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<LoanCollection> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(
    List<LoanCollection> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension LoanCollectionQueryWhereSort
    on QueryBuilder<LoanCollection, LoanCollection, QWhere> {
  QueryBuilder<LoanCollection, LoanCollection, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LoanCollectionQueryWhere
    on QueryBuilder<LoanCollection, LoanCollection, QWhereClause> {
  QueryBuilder<LoanCollection, LoanCollection, QAfterWhereClause> isarIdEqualTo(
    Id isarId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(lower: isarId, upper: isarId),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterWhereClause>
  isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterWhereClause>
  isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterWhereClause>
  isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerIsarId,
          includeLower: includeLower,
          upper: upperIsarId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterWhereClause> idEqualTo(
    String id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'id', value: [id]),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterWhereClause> idNotEqualTo(
    String id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [],
                upper: [id],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [id],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [id],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [],
                upper: [id],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterWhereClause>
  customerIdEqualTo(String customerId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'customerId', value: [customerId]),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterWhereClause>
  customerIdNotEqualTo(String customerId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'customerId',
                lower: [],
                upper: [customerId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'customerId',
                lower: [customerId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'customerId',
                lower: [customerId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'customerId',
                lower: [],
                upper: [customerId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterWhereClause>
  accountNoEqualTo(String accountNo) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'accountNo', value: [accountNo]),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterWhereClause>
  accountNoNotEqualTo(String accountNo) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountNo',
                lower: [],
                upper: [accountNo],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountNo',
                lower: [accountNo],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountNo',
                lower: [accountNo],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountNo',
                lower: [],
                upper: [accountNo],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterWhereClause> statusEqualTo(
    String status,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'status', value: [status]),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterWhereClause>
  statusNotEqualTo(String status) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [],
                upper: [status],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [status],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [status],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [],
                upper: [status],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension LoanCollectionQueryFilter
    on QueryBuilder<LoanCollection, LoanCollection, QFilterCondition> {
  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  accountNoEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'accountNo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  accountNoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'accountNo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  accountNoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'accountNo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  accountNoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'accountNo',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  accountNoStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'accountNo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  accountNoEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'accountNo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  accountNoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'accountNo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  accountNoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'accountNo',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  accountNoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'accountNo', value: ''),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  accountNoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'accountNo', value: ''),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  baseEmiAmountEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'baseEmiAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  baseEmiAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'baseEmiAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  baseEmiAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'baseEmiAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  baseEmiAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'baseEmiAmount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  customerIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'customerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  customerIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'customerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  customerIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'customerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  customerIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'customerId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  customerIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'customerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  customerIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'customerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  customerIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'customerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  customerIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'customerId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  customerIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'customerId', value: ''),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  customerIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'customerId', value: ''),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  idLessThan(String value, {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  idStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  idEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition> idMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'id',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: ''),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'id', value: ''),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isarId', value: value),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  isarIdGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'isarId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  isarIdLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'isarId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'isarId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  principalOutstandingEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'principalOutstanding',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  principalOutstandingGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'principalOutstanding',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  principalOutstandingLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'principalOutstanding',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  principalOutstandingBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'principalOutstanding',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  statusEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'status',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  statusStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  statusEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'status',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterFilterCondition>
  statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'status', value: ''),
      );
    });
  }
}

extension LoanCollectionQueryObject
    on QueryBuilder<LoanCollection, LoanCollection, QFilterCondition> {}

extension LoanCollectionQueryLinks
    on QueryBuilder<LoanCollection, LoanCollection, QFilterCondition> {}

extension LoanCollectionQuerySortBy
    on QueryBuilder<LoanCollection, LoanCollection, QSortBy> {
  QueryBuilder<LoanCollection, LoanCollection, QAfterSortBy> sortByAccountNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountNo', Sort.asc);
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterSortBy>
  sortByAccountNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountNo', Sort.desc);
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterSortBy>
  sortByBaseEmiAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseEmiAmount', Sort.asc);
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterSortBy>
  sortByBaseEmiAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseEmiAmount', Sort.desc);
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterSortBy>
  sortByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.asc);
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterSortBy>
  sortByCustomerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.desc);
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterSortBy>
  sortByPrincipalOutstanding() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'principalOutstanding', Sort.asc);
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterSortBy>
  sortByPrincipalOutstandingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'principalOutstanding', Sort.desc);
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterSortBy>
  sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension LoanCollectionQuerySortThenBy
    on QueryBuilder<LoanCollection, LoanCollection, QSortThenBy> {
  QueryBuilder<LoanCollection, LoanCollection, QAfterSortBy> thenByAccountNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountNo', Sort.asc);
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterSortBy>
  thenByAccountNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountNo', Sort.desc);
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterSortBy>
  thenByBaseEmiAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseEmiAmount', Sort.asc);
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterSortBy>
  thenByBaseEmiAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseEmiAmount', Sort.desc);
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterSortBy>
  thenByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.asc);
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterSortBy>
  thenByCustomerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.desc);
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterSortBy>
  thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterSortBy>
  thenByPrincipalOutstanding() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'principalOutstanding', Sort.asc);
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterSortBy>
  thenByPrincipalOutstandingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'principalOutstanding', Sort.desc);
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QAfterSortBy>
  thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension LoanCollectionQueryWhereDistinct
    on QueryBuilder<LoanCollection, LoanCollection, QDistinct> {
  QueryBuilder<LoanCollection, LoanCollection, QDistinct> distinctByAccountNo({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accountNo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QDistinct>
  distinctByBaseEmiAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'baseEmiAmount');
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QDistinct> distinctByCustomerId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QDistinct> distinctById({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QDistinct>
  distinctByPrincipalOutstanding() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'principalOutstanding');
    });
  }

  QueryBuilder<LoanCollection, LoanCollection, QDistinct> distinctByStatus({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }
}

extension LoanCollectionQueryProperty
    on QueryBuilder<LoanCollection, LoanCollection, QQueryProperty> {
  QueryBuilder<LoanCollection, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<LoanCollection, String, QQueryOperations> accountNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountNo');
    });
  }

  QueryBuilder<LoanCollection, double, QQueryOperations>
  baseEmiAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'baseEmiAmount');
    });
  }

  QueryBuilder<LoanCollection, String, QQueryOperations> customerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerId');
    });
  }

  QueryBuilder<LoanCollection, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LoanCollection, double, QQueryOperations>
  principalOutstandingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'principalOutstanding');
    });
  }

  QueryBuilder<LoanCollection, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }
}
