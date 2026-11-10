// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_recovery_collection.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

extension GetMonthlyRecoveryCollectionCollection on Isar {
  IsarCollection<MonthlyRecoveryCollection> get monthlyRecoveryCollections =>
      this.collection();
}

const MonthlyRecoveryCollectionSchema = CollectionSchema(
  name: r'MonthlyRecoveryCollection',
  id: -6742395801218318858,
  properties: {
    r'id': PropertySchema(id: 0, name: r'id', type: IsarType.string),
    r'interestEncrypted': PropertySchema(
      id: 1,
      name: r'interestEncrypted',
      type: IsarType.string,
    ),
    r'isReviewed': PropertySchema(
      id: 2,
      name: r'isReviewed',
      type: IsarType.bool,
    ),
    r'loanId': PropertySchema(id: 3, name: r'loanId', type: IsarType.string),
    r'month': PropertySchema(id: 4, name: r'month', type: IsarType.long),
    r'otherChargesEncrypted': PropertySchema(
      id: 5,
      name: r'otherChargesEncrypted',
      type: IsarType.string,
    ),
    r'penalInterestEncrypted': PropertySchema(
      id: 6,
      name: r'penalInterestEncrypted',
      type: IsarType.string,
    ),
    r'principalDueEncrypted': PropertySchema(
      id: 7,
      name: r'principalDueEncrypted',
      type: IsarType.string,
    ),
    r'year': PropertySchema(id: 8, name: r'year', type: IsarType.long),
  },

  estimateSize: _monthlyRecoveryCollectionEstimateSize,
  serialize: _monthlyRecoveryCollectionSerialize,
  deserialize: _monthlyRecoveryCollectionDeserialize,
  deserializeProp: _monthlyRecoveryCollectionDeserializeProp,
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
    r'loanId_month_year': IndexSchema(
      id: -8076549569787784278,
      name: r'loanId_month_year',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'loanId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'month',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'year',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'year_month': IndexSchema(
      id: -3509244304425196138,
      name: r'year_month',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'year',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'month',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _monthlyRecoveryCollectionGetId,
  getLinks: _monthlyRecoveryCollectionGetLinks,
  attach: _monthlyRecoveryCollectionAttach,
  version: '3.4.1',
);

int _monthlyRecoveryCollectionEstimateSize(
  MonthlyRecoveryCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.interestEncrypted.length * 3;
  bytesCount += 3 + object.loanId.length * 3;
  bytesCount += 3 + object.otherChargesEncrypted.length * 3;
  bytesCount += 3 + object.penalInterestEncrypted.length * 3;
  bytesCount += 3 + object.principalDueEncrypted.length * 3;
  return bytesCount;
}

void _monthlyRecoveryCollectionSerialize(
  MonthlyRecoveryCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.id);
  writer.writeString(offsets[1], object.interestEncrypted);
  writer.writeBool(offsets[2], object.isReviewed);
  writer.writeString(offsets[3], object.loanId);
  writer.writeLong(offsets[4], object.month);
  writer.writeString(offsets[5], object.otherChargesEncrypted);
  writer.writeString(offsets[6], object.penalInterestEncrypted);
  writer.writeString(offsets[7], object.principalDueEncrypted);
  writer.writeLong(offsets[8], object.year);
}

MonthlyRecoveryCollection _monthlyRecoveryCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MonthlyRecoveryCollection();
  object.id = reader.readString(offsets[0]);
  object.interestEncrypted = reader.readString(offsets[1]);
  object.isReviewed = reader.readBool(offsets[2]);
  object.isarId = id;
  object.loanId = reader.readString(offsets[3]);
  object.month = reader.readLong(offsets[4]);
  object.otherChargesEncrypted = reader.readString(offsets[5]);
  object.penalInterestEncrypted = reader.readString(offsets[6]);
  object.principalDueEncrypted = reader.readString(offsets[7]);
  object.year = reader.readLong(offsets[8]);
  return object;
}

