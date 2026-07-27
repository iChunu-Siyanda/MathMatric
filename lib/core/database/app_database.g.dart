// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TopicsTable extends Topics with TableInfo<$TopicsTable, Topic> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TopicsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _topicIdMeta =
      const VerificationMeta('topicId');
  @override
  late final GeneratedColumn<String> topicId = GeneratedColumn<String>(
      'topic_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _subjectIdMeta =
      const VerificationMeta('subjectId');
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
      'subject_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _totalLevelsMeta =
      const VerificationMeta('totalLevels');
  @override
  late final GeneratedColumn<int> totalLevels = GeneratedColumn<int>(
      'total_levels', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _totalXpMeta =
      const VerificationMeta('totalXp');
  @override
  late final GeneratedColumn<int> totalXp = GeneratedColumn<int>(
      'total_xp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _colorHexMeta =
      const VerificationMeta('colorHex');
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
      'color_hex', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        topicId,
        subjectId,
        title,
        description,
        order,
        totalLevels,
        totalXp,
        colorHex,
        version,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'topics';
  @override
  VerificationContext validateIntegrity(Insertable<Topic> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('topic_id')) {
      context.handle(_topicIdMeta,
          topicId.isAcceptableOrUnknown(data['topic_id']!, _topicIdMeta));
    } else if (isInserting) {
      context.missing(_topicIdMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(_subjectIdMeta,
          subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta));
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('total_levels')) {
      context.handle(
          _totalLevelsMeta,
          totalLevels.isAcceptableOrUnknown(
              data['total_levels']!, _totalLevelsMeta));
    } else if (isInserting) {
      context.missing(_totalLevelsMeta);
    }
    if (data.containsKey('total_xp')) {
      context.handle(_totalXpMeta,
          totalXp.isAcceptableOrUnknown(data['total_xp']!, _totalXpMeta));
    } else if (isInserting) {
      context.missing(_totalXpMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(_colorHexMeta,
          colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta));
    } else if (isInserting) {
      context.missing(_colorHexMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Topic map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Topic(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      topicId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}topic_id'])!,
      subjectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subject_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      order: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order'])!,
      totalLevels: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_levels'])!,
      totalXp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_xp'])!,
      colorHex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color_hex'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TopicsTable createAlias(String alias) {
    return $TopicsTable(attachedDatabase, alias);
  }
}

class Topic extends DataClass implements Insertable<Topic> {
  final int id;
  final String topicId;
  final String subjectId;
  final String title;
  final String description;
  final int order;
  final int totalLevels;
  final int totalXp;
  final String colorHex;
  final int version;
  final DateTime updatedAt;
  const Topic(
      {required this.id,
      required this.topicId,
      required this.subjectId,
      required this.title,
      required this.description,
      required this.order,
      required this.totalLevels,
      required this.totalXp,
      required this.colorHex,
      required this.version,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['topic_id'] = Variable<String>(topicId);
    map['subject_id'] = Variable<String>(subjectId);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['order'] = Variable<int>(order);
    map['total_levels'] = Variable<int>(totalLevels);
    map['total_xp'] = Variable<int>(totalXp);
    map['color_hex'] = Variable<String>(colorHex);
    map['version'] = Variable<int>(version);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TopicsCompanion toCompanion(bool nullToAbsent) {
    return TopicsCompanion(
      id: Value(id),
      topicId: Value(topicId),
      subjectId: Value(subjectId),
      title: Value(title),
      description: Value(description),
      order: Value(order),
      totalLevels: Value(totalLevels),
      totalXp: Value(totalXp),
      colorHex: Value(colorHex),
      version: Value(version),
      updatedAt: Value(updatedAt),
    );
  }

  factory Topic.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Topic(
      id: serializer.fromJson<int>(json['id']),
      topicId: serializer.fromJson<String>(json['topicId']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      order: serializer.fromJson<int>(json['order']),
      totalLevels: serializer.fromJson<int>(json['totalLevels']),
      totalXp: serializer.fromJson<int>(json['totalXp']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      version: serializer.fromJson<int>(json['version']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'topicId': serializer.toJson<String>(topicId),
      'subjectId': serializer.toJson<String>(subjectId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'order': serializer.toJson<int>(order),
      'totalLevels': serializer.toJson<int>(totalLevels),
      'totalXp': serializer.toJson<int>(totalXp),
      'colorHex': serializer.toJson<String>(colorHex),
      'version': serializer.toJson<int>(version),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Topic copyWith(
          {int? id,
          String? topicId,
          String? subjectId,
          String? title,
          String? description,
          int? order,
          int? totalLevels,
          int? totalXp,
          String? colorHex,
          int? version,
          DateTime? updatedAt}) =>
      Topic(
        id: id ?? this.id,
        topicId: topicId ?? this.topicId,
        subjectId: subjectId ?? this.subjectId,
        title: title ?? this.title,
        description: description ?? this.description,
        order: order ?? this.order,
        totalLevels: totalLevels ?? this.totalLevels,
        totalXp: totalXp ?? this.totalXp,
        colorHex: colorHex ?? this.colorHex,
        version: version ?? this.version,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Topic copyWithCompanion(TopicsCompanion data) {
    return Topic(
      id: data.id.present ? data.id.value : this.id,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      order: data.order.present ? data.order.value : this.order,
      totalLevels:
          data.totalLevels.present ? data.totalLevels.value : this.totalLevels,
      totalXp: data.totalXp.present ? data.totalXp.value : this.totalXp,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      version: data.version.present ? data.version.value : this.version,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Topic(')
          ..write('id: $id, ')
          ..write('topicId: $topicId, ')
          ..write('subjectId: $subjectId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('order: $order, ')
          ..write('totalLevels: $totalLevels, ')
          ..write('totalXp: $totalXp, ')
          ..write('colorHex: $colorHex, ')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, topicId, subjectId, title, description,
      order, totalLevels, totalXp, colorHex, version, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Topic &&
          other.id == this.id &&
          other.topicId == this.topicId &&
          other.subjectId == this.subjectId &&
          other.title == this.title &&
          other.description == this.description &&
          other.order == this.order &&
          other.totalLevels == this.totalLevels &&
          other.totalXp == this.totalXp &&
          other.colorHex == this.colorHex &&
          other.version == this.version &&
          other.updatedAt == this.updatedAt);
}

class TopicsCompanion extends UpdateCompanion<Topic> {
  final Value<int> id;
  final Value<String> topicId;
  final Value<String> subjectId;
  final Value<String> title;
  final Value<String> description;
  final Value<int> order;
  final Value<int> totalLevels;
  final Value<int> totalXp;
  final Value<String> colorHex;
  final Value<int> version;
  final Value<DateTime> updatedAt;
  const TopicsCompanion({
    this.id = const Value.absent(),
    this.topicId = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.order = const Value.absent(),
    this.totalLevels = const Value.absent(),
    this.totalXp = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TopicsCompanion.insert({
    this.id = const Value.absent(),
    required String topicId,
    required String subjectId,
    required String title,
    required String description,
    required int order,
    required int totalLevels,
    required int totalXp,
    required String colorHex,
    required int version,
    required DateTime updatedAt,
  })  : topicId = Value(topicId),
        subjectId = Value(subjectId),
        title = Value(title),
        description = Value(description),
        order = Value(order),
        totalLevels = Value(totalLevels),
        totalXp = Value(totalXp),
        colorHex = Value(colorHex),
        version = Value(version),
        updatedAt = Value(updatedAt);
  static Insertable<Topic> custom({
    Expression<int>? id,
    Expression<String>? topicId,
    Expression<String>? subjectId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? order,
    Expression<int>? totalLevels,
    Expression<int>? totalXp,
    Expression<String>? colorHex,
    Expression<int>? version,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (topicId != null) 'topic_id': topicId,
      if (subjectId != null) 'subject_id': subjectId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (order != null) 'order': order,
      if (totalLevels != null) 'total_levels': totalLevels,
      if (totalXp != null) 'total_xp': totalXp,
      if (colorHex != null) 'color_hex': colorHex,
      if (version != null) 'version': version,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TopicsCompanion copyWith(
      {Value<int>? id,
      Value<String>? topicId,
      Value<String>? subjectId,
      Value<String>? title,
      Value<String>? description,
      Value<int>? order,
      Value<int>? totalLevels,
      Value<int>? totalXp,
      Value<String>? colorHex,
      Value<int>? version,
      Value<DateTime>? updatedAt}) {
    return TopicsCompanion(
      id: id ?? this.id,
      topicId: topicId ?? this.topicId,
      subjectId: subjectId ?? this.subjectId,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      totalLevels: totalLevels ?? this.totalLevels,
      totalXp: totalXp ?? this.totalXp,
      colorHex: colorHex ?? this.colorHex,
      version: version ?? this.version,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (topicId.present) {
      map['topic_id'] = Variable<String>(topicId.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (totalLevels.present) {
      map['total_levels'] = Variable<int>(totalLevels.value);
    }
    if (totalXp.present) {
      map['total_xp'] = Variable<int>(totalXp.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TopicsCompanion(')
          ..write('id: $id, ')
          ..write('topicId: $topicId, ')
          ..write('subjectId: $subjectId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('order: $order, ')
          ..write('totalLevels: $totalLevels, ')
          ..write('totalXp: $totalXp, ')
          ..write('colorHex: $colorHex, ')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SubjectsTable extends Subjects with TableInfo<$SubjectsTable, Subject> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gradeMeta = const VerificationMeta('grade');
  @override
  late final GeneratedColumn<int> grade = GeneratedColumn<int>(
      'grade', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, grade, updatedAt, version];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subjects';
  @override
  VerificationContext validateIntegrity(Insertable<Subject> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('grade')) {
      context.handle(
          _gradeMeta, grade.isAcceptableOrUnknown(data['grade']!, _gradeMeta));
    } else if (isInserting) {
      context.missing(_gradeMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Subject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subject(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      grade: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}grade'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $SubjectsTable createAlias(String alias) {
    return $SubjectsTable(attachedDatabase, alias);
  }
}

class Subject extends DataClass implements Insertable<Subject> {
  final String id;
  final String name;
  final int grade;
  final DateTime updatedAt;
  final int version;
  const Subject(
      {required this.id,
      required this.name,
      required this.grade,
      required this.updatedAt,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['grade'] = Variable<int>(grade);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    return map;
  }

  SubjectsCompanion toCompanion(bool nullToAbsent) {
    return SubjectsCompanion(
      id: Value(id),
      name: Value(name),
      grade: Value(grade),
      updatedAt: Value(updatedAt),
      version: Value(version),
    );
  }

  factory Subject.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subject(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      grade: serializer.fromJson<int>(json['grade']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'grade': serializer.toJson<int>(grade),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
    };
  }

  Subject copyWith(
          {String? id,
          String? name,
          int? grade,
          DateTime? updatedAt,
          int? version}) =>
      Subject(
        id: id ?? this.id,
        name: name ?? this.name,
        grade: grade ?? this.grade,
        updatedAt: updatedAt ?? this.updatedAt,
        version: version ?? this.version,
      );
  Subject copyWithCompanion(SubjectsCompanion data) {
    return Subject(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      grade: data.grade.present ? data.grade.value : this.grade,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subject(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('grade: $grade, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, grade, updatedAt, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subject &&
          other.id == this.id &&
          other.name == this.name &&
          other.grade == this.grade &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version);
}

class SubjectsCompanion extends UpdateCompanion<Subject> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> grade;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<int> rowid;
  const SubjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.grade = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubjectsCompanion.insert({
    required String id,
    required String name,
    required int grade,
    required DateTime updatedAt,
    required int version,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        grade = Value(grade),
        updatedAt = Value(updatedAt),
        version = Value(version);
  static Insertable<Subject> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? grade,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (grade != null) 'grade': grade,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubjectsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? grade,
      Value<DateTime>? updatedAt,
      Value<int>? version,
      Value<int>? rowid}) {
    return SubjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      grade: grade ?? this.grade,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (grade.present) {
      map['grade'] = Variable<int>(grade.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('grade: $grade, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuestionsTable extends Questions
    with TableInfo<$QuestionsTable, Question> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _levelIdMeta =
      const VerificationMeta('levelId');
  @override
  late final GeneratedColumn<String> levelId = GeneratedColumn<String>(
      'level_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _questionMeta =
      const VerificationMeta('question');
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
      'question', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _optionAMeta =
      const VerificationMeta('optionA');
  @override
  late final GeneratedColumn<String> optionA = GeneratedColumn<String>(
      'option_a', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _optionBMeta =
      const VerificationMeta('optionB');
  @override
  late final GeneratedColumn<String> optionB = GeneratedColumn<String>(
      'option_b', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _optionCMeta =
      const VerificationMeta('optionC');
  @override
  late final GeneratedColumn<String> optionC = GeneratedColumn<String>(
      'option_c', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _optionDMeta =
      const VerificationMeta('optionD');
  @override
  late final GeneratedColumn<String> optionD = GeneratedColumn<String>(
      'option_d', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _correctAnswerIndexMeta =
      const VerificationMeta('correctAnswerIndex');
  @override
  late final GeneratedColumn<int> correctAnswerIndex = GeneratedColumn<int>(
      'correct_answer_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _difficultyMeta =
      const VerificationMeta('difficulty');
  @override
  late final GeneratedColumn<double> difficulty = GeneratedColumn<double>(
      'difficulty', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _explanationMeta =
      const VerificationMeta('explanation');
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
      'explanation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        levelId,
        question,
        optionA,
        optionB,
        optionC,
        optionD,
        correctAnswerIndex,
        difficulty,
        explanation,
        version,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'questions';
  @override
  VerificationContext validateIntegrity(Insertable<Question> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('level_id')) {
      context.handle(_levelIdMeta,
          levelId.isAcceptableOrUnknown(data['level_id']!, _levelIdMeta));
    } else if (isInserting) {
      context.missing(_levelIdMeta);
    }
    if (data.containsKey('question')) {
      context.handle(_questionMeta,
          question.isAcceptableOrUnknown(data['question']!, _questionMeta));
    } else if (isInserting) {
      context.missing(_questionMeta);
    }
    if (data.containsKey('option_a')) {
      context.handle(_optionAMeta,
          optionA.isAcceptableOrUnknown(data['option_a']!, _optionAMeta));
    } else if (isInserting) {
      context.missing(_optionAMeta);
    }
    if (data.containsKey('option_b')) {
      context.handle(_optionBMeta,
          optionB.isAcceptableOrUnknown(data['option_b']!, _optionBMeta));
    } else if (isInserting) {
      context.missing(_optionBMeta);
    }
    if (data.containsKey('option_c')) {
      context.handle(_optionCMeta,
          optionC.isAcceptableOrUnknown(data['option_c']!, _optionCMeta));
    } else if (isInserting) {
      context.missing(_optionCMeta);
    }
    if (data.containsKey('option_d')) {
      context.handle(_optionDMeta,
          optionD.isAcceptableOrUnknown(data['option_d']!, _optionDMeta));
    } else if (isInserting) {
      context.missing(_optionDMeta);
    }
    if (data.containsKey('correct_answer_index')) {
      context.handle(
          _correctAnswerIndexMeta,
          correctAnswerIndex.isAcceptableOrUnknown(
              data['correct_answer_index']!, _correctAnswerIndexMeta));
    } else if (isInserting) {
      context.missing(_correctAnswerIndexMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
          _difficultyMeta,
          difficulty.isAcceptableOrUnknown(
              data['difficulty']!, _difficultyMeta));
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
          _explanationMeta,
          explanation.isAcceptableOrUnknown(
              data['explanation']!, _explanationMeta));
    } else if (isInserting) {
      context.missing(_explanationMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Question map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Question(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      levelId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level_id'])!,
      question: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question'])!,
      optionA: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}option_a'])!,
      optionB: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}option_b'])!,
      optionC: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}option_c'])!,
      optionD: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}option_d'])!,
      correctAnswerIndex: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}correct_answer_index'])!,
      difficulty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}difficulty'])!,
      explanation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}explanation'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $QuestionsTable createAlias(String alias) {
    return $QuestionsTable(attachedDatabase, alias);
  }
}

class Question extends DataClass implements Insertable<Question> {
  final String id;
  final String levelId;
  final String question;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final int correctAnswerIndex;
  final double difficulty;
  final String explanation;
  final int version;
  final DateTime updatedAt;
  const Question(
      {required this.id,
      required this.levelId,
      required this.question,
      required this.optionA,
      required this.optionB,
      required this.optionC,
      required this.optionD,
      required this.correctAnswerIndex,
      required this.difficulty,
      required this.explanation,
      required this.version,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['level_id'] = Variable<String>(levelId);
    map['question'] = Variable<String>(question);
    map['option_a'] = Variable<String>(optionA);
    map['option_b'] = Variable<String>(optionB);
    map['option_c'] = Variable<String>(optionC);
    map['option_d'] = Variable<String>(optionD);
    map['correct_answer_index'] = Variable<int>(correctAnswerIndex);
    map['difficulty'] = Variable<double>(difficulty);
    map['explanation'] = Variable<String>(explanation);
    map['version'] = Variable<int>(version);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  QuestionsCompanion toCompanion(bool nullToAbsent) {
    return QuestionsCompanion(
      id: Value(id),
      levelId: Value(levelId),
      question: Value(question),
      optionA: Value(optionA),
      optionB: Value(optionB),
      optionC: Value(optionC),
      optionD: Value(optionD),
      correctAnswerIndex: Value(correctAnswerIndex),
      difficulty: Value(difficulty),
      explanation: Value(explanation),
      version: Value(version),
      updatedAt: Value(updatedAt),
    );
  }

  factory Question.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Question(
      id: serializer.fromJson<String>(json['id']),
      levelId: serializer.fromJson<String>(json['levelId']),
      question: serializer.fromJson<String>(json['question']),
      optionA: serializer.fromJson<String>(json['optionA']),
      optionB: serializer.fromJson<String>(json['optionB']),
      optionC: serializer.fromJson<String>(json['optionC']),
      optionD: serializer.fromJson<String>(json['optionD']),
      correctAnswerIndex: serializer.fromJson<int>(json['correctAnswerIndex']),
      difficulty: serializer.fromJson<double>(json['difficulty']),
      explanation: serializer.fromJson<String>(json['explanation']),
      version: serializer.fromJson<int>(json['version']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'levelId': serializer.toJson<String>(levelId),
      'question': serializer.toJson<String>(question),
      'optionA': serializer.toJson<String>(optionA),
      'optionB': serializer.toJson<String>(optionB),
      'optionC': serializer.toJson<String>(optionC),
      'optionD': serializer.toJson<String>(optionD),
      'correctAnswerIndex': serializer.toJson<int>(correctAnswerIndex),
      'difficulty': serializer.toJson<double>(difficulty),
      'explanation': serializer.toJson<String>(explanation),
      'version': serializer.toJson<int>(version),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Question copyWith(
          {String? id,
          String? levelId,
          String? question,
          String? optionA,
          String? optionB,
          String? optionC,
          String? optionD,
          int? correctAnswerIndex,
          double? difficulty,
          String? explanation,
          int? version,
          DateTime? updatedAt}) =>
      Question(
        id: id ?? this.id,
        levelId: levelId ?? this.levelId,
        question: question ?? this.question,
        optionA: optionA ?? this.optionA,
        optionB: optionB ?? this.optionB,
        optionC: optionC ?? this.optionC,
        optionD: optionD ?? this.optionD,
        correctAnswerIndex: correctAnswerIndex ?? this.correctAnswerIndex,
        difficulty: difficulty ?? this.difficulty,
        explanation: explanation ?? this.explanation,
        version: version ?? this.version,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Question copyWithCompanion(QuestionsCompanion data) {
    return Question(
      id: data.id.present ? data.id.value : this.id,
      levelId: data.levelId.present ? data.levelId.value : this.levelId,
      question: data.question.present ? data.question.value : this.question,
      optionA: data.optionA.present ? data.optionA.value : this.optionA,
      optionB: data.optionB.present ? data.optionB.value : this.optionB,
      optionC: data.optionC.present ? data.optionC.value : this.optionC,
      optionD: data.optionD.present ? data.optionD.value : this.optionD,
      correctAnswerIndex: data.correctAnswerIndex.present
          ? data.correctAnswerIndex.value
          : this.correctAnswerIndex,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
      explanation:
          data.explanation.present ? data.explanation.value : this.explanation,
      version: data.version.present ? data.version.value : this.version,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Question(')
          ..write('id: $id, ')
          ..write('levelId: $levelId, ')
          ..write('question: $question, ')
          ..write('optionA: $optionA, ')
          ..write('optionB: $optionB, ')
          ..write('optionC: $optionC, ')
          ..write('optionD: $optionD, ')
          ..write('correctAnswerIndex: $correctAnswerIndex, ')
          ..write('difficulty: $difficulty, ')
          ..write('explanation: $explanation, ')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      levelId,
      question,
      optionA,
      optionB,
      optionC,
      optionD,
      correctAnswerIndex,
      difficulty,
      explanation,
      version,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Question &&
          other.id == this.id &&
          other.levelId == this.levelId &&
          other.question == this.question &&
          other.optionA == this.optionA &&
          other.optionB == this.optionB &&
          other.optionC == this.optionC &&
          other.optionD == this.optionD &&
          other.correctAnswerIndex == this.correctAnswerIndex &&
          other.difficulty == this.difficulty &&
          other.explanation == this.explanation &&
          other.version == this.version &&
          other.updatedAt == this.updatedAt);
}

class QuestionsCompanion extends UpdateCompanion<Question> {
  final Value<String> id;
  final Value<String> levelId;
  final Value<String> question;
  final Value<String> optionA;
  final Value<String> optionB;
  final Value<String> optionC;
  final Value<String> optionD;
  final Value<int> correctAnswerIndex;
  final Value<double> difficulty;
  final Value<String> explanation;
  final Value<int> version;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const QuestionsCompanion({
    this.id = const Value.absent(),
    this.levelId = const Value.absent(),
    this.question = const Value.absent(),
    this.optionA = const Value.absent(),
    this.optionB = const Value.absent(),
    this.optionC = const Value.absent(),
    this.optionD = const Value.absent(),
    this.correctAnswerIndex = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.explanation = const Value.absent(),
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestionsCompanion.insert({
    required String id,
    required String levelId,
    required String question,
    required String optionA,
    required String optionB,
    required String optionC,
    required String optionD,
    required int correctAnswerIndex,
    required double difficulty,
    required String explanation,
    required int version,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        levelId = Value(levelId),
        question = Value(question),
        optionA = Value(optionA),
        optionB = Value(optionB),
        optionC = Value(optionC),
        optionD = Value(optionD),
        correctAnswerIndex = Value(correctAnswerIndex),
        difficulty = Value(difficulty),
        explanation = Value(explanation),
        version = Value(version),
        updatedAt = Value(updatedAt);
  static Insertable<Question> custom({
    Expression<String>? id,
    Expression<String>? levelId,
    Expression<String>? question,
    Expression<String>? optionA,
    Expression<String>? optionB,
    Expression<String>? optionC,
    Expression<String>? optionD,
    Expression<int>? correctAnswerIndex,
    Expression<double>? difficulty,
    Expression<String>? explanation,
    Expression<int>? version,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (levelId != null) 'level_id': levelId,
      if (question != null) 'question': question,
      if (optionA != null) 'option_a': optionA,
      if (optionB != null) 'option_b': optionB,
      if (optionC != null) 'option_c': optionC,
      if (optionD != null) 'option_d': optionD,
      if (correctAnswerIndex != null)
        'correct_answer_index': correctAnswerIndex,
      if (difficulty != null) 'difficulty': difficulty,
      if (explanation != null) 'explanation': explanation,
      if (version != null) 'version': version,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? levelId,
      Value<String>? question,
      Value<String>? optionA,
      Value<String>? optionB,
      Value<String>? optionC,
      Value<String>? optionD,
      Value<int>? correctAnswerIndex,
      Value<double>? difficulty,
      Value<String>? explanation,
      Value<int>? version,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return QuestionsCompanion(
      id: id ?? this.id,
      levelId: levelId ?? this.levelId,
      question: question ?? this.question,
      optionA: optionA ?? this.optionA,
      optionB: optionB ?? this.optionB,
      optionC: optionC ?? this.optionC,
      optionD: optionD ?? this.optionD,
      correctAnswerIndex: correctAnswerIndex ?? this.correctAnswerIndex,
      difficulty: difficulty ?? this.difficulty,
      explanation: explanation ?? this.explanation,
      version: version ?? this.version,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (levelId.present) {
      map['level_id'] = Variable<String>(levelId.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (optionA.present) {
      map['option_a'] = Variable<String>(optionA.value);
    }
    if (optionB.present) {
      map['option_b'] = Variable<String>(optionB.value);
    }
    if (optionC.present) {
      map['option_c'] = Variable<String>(optionC.value);
    }
    if (optionD.present) {
      map['option_d'] = Variable<String>(optionD.value);
    }
    if (correctAnswerIndex.present) {
      map['correct_answer_index'] = Variable<int>(correctAnswerIndex.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<double>(difficulty.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionsCompanion(')
          ..write('id: $id, ')
          ..write('levelId: $levelId, ')
          ..write('question: $question, ')
          ..write('optionA: $optionA, ')
          ..write('optionB: $optionB, ')
          ..write('optionC: $optionC, ')
          ..write('optionD: $optionD, ')
          ..write('correctAnswerIndex: $correctAnswerIndex, ')
          ..write('difficulty: $difficulty, ')
          ..write('explanation: $explanation, ')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LevelsTable extends Levels with TableInfo<$LevelsTable, Level> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LevelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _topicIdMeta =
      const VerificationMeta('topicId');
  @override
  late final GeneratedColumn<String> topicId = GeneratedColumn<String>(
      'topic_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _subtitleMeta =
      const VerificationMeta('subtitle');
  @override
  late final GeneratedColumn<String> subtitle = GeneratedColumn<String>(
      'subtitle', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _xpRewardMeta =
      const VerificationMeta('xpReward');
  @override
  late final GeneratedColumn<int> xpReward = GeneratedColumn<int>(
      'xp_reward', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, topicId, title, subtitle, order, xpReward, version, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'levels';
  @override
  VerificationContext validateIntegrity(Insertable<Level> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('topic_id')) {
      context.handle(_topicIdMeta,
          topicId.isAcceptableOrUnknown(data['topic_id']!, _topicIdMeta));
    } else if (isInserting) {
      context.missing(_topicIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('subtitle')) {
      context.handle(_subtitleMeta,
          subtitle.isAcceptableOrUnknown(data['subtitle']!, _subtitleMeta));
    } else if (isInserting) {
      context.missing(_subtitleMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('xp_reward')) {
      context.handle(_xpRewardMeta,
          xpReward.isAcceptableOrUnknown(data['xp_reward']!, _xpRewardMeta));
    } else if (isInserting) {
      context.missing(_xpRewardMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Level map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Level(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      topicId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}topic_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      subtitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subtitle'])!,
      order: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order'])!,
      xpReward: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}xp_reward'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $LevelsTable createAlias(String alias) {
    return $LevelsTable(attachedDatabase, alias);
  }
}

class Level extends DataClass implements Insertable<Level> {
  final String id;
  final String topicId;
  final String title;
  final String subtitle;
  final int order;
  final int xpReward;
  final int version;
  final DateTime updatedAt;
  const Level(
      {required this.id,
      required this.topicId,
      required this.title,
      required this.subtitle,
      required this.order,
      required this.xpReward,
      required this.version,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['topic_id'] = Variable<String>(topicId);
    map['title'] = Variable<String>(title);
    map['subtitle'] = Variable<String>(subtitle);
    map['order'] = Variable<int>(order);
    map['xp_reward'] = Variable<int>(xpReward);
    map['version'] = Variable<int>(version);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LevelsCompanion toCompanion(bool nullToAbsent) {
    return LevelsCompanion(
      id: Value(id),
      topicId: Value(topicId),
      title: Value(title),
      subtitle: Value(subtitle),
      order: Value(order),
      xpReward: Value(xpReward),
      version: Value(version),
      updatedAt: Value(updatedAt),
    );
  }

  factory Level.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Level(
      id: serializer.fromJson<String>(json['id']),
      topicId: serializer.fromJson<String>(json['topicId']),
      title: serializer.fromJson<String>(json['title']),
      subtitle: serializer.fromJson<String>(json['subtitle']),
      order: serializer.fromJson<int>(json['order']),
      xpReward: serializer.fromJson<int>(json['xpReward']),
      version: serializer.fromJson<int>(json['version']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'topicId': serializer.toJson<String>(topicId),
      'title': serializer.toJson<String>(title),
      'subtitle': serializer.toJson<String>(subtitle),
      'order': serializer.toJson<int>(order),
      'xpReward': serializer.toJson<int>(xpReward),
      'version': serializer.toJson<int>(version),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Level copyWith(
          {String? id,
          String? topicId,
          String? title,
          String? subtitle,
          int? order,
          int? xpReward,
          int? version,
          DateTime? updatedAt}) =>
      Level(
        id: id ?? this.id,
        topicId: topicId ?? this.topicId,
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        order: order ?? this.order,
        xpReward: xpReward ?? this.xpReward,
        version: version ?? this.version,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Level copyWithCompanion(LevelsCompanion data) {
    return Level(
      id: data.id.present ? data.id.value : this.id,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
      title: data.title.present ? data.title.value : this.title,
      subtitle: data.subtitle.present ? data.subtitle.value : this.subtitle,
      order: data.order.present ? data.order.value : this.order,
      xpReward: data.xpReward.present ? data.xpReward.value : this.xpReward,
      version: data.version.present ? data.version.value : this.version,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Level(')
          ..write('id: $id, ')
          ..write('topicId: $topicId, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('order: $order, ')
          ..write('xpReward: $xpReward, ')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, topicId, title, subtitle, order, xpReward, version, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Level &&
          other.id == this.id &&
          other.topicId == this.topicId &&
          other.title == this.title &&
          other.subtitle == this.subtitle &&
          other.order == this.order &&
          other.xpReward == this.xpReward &&
          other.version == this.version &&
          other.updatedAt == this.updatedAt);
}

class LevelsCompanion extends UpdateCompanion<Level> {
  final Value<String> id;
  final Value<String> topicId;
  final Value<String> title;
  final Value<String> subtitle;
  final Value<int> order;
  final Value<int> xpReward;
  final Value<int> version;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LevelsCompanion({
    this.id = const Value.absent(),
    this.topicId = const Value.absent(),
    this.title = const Value.absent(),
    this.subtitle = const Value.absent(),
    this.order = const Value.absent(),
    this.xpReward = const Value.absent(),
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LevelsCompanion.insert({
    required String id,
    required String topicId,
    required String title,
    required String subtitle,
    required int order,
    required int xpReward,
    required int version,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        topicId = Value(topicId),
        title = Value(title),
        subtitle = Value(subtitle),
        order = Value(order),
        xpReward = Value(xpReward),
        version = Value(version),
        updatedAt = Value(updatedAt);
  static Insertable<Level> custom({
    Expression<String>? id,
    Expression<String>? topicId,
    Expression<String>? title,
    Expression<String>? subtitle,
    Expression<int>? order,
    Expression<int>? xpReward,
    Expression<int>? version,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (topicId != null) 'topic_id': topicId,
      if (title != null) 'title': title,
      if (subtitle != null) 'subtitle': subtitle,
      if (order != null) 'order': order,
      if (xpReward != null) 'xp_reward': xpReward,
      if (version != null) 'version': version,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LevelsCompanion copyWith(
      {Value<String>? id,
      Value<String>? topicId,
      Value<String>? title,
      Value<String>? subtitle,
      Value<int>? order,
      Value<int>? xpReward,
      Value<int>? version,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return LevelsCompanion(
      id: id ?? this.id,
      topicId: topicId ?? this.topicId,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      order: order ?? this.order,
      xpReward: xpReward ?? this.xpReward,
      version: version ?? this.version,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (topicId.present) {
      map['topic_id'] = Variable<String>(topicId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (subtitle.present) {
      map['subtitle'] = Variable<String>(subtitle.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (xpReward.present) {
      map['xp_reward'] = Variable<int>(xpReward.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LevelsCompanion(')
          ..write('id: $id, ')
          ..write('topicId: $topicId, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('order: $order, ')
          ..write('xpReward: $xpReward, ')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TopicsTable topics = $TopicsTable(this);
  late final $SubjectsTable subjects = $SubjectsTable(this);
  late final $QuestionsTable questions = $QuestionsTable(this);
  late final $LevelsTable levels = $LevelsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [topics, subjects, questions, levels];
}

typedef $$TopicsTableCreateCompanionBuilder = TopicsCompanion Function({
  Value<int> id,
  required String topicId,
  required String subjectId,
  required String title,
  required String description,
  required int order,
  required int totalLevels,
  required int totalXp,
  required String colorHex,
  required int version,
  required DateTime updatedAt,
});
typedef $$TopicsTableUpdateCompanionBuilder = TopicsCompanion Function({
  Value<int> id,
  Value<String> topicId,
  Value<String> subjectId,
  Value<String> title,
  Value<String> description,
  Value<int> order,
  Value<int> totalLevels,
  Value<int> totalXp,
  Value<String> colorHex,
  Value<int> version,
  Value<DateTime> updatedAt,
});

class $$TopicsTableFilterComposer
    extends Composer<_$AppDatabase, $TopicsTable> {
  $$TopicsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get topicId => $composableBuilder(
      column: $table.topicId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subjectId => $composableBuilder(
      column: $table.subjectId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalLevels => $composableBuilder(
      column: $table.totalLevels, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalXp => $composableBuilder(
      column: $table.totalXp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$TopicsTableOrderingComposer
    extends Composer<_$AppDatabase, $TopicsTable> {
  $$TopicsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get topicId => $composableBuilder(
      column: $table.topicId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subjectId => $composableBuilder(
      column: $table.subjectId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalLevels => $composableBuilder(
      column: $table.totalLevels, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalXp => $composableBuilder(
      column: $table.totalXp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$TopicsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TopicsTable> {
  $$TopicsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get topicId =>
      $composableBuilder(column: $table.topicId, builder: (column) => column);

  GeneratedColumn<String> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<int> get totalLevels => $composableBuilder(
      column: $table.totalLevels, builder: (column) => column);

  GeneratedColumn<int> get totalXp =>
      $composableBuilder(column: $table.totalXp, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TopicsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TopicsTable,
    Topic,
    $$TopicsTableFilterComposer,
    $$TopicsTableOrderingComposer,
    $$TopicsTableAnnotationComposer,
    $$TopicsTableCreateCompanionBuilder,
    $$TopicsTableUpdateCompanionBuilder,
    (Topic, BaseReferences<_$AppDatabase, $TopicsTable, Topic>),
    Topic,
    PrefetchHooks Function()> {
  $$TopicsTableTableManager(_$AppDatabase db, $TopicsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TopicsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TopicsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TopicsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> topicId = const Value.absent(),
            Value<String> subjectId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<int> order = const Value.absent(),
            Value<int> totalLevels = const Value.absent(),
            Value<int> totalXp = const Value.absent(),
            Value<String> colorHex = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              TopicsCompanion(
            id: id,
            topicId: topicId,
            subjectId: subjectId,
            title: title,
            description: description,
            order: order,
            totalLevels: totalLevels,
            totalXp: totalXp,
            colorHex: colorHex,
            version: version,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String topicId,
            required String subjectId,
            required String title,
            required String description,
            required int order,
            required int totalLevels,
            required int totalXp,
            required String colorHex,
            required int version,
            required DateTime updatedAt,
          }) =>
              TopicsCompanion.insert(
            id: id,
            topicId: topicId,
            subjectId: subjectId,
            title: title,
            description: description,
            order: order,
            totalLevels: totalLevels,
            totalXp: totalXp,
            colorHex: colorHex,
            version: version,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TopicsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TopicsTable,
    Topic,
    $$TopicsTableFilterComposer,
    $$TopicsTableOrderingComposer,
    $$TopicsTableAnnotationComposer,
    $$TopicsTableCreateCompanionBuilder,
    $$TopicsTableUpdateCompanionBuilder,
    (Topic, BaseReferences<_$AppDatabase, $TopicsTable, Topic>),
    Topic,
    PrefetchHooks Function()>;
typedef $$SubjectsTableCreateCompanionBuilder = SubjectsCompanion Function({
  required String id,
  required String name,
  required int grade,
  required DateTime updatedAt,
  required int version,
  Value<int> rowid,
});
typedef $$SubjectsTableUpdateCompanionBuilder = SubjectsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> grade,
  Value<DateTime> updatedAt,
  Value<int> version,
  Value<int> rowid,
});

class $$SubjectsTableFilterComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get grade => $composableBuilder(
      column: $table.grade, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));
}

class $$SubjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get grade => $composableBuilder(
      column: $table.grade, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$SubjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get grade =>
      $composableBuilder(column: $table.grade, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$SubjectsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SubjectsTable,
    Subject,
    $$SubjectsTableFilterComposer,
    $$SubjectsTableOrderingComposer,
    $$SubjectsTableAnnotationComposer,
    $$SubjectsTableCreateCompanionBuilder,
    $$SubjectsTableUpdateCompanionBuilder,
    (Subject, BaseReferences<_$AppDatabase, $SubjectsTable, Subject>),
    Subject,
    PrefetchHooks Function()> {
  $$SubjectsTableTableManager(_$AppDatabase db, $SubjectsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> grade = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubjectsCompanion(
            id: id,
            name: name,
            grade: grade,
            updatedAt: updatedAt,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required int grade,
            required DateTime updatedAt,
            required int version,
            Value<int> rowid = const Value.absent(),
          }) =>
              SubjectsCompanion.insert(
            id: id,
            name: name,
            grade: grade,
            updatedAt: updatedAt,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SubjectsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SubjectsTable,
    Subject,
    $$SubjectsTableFilterComposer,
    $$SubjectsTableOrderingComposer,
    $$SubjectsTableAnnotationComposer,
    $$SubjectsTableCreateCompanionBuilder,
    $$SubjectsTableUpdateCompanionBuilder,
    (Subject, BaseReferences<_$AppDatabase, $SubjectsTable, Subject>),
    Subject,
    PrefetchHooks Function()>;
typedef $$QuestionsTableCreateCompanionBuilder = QuestionsCompanion Function({
  required String id,
  required String levelId,
  required String question,
  required String optionA,
  required String optionB,
  required String optionC,
  required String optionD,
  required int correctAnswerIndex,
  required double difficulty,
  required String explanation,
  required int version,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$QuestionsTableUpdateCompanionBuilder = QuestionsCompanion Function({
  Value<String> id,
  Value<String> levelId,
  Value<String> question,
  Value<String> optionA,
  Value<String> optionB,
  Value<String> optionC,
  Value<String> optionD,
  Value<int> correctAnswerIndex,
  Value<double> difficulty,
  Value<String> explanation,
  Value<int> version,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$QuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get levelId => $composableBuilder(
      column: $table.levelId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get question => $composableBuilder(
      column: $table.question, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get optionA => $composableBuilder(
      column: $table.optionA, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get optionB => $composableBuilder(
      column: $table.optionB, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get optionC => $composableBuilder(
      column: $table.optionC, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get optionD => $composableBuilder(
      column: $table.optionD, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get correctAnswerIndex => $composableBuilder(
      column: $table.correctAnswerIndex,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$QuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get levelId => $composableBuilder(
      column: $table.levelId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get question => $composableBuilder(
      column: $table.question, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get optionA => $composableBuilder(
      column: $table.optionA, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get optionB => $composableBuilder(
      column: $table.optionB, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get optionC => $composableBuilder(
      column: $table.optionC, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get optionD => $composableBuilder(
      column: $table.optionD, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get correctAnswerIndex => $composableBuilder(
      column: $table.correctAnswerIndex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$QuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get levelId =>
      $composableBuilder(column: $table.levelId, builder: (column) => column);

  GeneratedColumn<String> get question =>
      $composableBuilder(column: $table.question, builder: (column) => column);

  GeneratedColumn<String> get optionA =>
      $composableBuilder(column: $table.optionA, builder: (column) => column);

  GeneratedColumn<String> get optionB =>
      $composableBuilder(column: $table.optionB, builder: (column) => column);

  GeneratedColumn<String> get optionC =>
      $composableBuilder(column: $table.optionC, builder: (column) => column);

  GeneratedColumn<String> get optionD =>
      $composableBuilder(column: $table.optionD, builder: (column) => column);

  GeneratedColumn<int> get correctAnswerIndex => $composableBuilder(
      column: $table.correctAnswerIndex, builder: (column) => column);

  GeneratedColumn<double> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => column);

  GeneratedColumn<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$QuestionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $QuestionsTable,
    Question,
    $$QuestionsTableFilterComposer,
    $$QuestionsTableOrderingComposer,
    $$QuestionsTableAnnotationComposer,
    $$QuestionsTableCreateCompanionBuilder,
    $$QuestionsTableUpdateCompanionBuilder,
    (Question, BaseReferences<_$AppDatabase, $QuestionsTable, Question>),
    Question,
    PrefetchHooks Function()> {
  $$QuestionsTableTableManager(_$AppDatabase db, $QuestionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> levelId = const Value.absent(),
            Value<String> question = const Value.absent(),
            Value<String> optionA = const Value.absent(),
            Value<String> optionB = const Value.absent(),
            Value<String> optionC = const Value.absent(),
            Value<String> optionD = const Value.absent(),
            Value<int> correctAnswerIndex = const Value.absent(),
            Value<double> difficulty = const Value.absent(),
            Value<String> explanation = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              QuestionsCompanion(
            id: id,
            levelId: levelId,
            question: question,
            optionA: optionA,
            optionB: optionB,
            optionC: optionC,
            optionD: optionD,
            correctAnswerIndex: correctAnswerIndex,
            difficulty: difficulty,
            explanation: explanation,
            version: version,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String levelId,
            required String question,
            required String optionA,
            required String optionB,
            required String optionC,
            required String optionD,
            required int correctAnswerIndex,
            required double difficulty,
            required String explanation,
            required int version,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              QuestionsCompanion.insert(
            id: id,
            levelId: levelId,
            question: question,
            optionA: optionA,
            optionB: optionB,
            optionC: optionC,
            optionD: optionD,
            correctAnswerIndex: correctAnswerIndex,
            difficulty: difficulty,
            explanation: explanation,
            version: version,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$QuestionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $QuestionsTable,
    Question,
    $$QuestionsTableFilterComposer,
    $$QuestionsTableOrderingComposer,
    $$QuestionsTableAnnotationComposer,
    $$QuestionsTableCreateCompanionBuilder,
    $$QuestionsTableUpdateCompanionBuilder,
    (Question, BaseReferences<_$AppDatabase, $QuestionsTable, Question>),
    Question,
    PrefetchHooks Function()>;
typedef $$LevelsTableCreateCompanionBuilder = LevelsCompanion Function({
  required String id,
  required String topicId,
  required String title,
  required String subtitle,
  required int order,
  required int xpReward,
  required int version,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$LevelsTableUpdateCompanionBuilder = LevelsCompanion Function({
  Value<String> id,
  Value<String> topicId,
  Value<String> title,
  Value<String> subtitle,
  Value<int> order,
  Value<int> xpReward,
  Value<int> version,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$LevelsTableFilterComposer
    extends Composer<_$AppDatabase, $LevelsTable> {
  $$LevelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get topicId => $composableBuilder(
      column: $table.topicId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subtitle => $composableBuilder(
      column: $table.subtitle, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get xpReward => $composableBuilder(
      column: $table.xpReward, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$LevelsTableOrderingComposer
    extends Composer<_$AppDatabase, $LevelsTable> {
  $$LevelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get topicId => $composableBuilder(
      column: $table.topicId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subtitle => $composableBuilder(
      column: $table.subtitle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get xpReward => $composableBuilder(
      column: $table.xpReward, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$LevelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LevelsTable> {
  $$LevelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get topicId =>
      $composableBuilder(column: $table.topicId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get subtitle =>
      $composableBuilder(column: $table.subtitle, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<int> get xpReward =>
      $composableBuilder(column: $table.xpReward, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LevelsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LevelsTable,
    Level,
    $$LevelsTableFilterComposer,
    $$LevelsTableOrderingComposer,
    $$LevelsTableAnnotationComposer,
    $$LevelsTableCreateCompanionBuilder,
    $$LevelsTableUpdateCompanionBuilder,
    (Level, BaseReferences<_$AppDatabase, $LevelsTable, Level>),
    Level,
    PrefetchHooks Function()> {
  $$LevelsTableTableManager(_$AppDatabase db, $LevelsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LevelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LevelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LevelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> topicId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> subtitle = const Value.absent(),
            Value<int> order = const Value.absent(),
            Value<int> xpReward = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LevelsCompanion(
            id: id,
            topicId: topicId,
            title: title,
            subtitle: subtitle,
            order: order,
            xpReward: xpReward,
            version: version,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String topicId,
            required String title,
            required String subtitle,
            required int order,
            required int xpReward,
            required int version,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              LevelsCompanion.insert(
            id: id,
            topicId: topicId,
            title: title,
            subtitle: subtitle,
            order: order,
            xpReward: xpReward,
            version: version,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LevelsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LevelsTable,
    Level,
    $$LevelsTableFilterComposer,
    $$LevelsTableOrderingComposer,
    $$LevelsTableAnnotationComposer,
    $$LevelsTableCreateCompanionBuilder,
    $$LevelsTableUpdateCompanionBuilder,
    (Level, BaseReferences<_$AppDatabase, $LevelsTable, Level>),
    Level,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TopicsTableTableManager get topics =>
      $$TopicsTableTableManager(_db, _db.topics);
  $$SubjectsTableTableManager get subjects =>
      $$SubjectsTableTableManager(_db, _db.subjects);
  $$QuestionsTableTableManager get questions =>
      $$QuestionsTableTableManager(_db, _db.questions);
  $$LevelsTableTableManager get levels =>
      $$LevelsTableTableManager(_db, _db.levels);
}
