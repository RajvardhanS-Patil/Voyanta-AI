// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_db.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRecommendationDbCollection on Isar {
  IsarCollection<RecommendationDb> get recommendationDbs => this.collection();
}

const RecommendationDbSchema = CollectionSchema(
  name: r'RecommendationDb',
  id: 3389325966107576887,
  properties: {
    r'actionLabel': PropertySchema(
      id: 0,
      name: r'actionLabel',
      type: IsarType.string,
    ),
    r'description': PropertySchema(
      id: 1,
      name: r'description',
      type: IsarType.string,
    ),
    r'recommendationId': PropertySchema(
      id: 2,
      name: r'recommendationId',
      type: IsarType.string,
    ),
    r'severity': PropertySchema(
      id: 3,
      name: r'severity',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 4,
      name: r'title',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 5,
      name: r'type',
      type: IsarType.string,
    )
  },
  estimateSize: _recommendationDbEstimateSize,
  serialize: _recommendationDbSerialize,
  deserialize: _recommendationDbDeserialize,
  deserializeProp: _recommendationDbDeserializeProp,
  idName: r'id',
  indexes: {
    r'recommendationId': IndexSchema(
      id: -8056539292150424131,
      name: r'recommendationId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'recommendationId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _recommendationDbGetId,
  getLinks: _recommendationDbGetLinks,
  attach: _recommendationDbAttach,
  version: '3.1.0+1',
);

int _recommendationDbEstimateSize(
  RecommendationDb object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.actionLabel;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.recommendationId.length * 3;
  bytesCount += 3 + object.severity.length * 3;
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _recommendationDbSerialize(
  RecommendationDb object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.actionLabel);
  writer.writeString(offsets[1], object.description);
  writer.writeString(offsets[2], object.recommendationId);
  writer.writeString(offsets[3], object.severity);
  writer.writeString(offsets[4], object.title);
  writer.writeString(offsets[5], object.type);
}

RecommendationDb _recommendationDbDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RecommendationDb();
  object.actionLabel = reader.readStringOrNull(offsets[0]);
  object.description = reader.readString(offsets[1]);
  object.id = id;
  object.recommendationId = reader.readString(offsets[2]);
  object.severity = reader.readString(offsets[3]);
  object.title = reader.readString(offsets[4]);
  object.type = reader.readString(offsets[5]);
  return object;
}

P _recommendationDbDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _recommendationDbGetId(RecommendationDb object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _recommendationDbGetLinks(RecommendationDb object) {
  return [];
}

void _recommendationDbAttach(
    IsarCollection<dynamic> col, Id id, RecommendationDb object) {
  object.id = id;
}

extension RecommendationDbByIndex on IsarCollection<RecommendationDb> {
  Future<RecommendationDb?> getByRecommendationId(String recommendationId) {
    return getByIndex(r'recommendationId', [recommendationId]);
  }

  RecommendationDb? getByRecommendationIdSync(String recommendationId) {
    return getByIndexSync(r'recommendationId', [recommendationId]);
  }

  Future<bool> deleteByRecommendationId(String recommendationId) {
    return deleteByIndex(r'recommendationId', [recommendationId]);
  }

  bool deleteByRecommendationIdSync(String recommendationId) {
    return deleteByIndexSync(r'recommendationId', [recommendationId]);
  }

  Future<List<RecommendationDb?>> getAllByRecommendationId(
      List<String> recommendationIdValues) {
    final values = recommendationIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'recommendationId', values);
  }

  List<RecommendationDb?> getAllByRecommendationIdSync(
      List<String> recommendationIdValues) {
    final values = recommendationIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'recommendationId', values);
  }

  Future<int> deleteAllByRecommendationId(List<String> recommendationIdValues) {
    final values = recommendationIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'recommendationId', values);
  }

  int deleteAllByRecommendationIdSync(List<String> recommendationIdValues) {
    final values = recommendationIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'recommendationId', values);
  }

  Future<Id> putByRecommendationId(RecommendationDb object) {
    return putByIndex(r'recommendationId', object);
  }

  Id putByRecommendationIdSync(RecommendationDb object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'recommendationId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByRecommendationId(List<RecommendationDb> objects) {
    return putAllByIndex(r'recommendationId', objects);
  }

  List<Id> putAllByRecommendationIdSync(List<RecommendationDb> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'recommendationId', objects,
        saveLinks: saveLinks);
  }
}

