// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_progress_db.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetJourneyProgressDbCollection on Isar {
  IsarCollection<JourneyProgressDb> get journeyProgressDbs => this.collection();
}

const JourneyProgressDbSchema = CollectionSchema(
  name: r'JourneyProgressDb',
  id: -5661719192001354037,
  properties: {
    r'activeItineraryJson': PropertySchema(
      id: 0,
      name: r'activeItineraryJson',
      type: IsarType.string,
    ),
    r'currentActivityIndex': PropertySchema(
      id: 1,
      name: r'currentActivityIndex',
      type: IsarType.long,
    ),
    r'currentLatitude': PropertySchema(
      id: 2,
      name: r'currentLatitude',
      type: IsarType.double,
    ),
    r'currentLongitude': PropertySchema(
      id: 3,
      name: r'currentLongitude',
      type: IsarType.double,
    ),
    r'lastUpdated': PropertySchema(
      id: 4,
      name: r'lastUpdated',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(id: 5, name: r'status', type: IsarType.string),
    r'tripId': PropertySchema(id: 6, name: r'tripId', type: IsarType.string),
  },
  estimateSize: _journeyProgressDbEstimateSize,
  serialize: _journeyProgressDbSerialize,
  deserialize: _journeyProgressDbDeserialize,
  deserializeProp: _journeyProgressDbDeserializeProp,
  idName: r'id',
  indexes: {
    r'tripId': IndexSchema(
      id: 7734156669642746260,
      name: r'tripId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'tripId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},
  getId: _journeyProgressDbGetId,
  getLinks: _journeyProgressDbGetLinks,
  attach: _journeyProgressDbAttach,
  version: '3.1.0+1',
);

int _journeyProgressDbEstimateSize(
  JourneyProgressDb object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.activeItineraryJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.status.length * 3;
  bytesCount += 3 + object.tripId.length * 3;
  return bytesCount;
}

void _journeyProgressDbSerialize(
  JourneyProgressDb object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.activeItineraryJson);
  writer.writeLong(offsets[1], object.currentActivityIndex);
  writer.writeDouble(offsets[2], object.currentLatitude);
  writer.writeDouble(offsets[3], object.currentLongitude);
  writer.writeDateTime(offsets[4], object.lastUpdated);
  writer.writeString(offsets[5], object.status);
  writer.writeString(offsets[6], object.tripId);
}

JourneyProgressDb _journeyProgressDbDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = JourneyProgressDb();
  object.activeItineraryJson = reader.readStringOrNull(offsets[0]);
  object.currentActivityIndex = reader.readLong(offsets[1]);
  object.currentLatitude = reader.readDouble(offsets[2]);
  object.currentLongitude = reader.readDouble(offsets[3]);
  object.id = id;
  object.lastUpdated = reader.readDateTime(offsets[4]);
  object.status = reader.readString(offsets[5]);
  object.tripId = reader.readString(offsets[6]);
  return object;
}

P _journeyProgressDbDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _journeyProgressDbGetId(JourneyProgressDb object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _journeyProgressDbGetLinks(
  JourneyProgressDb object,
) {
  return [];
}

void _journeyProgressDbAttach(
  IsarCollection<dynamic> col,
  Id id,
  JourneyProgressDb object,
) {
  object.id = id;
}

extension JourneyProgressDbByIndex on IsarCollection<JourneyProgressDb> {
  Future<JourneyProgressDb?> getByTripId(String tripId) {
    return getByIndex(r'tripId', [tripId]);
  }

  JourneyProgressDb? getByTripIdSync(String tripId) {
    return getByIndexSync(r'tripId', [tripId]);
  }

  Future<bool> deleteByTripId(String tripId) {
    return deleteByIndex(r'tripId', [tripId]);
  }

  bool deleteByTripIdSync(String tripId) {
    return deleteByIndexSync(r'tripId', [tripId]);
  }

  Future<List<JourneyProgressDb?>> getAllByTripId(List<String> tripIdValues) {
    final values = tripIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'tripId', values);
  }

  List<JourneyProgressDb?> getAllByTripIdSync(List<String> tripIdValues) {
    final values = tripIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'tripId', values);
  }

  Future<int> deleteAllByTripId(List<String> tripIdValues) {
    final values = tripIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'tripId', values);
  }

  int deleteAllByTripIdSync(List<String> tripIdValues) {
    final values = tripIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'tripId', values);
  }

  Future<Id> putByTripId(JourneyProgressDb object) {
    return putByIndex(r'tripId', object);
  }

  Id putByTripIdSync(JourneyProgressDb object, {bool saveLinks = true}) {
    return putByIndexSync(r'tripId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByTripId(List<JourneyProgressDb> objects) {
    return putAllByIndex(r'tripId', objects);
  }

  List<Id> putAllByTripIdSync(
    List<JourneyProgressDb> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'tripId', objects, saveLinks: saveLinks);
  }
}