P _monthlyRecoveryCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _monthlyRecoveryCollectionGetId(MonthlyRecoveryCollection object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _monthlyRecoveryCollectionGetLinks(
  MonthlyRecoveryCollection object,
) {
  return [];
}

void _monthlyRecoveryCollectionAttach(
  IsarCollection<dynamic> col,
  Id id,
  MonthlyRecoveryCollection object,
) {
  object.isarId = id;
}

extension MonthlyRecoveryCollectionByIndex
    on IsarCollection<MonthlyRecoveryCollection> {
  Future<MonthlyRecoveryCollection?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  MonthlyRecoveryCollection? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<MonthlyRecoveryCollection?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<MonthlyRecoveryCollection?> getAllByIdSync(List<String> idValues) {
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

  Future<Id> putById(MonthlyRecoveryCollection object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(MonthlyRecoveryCollection object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<MonthlyRecoveryCollection> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(
    List<MonthlyRecoveryCollection> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension MonthlyRecoveryCollectionQueryWhereSort
    on
        QueryBuilder<
          MonthlyRecoveryCollection,
          MonthlyRecoveryCollection,
          QWhere
        > {
  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhere
  >
  anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhere
  >
  anyYearMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'year_month'),
      );
    });
  }
}

extension MonthlyRecoveryCollectionQueryWhere
    on
        QueryBuilder<
          MonthlyRecoveryCollection,
          MonthlyRecoveryCollection,
          QWhereClause
        > {
  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
  isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(lower: isarId, upper: isarId),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
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

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
  isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
  isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
  isarIdBetween(
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

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
  idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'id', value: [id]),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
  idNotEqualTo(String id) {
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

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
  loanIdEqualToAnyMonthYear(String loanId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'loanId_month_year',
          value: [loanId],
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
  loanIdNotEqualToAnyMonthYear(String loanId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'loanId_month_year',
                lower: [],
                upper: [loanId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'loanId_month_year',
                lower: [loanId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'loanId_month_year',
                lower: [loanId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'loanId_month_year',
                lower: [],
                upper: [loanId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
  loanIdMonthEqualToAnyYear(String loanId, int month) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'loanId_month_year',
          value: [loanId, month],
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
  loanIdEqualToMonthNotEqualToAnyYear(String loanId, int month) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'loanId_month_year',
                lower: [loanId],
                upper: [loanId, month],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'loanId_month_year',
                lower: [loanId, month],
                includeLower: false,
                upper: [loanId],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'loanId_month_year',
                lower: [loanId, month],
                includeLower: false,
                upper: [loanId],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'loanId_month_year',
                lower: [loanId],
                upper: [loanId, month],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
  loanIdEqualToMonthGreaterThanAnyYear(
    String loanId,
    int month, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'loanId_month_year',
          lower: [loanId, month],
          includeLower: include,
          upper: [loanId],
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
  loanIdEqualToMonthLessThanAnyYear(
    String loanId,
    int month, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'loanId_month_year',
          lower: [loanId],
          upper: [loanId, month],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
  loanIdEqualToMonthBetweenAnyYear(
    String loanId,
    int lowerMonth,
    int upperMonth, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'loanId_month_year',
          lower: [loanId, lowerMonth],
          includeLower: includeLower,
          upper: [loanId, upperMonth],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
  loanIdMonthYearEqualTo(String loanId, int month, int year) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'loanId_month_year',
          value: [loanId, month, year],
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
  loanIdMonthEqualToYearNotEqualTo(String loanId, int month, int year) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'loanId_month_year',
                lower: [loanId, month],
                upper: [loanId, month, year],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'loanId_month_year',
                lower: [loanId, month, year],
                includeLower: false,
                upper: [loanId, month],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'loanId_month_year',
                lower: [loanId, month, year],
                includeLower: false,
                upper: [loanId, month],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'loanId_month_year',
                lower: [loanId, month],
                upper: [loanId, month, year],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
  loanIdMonthEqualToYearGreaterThan(
    String loanId,
    int month,
    int year, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'loanId_month_year',
          lower: [loanId, month, year],
          includeLower: include,
          upper: [loanId, month],
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
  loanIdMonthEqualToYearLessThan(
    String loanId,
    int month,
    int year, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'loanId_month_year',
          lower: [loanId, month],
          upper: [loanId, month, year],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
  loanIdMonthEqualToYearBetween(
    String loanId,
    int month,
    int lowerYear,
    int upperYear, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'loanId_month_year',
          lower: [loanId, month, lowerYear],
          includeLower: includeLower,
          upper: [loanId, month, upperYear],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
  yearEqualToAnyMonth(int year) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'year_month', value: [year]),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
  yearNotEqualToAnyMonth(int year) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'year_month',
                lower: [],
                upper: [year],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'year_month',
                lower: [year],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'year_month',
                lower: [year],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'year_month',
                lower: [],
                upper: [year],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
  yearGreaterThanAnyMonth(int year, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'year_month',
          lower: [year],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
  yearLessThanAnyMonth(int year, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'year_month',
          lower: [],
          upper: [year],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
  yearBetweenAnyMonth(
    int lowerYear,
    int upperYear, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'year_month',
          lower: [lowerYear],
          includeLower: includeLower,
          upper: [upperYear],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
  yearMonthEqualTo(int year, int month) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'year_month',
          value: [year, month],
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
  yearEqualToMonthNotEqualTo(int year, int month) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'year_month',
                lower: [year],
                upper: [year, month],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'year_month',
                lower: [year, month],
                includeLower: false,
                upper: [year],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'year_month',
                lower: [year, month],
                includeLower: false,
                upper: [year],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'year_month',
                lower: [year],
                upper: [year, month],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
  yearEqualToMonthGreaterThan(int year, int month, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'year_month',
          lower: [year, month],
          includeLower: include,
          upper: [year],
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
  yearEqualToMonthLessThan(int year, int month, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'year_month',
          lower: [year],
          upper: [year, month],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterWhereClause
  >
  yearEqualToMonthBetween(
    int year,
    int lowerMonth,
    int upperMonth, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'year_month',
          lower: [year, lowerMonth],
          includeLower: includeLower,
          upper: [year, upperMonth],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension MonthlyRecoveryCollectionQueryFilter
    on
        QueryBuilder<
          MonthlyRecoveryCollection,
          MonthlyRecoveryCollection,
          QFilterCondition
        > {
  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  idEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  idBetween(
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

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  idMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: ''),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'id', value: ''),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  interestEncryptedEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'interestEncrypted',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  interestEncryptedGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'interestEncrypted',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  interestEncryptedLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'interestEncrypted',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  interestEncryptedBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'interestEncrypted',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  interestEncryptedStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'interestEncrypted',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  interestEncryptedEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'interestEncrypted',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  interestEncryptedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'interestEncrypted',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  interestEncryptedMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'interestEncrypted',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  interestEncryptedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'interestEncrypted', value: ''),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  interestEncryptedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'interestEncrypted', value: ''),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  isReviewedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isReviewed', value: value),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isarId', value: value),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  loanIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'loanId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  loanIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'loanId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  loanIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'loanId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  loanIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'loanId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  loanIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'loanId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  loanIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'loanId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  loanIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'loanId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  loanIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'loanId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  loanIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'loanId', value: ''),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  loanIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'loanId', value: ''),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  monthEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'month', value: value),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  monthGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'month',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  monthLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'month',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  monthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'month',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  otherChargesEncryptedEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'otherChargesEncrypted',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  otherChargesEncryptedGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'otherChargesEncrypted',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  otherChargesEncryptedLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'otherChargesEncrypted',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  otherChargesEncryptedBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'otherChargesEncrypted',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  otherChargesEncryptedStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'otherChargesEncrypted',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  otherChargesEncryptedEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'otherChargesEncrypted',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  otherChargesEncryptedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'otherChargesEncrypted',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  otherChargesEncryptedMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'otherChargesEncrypted',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  otherChargesEncryptedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'otherChargesEncrypted', value: ''),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  otherChargesEncryptedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'otherChargesEncrypted',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  penalInterestEncryptedEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'penalInterestEncrypted',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  penalInterestEncryptedGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'penalInterestEncrypted',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  penalInterestEncryptedLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'penalInterestEncrypted',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  penalInterestEncryptedBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'penalInterestEncrypted',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  penalInterestEncryptedStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'penalInterestEncrypted',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  penalInterestEncryptedEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'penalInterestEncrypted',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  penalInterestEncryptedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'penalInterestEncrypted',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  penalInterestEncryptedMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'penalInterestEncrypted',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  penalInterestEncryptedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'penalInterestEncrypted', value: ''),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  penalInterestEncryptedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'penalInterestEncrypted',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  principalDueEncryptedEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'principalDueEncrypted',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  principalDueEncryptedGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'principalDueEncrypted',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  principalDueEncryptedLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'principalDueEncrypted',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  principalDueEncryptedBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'principalDueEncrypted',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  principalDueEncryptedStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'principalDueEncrypted',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  principalDueEncryptedEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'principalDueEncrypted',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  principalDueEncryptedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'principalDueEncrypted',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  principalDueEncryptedMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'principalDueEncrypted',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  principalDueEncryptedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'principalDueEncrypted', value: ''),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  principalDueEncryptedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'principalDueEncrypted',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  yearEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'year', value: value),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  yearGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'year',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  yearLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'year',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterFilterCondition
  >
  yearBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'year',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension MonthlyRecoveryCollectionQueryObject
    on
        QueryBuilder<
          MonthlyRecoveryCollection,
          MonthlyRecoveryCollection,
          QFilterCondition
        > {}

extension MonthlyRecoveryCollectionQueryLinks
    on
        QueryBuilder<
          MonthlyRecoveryCollection,
          MonthlyRecoveryCollection,
          QFilterCondition
        > {}

extension MonthlyRecoveryCollectionQuerySortBy
    on
        QueryBuilder<
          MonthlyRecoveryCollection,
          MonthlyRecoveryCollection,
          QSortBy
        > {
  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  sortByInterestEncrypted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interestEncrypted', Sort.asc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  sortByInterestEncryptedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interestEncrypted', Sort.desc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  sortByIsReviewed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isReviewed', Sort.asc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  sortByIsReviewedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isReviewed', Sort.desc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  sortByLoanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loanId', Sort.asc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  sortByLoanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loanId', Sort.desc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  sortByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.asc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  sortByMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.desc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  sortByOtherChargesEncrypted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'otherChargesEncrypted', Sort.asc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  sortByOtherChargesEncryptedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'otherChargesEncrypted', Sort.desc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  sortByPenalInterestEncrypted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'penalInterestEncrypted', Sort.asc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  sortByPenalInterestEncryptedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'penalInterestEncrypted', Sort.desc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  sortByPrincipalDueEncrypted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'principalDueEncrypted', Sort.asc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  sortByPrincipalDueEncryptedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'principalDueEncrypted', Sort.desc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  sortByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  sortByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension MonthlyRecoveryCollectionQuerySortThenBy
    on
        QueryBuilder<
          MonthlyRecoveryCollection,
          MonthlyRecoveryCollection,
          QSortThenBy
        > {
  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  thenByInterestEncrypted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interestEncrypted', Sort.asc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  thenByInterestEncryptedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interestEncrypted', Sort.desc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  thenByIsReviewed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isReviewed', Sort.asc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  thenByIsReviewedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isReviewed', Sort.desc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  thenByLoanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loanId', Sort.asc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  thenByLoanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loanId', Sort.desc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  thenByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.asc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  thenByMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.desc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  thenByOtherChargesEncrypted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'otherChargesEncrypted', Sort.asc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  thenByOtherChargesEncryptedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'otherChargesEncrypted', Sort.desc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  thenByPenalInterestEncrypted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'penalInterestEncrypted', Sort.asc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  thenByPenalInterestEncryptedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'penalInterestEncrypted', Sort.desc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  thenByPrincipalDueEncrypted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'principalDueEncrypted', Sort.asc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  thenByPrincipalDueEncryptedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'principalDueEncrypted', Sort.desc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  thenByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<
    MonthlyRecoveryCollection,
    MonthlyRecoveryCollection,
    QAfterSortBy
  >
  thenByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension MonthlyRecoveryCollectionQueryWhereDistinct
    on
        QueryBuilder<
          MonthlyRecoveryCollection,
          MonthlyRecoveryCollection,
          QDistinct
        > {
  QueryBuilder<MonthlyRecoveryCollection, MonthlyRecoveryCollection, QDistinct>
  distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MonthlyRecoveryCollection, MonthlyRecoveryCollection, QDistinct>
  distinctByInterestEncrypted({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'interestEncrypted',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<MonthlyRecoveryCollection, MonthlyRecoveryCollection, QDistinct>
  distinctByIsReviewed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isReviewed');
    });
  }

  QueryBuilder<MonthlyRecoveryCollection, MonthlyRecoveryCollection, QDistinct>
  distinctByLoanId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'loanId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MonthlyRecoveryCollection, MonthlyRecoveryCollection, QDistinct>
  distinctByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'month');
    });
  }

  QueryBuilder<MonthlyRecoveryCollection, MonthlyRecoveryCollection, QDistinct>
  distinctByOtherChargesEncrypted({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'otherChargesEncrypted',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<MonthlyRecoveryCollection, MonthlyRecoveryCollection, QDistinct>
  distinctByPenalInterestEncrypted({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'penalInterestEncrypted',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<MonthlyRecoveryCollection, MonthlyRecoveryCollection, QDistinct>
  distinctByPrincipalDueEncrypted({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'principalDueEncrypted',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<MonthlyRecoveryCollection, MonthlyRecoveryCollection, QDistinct>
  distinctByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'year');
    });
  }
}

extension MonthlyRecoveryCollectionQueryProperty
    on
        QueryBuilder<
          MonthlyRecoveryCollection,
          MonthlyRecoveryCollection,
          QQueryProperty
        > {
  QueryBuilder<MonthlyRecoveryCollection, int, QQueryOperations>
  isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<MonthlyRecoveryCollection, String, QQueryOperations>
  idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MonthlyRecoveryCollection, String, QQueryOperations>
  interestEncryptedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'interestEncrypted');
    });
  }

  QueryBuilder<MonthlyRecoveryCollection, bool, QQueryOperations>
  isReviewedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isReviewed');
    });
  }

  QueryBuilder<MonthlyRecoveryCollection, String, QQueryOperations>
  loanIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'loanId');
    });
  }

  QueryBuilder<MonthlyRecoveryCollection, int, QQueryOperations>
  monthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'month');
    });
  }

  QueryBuilder<MonthlyRecoveryCollection, String, QQueryOperations>
  otherChargesEncryptedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'otherChargesEncrypted');
    });
  }

  QueryBuilder<MonthlyRecoveryCollection, String, QQueryOperations>
  penalInterestEncryptedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'penalInterestEncrypted');
    });
  }

  QueryBuilder<MonthlyRecoveryCollection, String, QQueryOperations>
  principalDueEncryptedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'principalDueEncrypted');
    });
  }

  QueryBuilder<MonthlyRecoveryCollection, int, QQueryOperations>
  yearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'year');
    });
  }
}
