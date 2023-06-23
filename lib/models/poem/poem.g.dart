// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poem.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPoemCollection on Isar {
  IsarCollection<Poem> get poems => this.collection();
}

const PoemSchema = CollectionSchema(
  name: r'Poem',
  id: -3675293707972732428,
  properties: {
    r'author': PropertySchema(
      id: 0,
      name: r'author',
      type: IsarType.string,
    ),
    r'favoriteTime': PropertySchema(
      id: 1,
      name: r'favoriteTime',
      type: IsarType.dateTime,
    ),
    r'lastAccess': PropertySchema(
      id: 2,
      name: r'lastAccess',
      type: IsarType.dateTime,
    ),
    r'poem': PropertySchema(
      id: 3,
      name: r'poem',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 4,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _poemEstimateSize,
  serialize: _poemSerialize,
  deserialize: _poemDeserialize,
  deserializeProp: _poemDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _poemGetId,
  getLinks: _poemGetLinks,
  attach: _poemAttach,
  version: '3.1.0',
);

int _poemEstimateSize(
  Poem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.author.length * 3;
  bytesCount += 3 + object.poem.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _poemSerialize(
  Poem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.author);
  writer.writeDateTime(offsets[1], object.favoriteTime);
  writer.writeDateTime(offsets[2], object.lastAccess);
  writer.writeString(offsets[3], object.poem);
  writer.writeString(offsets[4], object.title);
}

Poem _poemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Poem(
    author: reader.readString(offsets[0]),
    favoriteTime: reader.readDateTimeOrNull(offsets[1]),
    poem: reader.readString(offsets[3]),
    title: reader.readString(offsets[4]),
  );
  object.id = id;
  object.lastAccess = reader.readDateTime(offsets[2]);
  return object;
}

P _poemDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _poemGetId(Poem object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _poemGetLinks(Poem object) {
  return [];
}

void _poemAttach(IsarCollection<dynamic> col, Id id, Poem object) {
  object.id = id;
}

extension PoemQueryWhereSort on QueryBuilder<Poem, Poem, QWhere> {
  QueryBuilder<Poem, Poem, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PoemQueryWhere on QueryBuilder<Poem, Poem, QWhereClause> {
  QueryBuilder<Poem, Poem, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Poem, Poem, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Poem, Poem, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Poem, Poem, QAfterWhereClause> idBetween(
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
}

extension PoemQueryFilter on QueryBuilder<Poem, Poem, QFilterCondition> {
  QueryBuilder<Poem, Poem, QAfterFilterCondition> authorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> authorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> authorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> authorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'author',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> authorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> authorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> authorContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> authorMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'author',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> authorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'author',
        value: '',
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> authorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'author',
        value: '',
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> favoriteTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'favoriteTime',
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> favoriteTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'favoriteTime',
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> favoriteTimeEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'favoriteTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> favoriteTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'favoriteTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> favoriteTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'favoriteTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> favoriteTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'favoriteTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Poem, Poem, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Poem, Poem, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Poem, Poem, QAfterFilterCondition> lastAccessEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastAccess',
        value: value,
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> lastAccessGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastAccess',
        value: value,
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> lastAccessLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastAccess',
        value: value,
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> lastAccessBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastAccess',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> poemEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'poem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> poemGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'poem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> poemLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'poem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> poemBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'poem',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> poemStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'poem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> poemEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'poem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> poemContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'poem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> poemMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'poem',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> poemIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'poem',
        value: '',
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> poemIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'poem',
        value: '',
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> titleEqualTo(
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

  QueryBuilder<Poem, Poem, QAfterFilterCondition> titleGreaterThan(
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

  QueryBuilder<Poem, Poem, QAfterFilterCondition> titleLessThan(
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

  QueryBuilder<Poem, Poem, QAfterFilterCondition> titleBetween(
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

  QueryBuilder<Poem, Poem, QAfterFilterCondition> titleStartsWith(
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

  QueryBuilder<Poem, Poem, QAfterFilterCondition> titleEndsWith(
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

  QueryBuilder<Poem, Poem, QAfterFilterCondition> titleContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> titleMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Poem, Poem, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension PoemQueryObject on QueryBuilder<Poem, Poem, QFilterCondition> {}

extension PoemQueryLinks on QueryBuilder<Poem, Poem, QFilterCondition> {}

extension PoemQuerySortBy on QueryBuilder<Poem, Poem, QSortBy> {
  QueryBuilder<Poem, Poem, QAfterSortBy> sortByAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.asc);
    });
  }

  QueryBuilder<Poem, Poem, QAfterSortBy> sortByAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.desc);
    });
  }

  QueryBuilder<Poem, Poem, QAfterSortBy> sortByFavoriteTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoriteTime', Sort.asc);
    });
  }

  QueryBuilder<Poem, Poem, QAfterSortBy> sortByFavoriteTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoriteTime', Sort.desc);
    });
  }

  QueryBuilder<Poem, Poem, QAfterSortBy> sortByLastAccess() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAccess', Sort.asc);
    });
  }

  QueryBuilder<Poem, Poem, QAfterSortBy> sortByLastAccessDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAccess', Sort.desc);
    });
  }

  QueryBuilder<Poem, Poem, QAfterSortBy> sortByPoem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poem', Sort.asc);
    });
  }

  QueryBuilder<Poem, Poem, QAfterSortBy> sortByPoemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poem', Sort.desc);
    });
  }

  QueryBuilder<Poem, Poem, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Poem, Poem, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension PoemQuerySortThenBy on QueryBuilder<Poem, Poem, QSortThenBy> {
  QueryBuilder<Poem, Poem, QAfterSortBy> thenByAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.asc);
    });
  }

  QueryBuilder<Poem, Poem, QAfterSortBy> thenByAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.desc);
    });
  }

  QueryBuilder<Poem, Poem, QAfterSortBy> thenByFavoriteTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoriteTime', Sort.asc);
    });
  }

  QueryBuilder<Poem, Poem, QAfterSortBy> thenByFavoriteTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoriteTime', Sort.desc);
    });
  }

  QueryBuilder<Poem, Poem, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Poem, Poem, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Poem, Poem, QAfterSortBy> thenByLastAccess() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAccess', Sort.asc);
    });
  }

  QueryBuilder<Poem, Poem, QAfterSortBy> thenByLastAccessDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAccess', Sort.desc);
    });
  }

  QueryBuilder<Poem, Poem, QAfterSortBy> thenByPoem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poem', Sort.asc);
    });
  }

  QueryBuilder<Poem, Poem, QAfterSortBy> thenByPoemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poem', Sort.desc);
    });
  }

  QueryBuilder<Poem, Poem, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Poem, Poem, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension PoemQueryWhereDistinct on QueryBuilder<Poem, Poem, QDistinct> {
  QueryBuilder<Poem, Poem, QDistinct> distinctByAuthor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'author', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Poem, Poem, QDistinct> distinctByFavoriteTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'favoriteTime');
    });
  }

  QueryBuilder<Poem, Poem, QDistinct> distinctByLastAccess() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastAccess');
    });
  }

  QueryBuilder<Poem, Poem, QDistinct> distinctByPoem(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'poem', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Poem, Poem, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension PoemQueryProperty on QueryBuilder<Poem, Poem, QQueryProperty> {
  QueryBuilder<Poem, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Poem, String, QQueryOperations> authorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'author');
    });
  }

  QueryBuilder<Poem, DateTime?, QQueryOperations> favoriteTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'favoriteTime');
    });
  }

  QueryBuilder<Poem, DateTime, QQueryOperations> lastAccessProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastAccess');
    });
  }

  QueryBuilder<Poem, String, QQueryOperations> poemProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'poem');
    });
  }

  QueryBuilder<Poem, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