extension JourneyProgressDbQueryWhereSort
    on QueryBuilder<JourneyProgressDb, JourneyProgressDb, QWhere> {
  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension JourneyProgressDbQueryWhere
    on QueryBuilder<JourneyProgressDb, JourneyProgressDb, QWhereClause> {
  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterWhereClause>
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

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterWhereClause>
  idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterWhereClause>
  tripIdEqualTo(String tripId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'tripId', value: [tripId]),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterWhereClause>
  tripIdNotEqualTo(String tripId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tripId',
                lower: [],
                upper: [tripId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tripId',
                lower: [tripId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tripId',
                lower: [tripId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tripId',
                lower: [],
                upper: [tripId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension JourneyProgressDbQueryFilter
    on QueryBuilder<JourneyProgressDb, JourneyProgressDb, QFilterCondition> {
  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  activeItineraryJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'activeItineraryJson'),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  activeItineraryJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'activeItineraryJson'),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  activeItineraryJsonEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'activeItineraryJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  activeItineraryJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'activeItineraryJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  activeItineraryJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'activeItineraryJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  activeItineraryJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'activeItineraryJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  activeItineraryJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'activeItineraryJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  activeItineraryJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'activeItineraryJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  activeItineraryJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'activeItineraryJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  activeItineraryJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'activeItineraryJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  activeItineraryJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'activeItineraryJson', value: ''),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  activeItineraryJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'activeItineraryJson',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  currentActivityIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'currentActivityIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  currentActivityIndexGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'currentActivityIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  currentActivityIndexLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'currentActivityIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  currentActivityIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'currentActivityIndex',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  currentLatitudeEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'currentLatitude',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  currentLatitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'currentLatitude',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  currentLatitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'currentLatitude',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  currentLatitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'currentLatitude',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  currentLongitudeEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'currentLongitude',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  currentLongitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'currentLongitude',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  currentLongitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'currentLongitude',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  currentLongitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'currentLongitude',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  lastUpdatedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastUpdated', value: value),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  lastUpdatedGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastUpdated',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  lastUpdatedLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastUpdated',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  lastUpdatedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastUpdated',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
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

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
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

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
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

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
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

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
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

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
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

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
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

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
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

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  tripIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'tripId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  tripIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'tripId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  tripIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'tripId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  tripIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'tripId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  tripIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'tripId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  tripIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'tripId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  tripIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'tripId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  tripIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'tripId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  tripIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tripId', value: ''),
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterFilterCondition>
  tripIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'tripId', value: ''),
      );
    });
  }
}

extension JourneyProgressDbQueryObject
    on QueryBuilder<JourneyProgressDb, JourneyProgressDb, QFilterCondition> {}

extension JourneyProgressDbQueryLinks
    on QueryBuilder<JourneyProgressDb, JourneyProgressDb, QFilterCondition> {}

extension JourneyProgressDbQuerySortBy
    on QueryBuilder<JourneyProgressDb, JourneyProgressDb, QSortBy> {
  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  sortByActiveItineraryJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeItineraryJson', Sort.asc);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  sortByActiveItineraryJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeItineraryJson', Sort.desc);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  sortByCurrentActivityIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentActivityIndex', Sort.asc);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  sortByCurrentActivityIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentActivityIndex', Sort.desc);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  sortByCurrentLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentLatitude', Sort.asc);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  sortByCurrentLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentLatitude', Sort.desc);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  sortByCurrentLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentLongitude', Sort.asc);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  sortByCurrentLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentLongitude', Sort.desc);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  sortByTripId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tripId', Sort.asc);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  sortByTripIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tripId', Sort.desc);
    });
  }
}

extension JourneyProgressDbQuerySortThenBy
    on QueryBuilder<JourneyProgressDb, JourneyProgressDb, QSortThenBy> {
  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  thenByActiveItineraryJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeItineraryJson', Sort.asc);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  thenByActiveItineraryJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeItineraryJson', Sort.desc);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  thenByCurrentActivityIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentActivityIndex', Sort.asc);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  thenByCurrentActivityIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentActivityIndex', Sort.desc);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  thenByCurrentLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentLatitude', Sort.asc);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  thenByCurrentLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentLatitude', Sort.desc);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  thenByCurrentLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentLongitude', Sort.asc);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  thenByCurrentLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentLongitude', Sort.desc);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  thenByTripId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tripId', Sort.asc);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QAfterSortBy>
  thenByTripIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tripId', Sort.desc);
    });
  }
}

extension JourneyProgressDbQueryWhereDistinct
    on QueryBuilder<JourneyProgressDb, JourneyProgressDb, QDistinct> {
  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QDistinct>
  distinctByActiveItineraryJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'activeItineraryJson',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QDistinct>
  distinctByCurrentActivityIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentActivityIndex');
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QDistinct>
  distinctByCurrentLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentLatitude');
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QDistinct>
  distinctByCurrentLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentLongitude');
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QDistinct>
  distinctByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated');
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QDistinct>
  distinctByStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<JourneyProgressDb, JourneyProgressDb, QDistinct>
  distinctByTripId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tripId', caseSensitive: caseSensitive);
    });
  }
}

extension JourneyProgressDbQueryProperty
    on QueryBuilder<JourneyProgressDb, JourneyProgressDb, QQueryProperty> {
  QueryBuilder<JourneyProgressDb, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<JourneyProgressDb, String?, QQueryOperations>
  activeItineraryJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activeItineraryJson');
    });
  }

  QueryBuilder<JourneyProgressDb, int, QQueryOperations>
  currentActivityIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentActivityIndex');
    });
  }

  QueryBuilder<JourneyProgressDb, double, QQueryOperations>
  currentLatitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentLatitude');
    });
  }

  QueryBuilder<JourneyProgressDb, double, QQueryOperations>
  currentLongitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentLongitude');
    });
  }

  QueryBuilder<JourneyProgressDb, DateTime, QQueryOperations>
  lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<JourneyProgressDb, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<JourneyProgressDb, String, QQueryOperations> tripIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tripId');
    });
  }
}