extension RecommendationDbQueryWhereSort
    on QueryBuilder<RecommendationDb, RecommendationDb, QWhere> {
  QueryBuilder<RecommendationDb, RecommendationDb, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RecommendationDbQueryWhere
    on QueryBuilder<RecommendationDb, RecommendationDb, QWhereClause> {
  QueryBuilder<RecommendationDb, RecommendationDb, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterWhereClause>
      recommendationIdEqualTo(String recommendationId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'recommendationId',
        value: [recommendationId],
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterWhereClause>
      recommendationIdNotEqualTo(String recommendationId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'recommendationId',
              lower: [],
              upper: [recommendationId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'recommendationId',
              lower: [recommendationId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'recommendationId',
              lower: [recommendationId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'recommendationId',
              lower: [],
              upper: [recommendationId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension RecommendationDbQueryFilter
    on QueryBuilder<RecommendationDb, RecommendationDb, QFilterCondition> {
  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      actionLabelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'actionLabel',
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      actionLabelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'actionLabel',
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      actionLabelEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actionLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      actionLabelGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actionLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      actionLabelLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actionLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      actionLabelBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actionLabel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      actionLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'actionLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      actionLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'actionLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      actionLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'actionLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      actionLabelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'actionLabel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      actionLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actionLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      actionLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'actionLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      descriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
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

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      idLessThan(
    Id value, {
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

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
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

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      recommendationIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recommendationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      recommendationIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recommendationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      recommendationIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recommendationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      recommendationIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recommendationId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      recommendationIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recommendationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      recommendationIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recommendationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      recommendationIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recommendationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      recommendationIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recommendationId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      recommendationIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recommendationId',
        value: '',
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      recommendationIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recommendationId',
        value: '',
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      severityEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'severity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      severityGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'severity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      severityLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'severity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      severityBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'severity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      severityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'severity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      severityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'severity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      severityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'severity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      severityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'severity',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      severityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'severity',
        value: '',
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      severityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'severity',
        value: '',
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension RecommendationDbQueryObject
    on QueryBuilder<RecommendationDb, RecommendationDb, QFilterCondition> {}

extension RecommendationDbQueryLinks
    on QueryBuilder<RecommendationDb, RecommendationDb, QFilterCondition> {}

extension RecommendationDbQuerySortBy
    on QueryBuilder<RecommendationDb, RecommendationDb, QSortBy> {
  QueryBuilder<RecommendationDb, RecommendationDb, QAfterSortBy>
      sortByActionLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionLabel', Sort.asc);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterSortBy>
      sortByActionLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionLabel', Sort.desc);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterSortBy>
      sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterSortBy>
      sortByRecommendationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recommendationId', Sort.asc);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterSortBy>
      sortByRecommendationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recommendationId', Sort.desc);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterSortBy>
      sortBySeverity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'severity', Sort.asc);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterSortBy>
      sortBySeverityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'severity', Sort.desc);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterSortBy>
      sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension RecommendationDbQuerySortThenBy
    on QueryBuilder<RecommendationDb, RecommendationDb, QSortThenBy> {
  QueryBuilder<RecommendationDb, RecommendationDb, QAfterSortBy>
      thenByActionLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionLabel', Sort.asc);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterSortBy>
      thenByActionLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionLabel', Sort.desc);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterSortBy>
      thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterSortBy>
      thenByRecommendationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recommendationId', Sort.asc);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterSortBy>
      thenByRecommendationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recommendationId', Sort.desc);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterSortBy>
      thenBySeverity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'severity', Sort.asc);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterSortBy>
      thenBySeverityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'severity', Sort.desc);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QAfterSortBy>
      thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension RecommendationDbQueryWhereDistinct
    on QueryBuilder<RecommendationDb, RecommendationDb, QDistinct> {
  QueryBuilder<RecommendationDb, RecommendationDb, QDistinct>
      distinctByActionLabel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actionLabel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QDistinct>
      distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QDistinct>
      distinctByRecommendationId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recommendationId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QDistinct>
      distinctBySeverity({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'severity', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecommendationDb, RecommendationDb, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension RecommendationDbQueryProperty
    on QueryBuilder<RecommendationDb, RecommendationDb, QQueryProperty> {
  QueryBuilder<RecommendationDb, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RecommendationDb, String?, QQueryOperations>
      actionLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actionLabel');
    });
  }

  QueryBuilder<RecommendationDb, String, QQueryOperations>
      descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<RecommendationDb, String, QQueryOperations>
      recommendationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recommendationId');
    });
  }

  QueryBuilder<RecommendationDb, String, QQueryOperations> severityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'severity');
    });
  }

  QueryBuilder<RecommendationDb, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<RecommendationDb, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
