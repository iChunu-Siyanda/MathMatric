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

class $ExamPapersTable extends ExamPapers
    with TableInfo<$ExamPapersTable, ExamPaper> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamPapersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _subjectIdMeta =
      const VerificationMeta('subjectId');
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
      'subject_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _parentPaperIdMeta =
      const VerificationMeta('parentPaperId');
  @override
  late final GeneratedColumn<String> parentPaperId = GeneratedColumn<String>(
      'parent_paper_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _paperTypeMeta =
      const VerificationMeta('paperType');
  @override
  late final GeneratedColumn<String> paperType = GeneratedColumn<String>(
      'paper_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sessionMeta =
      const VerificationMeta('session');
  @override
  late final GeneratedColumn<String> session = GeneratedColumn<String>(
      'session', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isMemoMeta = const VerificationMeta('isMemo');
  @override
  late final GeneratedColumn<bool> isMemo = GeneratedColumn<bool>(
      'is_memo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_memo" IN (0, 1))'));
  static const VerificationMeta _storagePathMeta =
      const VerificationMeta('storagePath');
  @override
  late final GeneratedColumn<String> storagePath = GeneratedColumn<String>(
      'storage_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _provinceMeta =
      const VerificationMeta('province');
  @override
  late final GeneratedColumn<String> province = GeneratedColumn<String>(
      'province', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isNationalMeta =
      const VerificationMeta('isNational');
  @override
  late final GeneratedColumn<bool> isNational = GeneratedColumn<bool>(
      'is_national', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_national" IN (0, 1))'));
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _pageCountMeta =
      const VerificationMeta('pageCount');
  @override
  late final GeneratedColumn<int> pageCount = GeneratedColumn<int>(
      'page_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _downloadedMeta =
      const VerificationMeta('downloaded');
  @override
  late final GeneratedColumn<bool> downloaded = GeneratedColumn<bool>(
      'downloaded', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("downloaded" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        subjectId,
        parentPaperId,
        paperType,
        session,
        title,
        isMemo,
        storagePath,
        province,
        isNational,
        year,
        pageCount,
        version,
        downloaded
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exam_papers';
  @override
  VerificationContext validateIntegrity(Insertable<ExamPaper> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(_subjectIdMeta,
          subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta));
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('parent_paper_id')) {
      context.handle(
          _parentPaperIdMeta,
          parentPaperId.isAcceptableOrUnknown(
              data['parent_paper_id']!, _parentPaperIdMeta));
    }
    if (data.containsKey('paper_type')) {
      context.handle(_paperTypeMeta,
          paperType.isAcceptableOrUnknown(data['paper_type']!, _paperTypeMeta));
    } else if (isInserting) {
      context.missing(_paperTypeMeta);
    }
    if (data.containsKey('session')) {
      context.handle(_sessionMeta,
          session.isAcceptableOrUnknown(data['session']!, _sessionMeta));
    } else if (isInserting) {
      context.missing(_sessionMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('is_memo')) {
      context.handle(_isMemoMeta,
          isMemo.isAcceptableOrUnknown(data['is_memo']!, _isMemoMeta));
    } else if (isInserting) {
      context.missing(_isMemoMeta);
    }
    if (data.containsKey('storage_path')) {
      context.handle(
          _storagePathMeta,
          storagePath.isAcceptableOrUnknown(
              data['storage_path']!, _storagePathMeta));
    } else if (isInserting) {
      context.missing(_storagePathMeta);
    }
    if (data.containsKey('province')) {
      context.handle(_provinceMeta,
          province.isAcceptableOrUnknown(data['province']!, _provinceMeta));
    }
    if (data.containsKey('is_national')) {
      context.handle(
          _isNationalMeta,
          isNational.isAcceptableOrUnknown(
              data['is_national']!, _isNationalMeta));
    } else if (isInserting) {
      context.missing(_isNationalMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('page_count')) {
      context.handle(_pageCountMeta,
          pageCount.isAcceptableOrUnknown(data['page_count']!, _pageCountMeta));
    } else if (isInserting) {
      context.missing(_pageCountMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('downloaded')) {
      context.handle(
          _downloadedMeta,
          downloaded.isAcceptableOrUnknown(
              data['downloaded']!, _downloadedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  ExamPaper map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExamPaper(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      subjectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subject_id'])!,
      parentPaperId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_paper_id']),
      paperType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}paper_type'])!,
      session: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      isMemo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_memo'])!,
      storagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}storage_path'])!,
      province: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}province']),
      isNational: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_national'])!,
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year'])!,
      pageCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}page_count'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      downloaded: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}downloaded'])!,
    );
  }

  @override
  $ExamPapersTable createAlias(String alias) {
    return $ExamPapersTable(attachedDatabase, alias);
  }
}

class ExamPaper extends DataClass implements Insertable<ExamPaper> {
  final String id;
  final String subjectId;
  final String? parentPaperId;
  final String paperType;
  final String session;
  final String title;
  final bool isMemo;
  final String storagePath;
  final String? province;
  final bool isNational;
  final int year;
  final int pageCount;
  final int version;
  final bool downloaded;
  const ExamPaper(
      {required this.id,
      required this.subjectId,
      this.parentPaperId,
      required this.paperType,
      required this.session,
      required this.title,
      required this.isMemo,
      required this.storagePath,
      this.province,
      required this.isNational,
      required this.year,
      required this.pageCount,
      required this.version,
      required this.downloaded});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['subject_id'] = Variable<String>(subjectId);
    if (!nullToAbsent || parentPaperId != null) {
      map['parent_paper_id'] = Variable<String>(parentPaperId);
    }
    map['paper_type'] = Variable<String>(paperType);
    map['session'] = Variable<String>(session);
    map['title'] = Variable<String>(title);
    map['is_memo'] = Variable<bool>(isMemo);
    map['storage_path'] = Variable<String>(storagePath);
    if (!nullToAbsent || province != null) {
      map['province'] = Variable<String>(province);
    }
    map['is_national'] = Variable<bool>(isNational);
    map['year'] = Variable<int>(year);
    map['page_count'] = Variable<int>(pageCount);
    map['version'] = Variable<int>(version);
    map['downloaded'] = Variable<bool>(downloaded);
    return map;
  }

  ExamPapersCompanion toCompanion(bool nullToAbsent) {
    return ExamPapersCompanion(
      id: Value(id),
      subjectId: Value(subjectId),
      parentPaperId: parentPaperId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentPaperId),
      paperType: Value(paperType),
      session: Value(session),
      title: Value(title),
      isMemo: Value(isMemo),
      storagePath: Value(storagePath),
      province: province == null && nullToAbsent
          ? const Value.absent()
          : Value(province),
      isNational: Value(isNational),
      year: Value(year),
      pageCount: Value(pageCount),
      version: Value(version),
      downloaded: Value(downloaded),
    );
  }

  factory ExamPaper.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExamPaper(
      id: serializer.fromJson<String>(json['id']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      parentPaperId: serializer.fromJson<String?>(json['parentPaperId']),
      paperType: serializer.fromJson<String>(json['paperType']),
      session: serializer.fromJson<String>(json['session']),
      title: serializer.fromJson<String>(json['title']),
      isMemo: serializer.fromJson<bool>(json['isMemo']),
      storagePath: serializer.fromJson<String>(json['storagePath']),
      province: serializer.fromJson<String?>(json['province']),
      isNational: serializer.fromJson<bool>(json['isNational']),
      year: serializer.fromJson<int>(json['year']),
      pageCount: serializer.fromJson<int>(json['pageCount']),
      version: serializer.fromJson<int>(json['version']),
      downloaded: serializer.fromJson<bool>(json['downloaded']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subjectId': serializer.toJson<String>(subjectId),
      'parentPaperId': serializer.toJson<String?>(parentPaperId),
      'paperType': serializer.toJson<String>(paperType),
      'session': serializer.toJson<String>(session),
      'title': serializer.toJson<String>(title),
      'isMemo': serializer.toJson<bool>(isMemo),
      'storagePath': serializer.toJson<String>(storagePath),
      'province': serializer.toJson<String?>(province),
      'isNational': serializer.toJson<bool>(isNational),
      'year': serializer.toJson<int>(year),
      'pageCount': serializer.toJson<int>(pageCount),
      'version': serializer.toJson<int>(version),
      'downloaded': serializer.toJson<bool>(downloaded),
    };
  }

  ExamPaper copyWith(
          {String? id,
          String? subjectId,
          Value<String?> parentPaperId = const Value.absent(),
          String? paperType,
          String? session,
          String? title,
          bool? isMemo,
          String? storagePath,
          Value<String?> province = const Value.absent(),
          bool? isNational,
          int? year,
          int? pageCount,
          int? version,
          bool? downloaded}) =>
      ExamPaper(
        id: id ?? this.id,
        subjectId: subjectId ?? this.subjectId,
        parentPaperId:
            parentPaperId.present ? parentPaperId.value : this.parentPaperId,
        paperType: paperType ?? this.paperType,
        session: session ?? this.session,
        title: title ?? this.title,
        isMemo: isMemo ?? this.isMemo,
        storagePath: storagePath ?? this.storagePath,
        province: province.present ? province.value : this.province,
        isNational: isNational ?? this.isNational,
        year: year ?? this.year,
        pageCount: pageCount ?? this.pageCount,
        version: version ?? this.version,
        downloaded: downloaded ?? this.downloaded,
      );
  ExamPaper copyWithCompanion(ExamPapersCompanion data) {
    return ExamPaper(
      id: data.id.present ? data.id.value : this.id,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      parentPaperId: data.parentPaperId.present
          ? data.parentPaperId.value
          : this.parentPaperId,
      paperType: data.paperType.present ? data.paperType.value : this.paperType,
      session: data.session.present ? data.session.value : this.session,
      title: data.title.present ? data.title.value : this.title,
      isMemo: data.isMemo.present ? data.isMemo.value : this.isMemo,
      storagePath:
          data.storagePath.present ? data.storagePath.value : this.storagePath,
      province: data.province.present ? data.province.value : this.province,
      isNational:
          data.isNational.present ? data.isNational.value : this.isNational,
      year: data.year.present ? data.year.value : this.year,
      pageCount: data.pageCount.present ? data.pageCount.value : this.pageCount,
      version: data.version.present ? data.version.value : this.version,
      downloaded:
          data.downloaded.present ? data.downloaded.value : this.downloaded,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExamPaper(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('parentPaperId: $parentPaperId, ')
          ..write('paperType: $paperType, ')
          ..write('session: $session, ')
          ..write('title: $title, ')
          ..write('isMemo: $isMemo, ')
          ..write('storagePath: $storagePath, ')
          ..write('province: $province, ')
          ..write('isNational: $isNational, ')
          ..write('year: $year, ')
          ..write('pageCount: $pageCount, ')
          ..write('version: $version, ')
          ..write('downloaded: $downloaded')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      subjectId,
      parentPaperId,
      paperType,
      session,
      title,
      isMemo,
      storagePath,
      province,
      isNational,
      year,
      pageCount,
      version,
      downloaded);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExamPaper &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.parentPaperId == this.parentPaperId &&
          other.paperType == this.paperType &&
          other.session == this.session &&
          other.title == this.title &&
          other.isMemo == this.isMemo &&
          other.storagePath == this.storagePath &&
          other.province == this.province &&
          other.isNational == this.isNational &&
          other.year == this.year &&
          other.pageCount == this.pageCount &&
          other.version == this.version &&
          other.downloaded == this.downloaded);
}

class ExamPapersCompanion extends UpdateCompanion<ExamPaper> {
  final Value<String> id;
  final Value<String> subjectId;
  final Value<String?> parentPaperId;
  final Value<String> paperType;
  final Value<String> session;
  final Value<String> title;
  final Value<bool> isMemo;
  final Value<String> storagePath;
  final Value<String?> province;
  final Value<bool> isNational;
  final Value<int> year;
  final Value<int> pageCount;
  final Value<int> version;
  final Value<bool> downloaded;
  final Value<int> rowid;
  const ExamPapersCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.parentPaperId = const Value.absent(),
    this.paperType = const Value.absent(),
    this.session = const Value.absent(),
    this.title = const Value.absent(),
    this.isMemo = const Value.absent(),
    this.storagePath = const Value.absent(),
    this.province = const Value.absent(),
    this.isNational = const Value.absent(),
    this.year = const Value.absent(),
    this.pageCount = const Value.absent(),
    this.version = const Value.absent(),
    this.downloaded = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExamPapersCompanion.insert({
    required String id,
    required String subjectId,
    this.parentPaperId = const Value.absent(),
    required String paperType,
    required String session,
    required String title,
    required bool isMemo,
    required String storagePath,
    this.province = const Value.absent(),
    required bool isNational,
    required int year,
    required int pageCount,
    required int version,
    this.downloaded = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        subjectId = Value(subjectId),
        paperType = Value(paperType),
        session = Value(session),
        title = Value(title),
        isMemo = Value(isMemo),
        storagePath = Value(storagePath),
        isNational = Value(isNational),
        year = Value(year),
        pageCount = Value(pageCount),
        version = Value(version);
  static Insertable<ExamPaper> custom({
    Expression<String>? id,
    Expression<String>? subjectId,
    Expression<String>? parentPaperId,
    Expression<String>? paperType,
    Expression<String>? session,
    Expression<String>? title,
    Expression<bool>? isMemo,
    Expression<String>? storagePath,
    Expression<String>? province,
    Expression<bool>? isNational,
    Expression<int>? year,
    Expression<int>? pageCount,
    Expression<int>? version,
    Expression<bool>? downloaded,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (parentPaperId != null) 'parent_paper_id': parentPaperId,
      if (paperType != null) 'paper_type': paperType,
      if (session != null) 'session': session,
      if (title != null) 'title': title,
      if (isMemo != null) 'is_memo': isMemo,
      if (storagePath != null) 'storage_path': storagePath,
      if (province != null) 'province': province,
      if (isNational != null) 'is_national': isNational,
      if (year != null) 'year': year,
      if (pageCount != null) 'page_count': pageCount,
      if (version != null) 'version': version,
      if (downloaded != null) 'downloaded': downloaded,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExamPapersCompanion copyWith(
      {Value<String>? id,
      Value<String>? subjectId,
      Value<String?>? parentPaperId,
      Value<String>? paperType,
      Value<String>? session,
      Value<String>? title,
      Value<bool>? isMemo,
      Value<String>? storagePath,
      Value<String?>? province,
      Value<bool>? isNational,
      Value<int>? year,
      Value<int>? pageCount,
      Value<int>? version,
      Value<bool>? downloaded,
      Value<int>? rowid}) {
    return ExamPapersCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      parentPaperId: parentPaperId ?? this.parentPaperId,
      paperType: paperType ?? this.paperType,
      session: session ?? this.session,
      title: title ?? this.title,
      isMemo: isMemo ?? this.isMemo,
      storagePath: storagePath ?? this.storagePath,
      province: province ?? this.province,
      isNational: isNational ?? this.isNational,
      year: year ?? this.year,
      pageCount: pageCount ?? this.pageCount,
      version: version ?? this.version,
      downloaded: downloaded ?? this.downloaded,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (parentPaperId.present) {
      map['parent_paper_id'] = Variable<String>(parentPaperId.value);
    }
    if (paperType.present) {
      map['paper_type'] = Variable<String>(paperType.value);
    }
    if (session.present) {
      map['session'] = Variable<String>(session.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (isMemo.present) {
      map['is_memo'] = Variable<bool>(isMemo.value);
    }
    if (storagePath.present) {
      map['storage_path'] = Variable<String>(storagePath.value);
    }
    if (province.present) {
      map['province'] = Variable<String>(province.value);
    }
    if (isNational.present) {
      map['is_national'] = Variable<bool>(isNational.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (pageCount.present) {
      map['page_count'] = Variable<int>(pageCount.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (downloaded.present) {
      map['downloaded'] = Variable<bool>(downloaded.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamPapersCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('parentPaperId: $parentPaperId, ')
          ..write('paperType: $paperType, ')
          ..write('session: $session, ')
          ..write('title: $title, ')
          ..write('isMemo: $isMemo, ')
          ..write('storagePath: $storagePath, ')
          ..write('province: $province, ')
          ..write('isNational: $isNational, ')
          ..write('year: $year, ')
          ..write('pageCount: $pageCount, ')
          ..write('version: $version, ')
          ..write('downloaded: $downloaded, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuestionAttemptsTable extends QuestionAttempts
    with TableInfo<$QuestionAttemptsTable, QuestionAttempt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionAttemptsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _questionIdMeta =
      const VerificationMeta('questionId');
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
      'question_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _correctMeta =
      const VerificationMeta('correct');
  @override
  late final GeneratedColumn<bool> correct = GeneratedColumn<bool>(
      'correct', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("correct" IN (0, 1))'));
  static const VerificationMeta _timeTakenMeta =
      const VerificationMeta('timeTaken');
  @override
  late final GeneratedColumn<int> timeTaken = GeneratedColumn<int>(
      'time_taken', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _answeredAtMeta =
      const VerificationMeta('answeredAt');
  @override
  late final GeneratedColumn<DateTime> answeredAt = GeneratedColumn<DateTime>(
      'answered_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, levelId, questionId, correct, timeTaken, answeredAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'question_attempts';
  @override
  VerificationContext validateIntegrity(Insertable<QuestionAttempt> instance,
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
    if (data.containsKey('question_id')) {
      context.handle(
          _questionIdMeta,
          questionId.isAcceptableOrUnknown(
              data['question_id']!, _questionIdMeta));
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('correct')) {
      context.handle(_correctMeta,
          correct.isAcceptableOrUnknown(data['correct']!, _correctMeta));
    } else if (isInserting) {
      context.missing(_correctMeta);
    }
    if (data.containsKey('time_taken')) {
      context.handle(_timeTakenMeta,
          timeTaken.isAcceptableOrUnknown(data['time_taken']!, _timeTakenMeta));
    } else if (isInserting) {
      context.missing(_timeTakenMeta);
    }
    if (data.containsKey('answered_at')) {
      context.handle(
          _answeredAtMeta,
          answeredAt.isAcceptableOrUnknown(
              data['answered_at']!, _answeredAtMeta));
    } else if (isInserting) {
      context.missing(_answeredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  QuestionAttempt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestionAttempt(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      levelId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level_id'])!,
      questionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question_id'])!,
      correct: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}correct'])!,
      timeTaken: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}time_taken'])!,
      answeredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}answered_at'])!,
    );
  }

  @override
  $QuestionAttemptsTable createAlias(String alias) {
    return $QuestionAttemptsTable(attachedDatabase, alias);
  }
}

class QuestionAttempt extends DataClass implements Insertable<QuestionAttempt> {
  final String id;
  final String levelId;
  final String questionId;
  final bool correct;
  final int timeTaken;
  final DateTime answeredAt;
  const QuestionAttempt(
      {required this.id,
      required this.levelId,
      required this.questionId,
      required this.correct,
      required this.timeTaken,
      required this.answeredAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['level_id'] = Variable<String>(levelId);
    map['question_id'] = Variable<String>(questionId);
    map['correct'] = Variable<bool>(correct);
    map['time_taken'] = Variable<int>(timeTaken);
    map['answered_at'] = Variable<DateTime>(answeredAt);
    return map;
  }

  QuestionAttemptsCompanion toCompanion(bool nullToAbsent) {
    return QuestionAttemptsCompanion(
      id: Value(id),
      levelId: Value(levelId),
      questionId: Value(questionId),
      correct: Value(correct),
      timeTaken: Value(timeTaken),
      answeredAt: Value(answeredAt),
    );
  }

  factory QuestionAttempt.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestionAttempt(
      id: serializer.fromJson<String>(json['id']),
      levelId: serializer.fromJson<String>(json['levelId']),
      questionId: serializer.fromJson<String>(json['questionId']),
      correct: serializer.fromJson<bool>(json['correct']),
      timeTaken: serializer.fromJson<int>(json['timeTaken']),
      answeredAt: serializer.fromJson<DateTime>(json['answeredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'levelId': serializer.toJson<String>(levelId),
      'questionId': serializer.toJson<String>(questionId),
      'correct': serializer.toJson<bool>(correct),
      'timeTaken': serializer.toJson<int>(timeTaken),
      'answeredAt': serializer.toJson<DateTime>(answeredAt),
    };
  }

  QuestionAttempt copyWith(
          {String? id,
          String? levelId,
          String? questionId,
          bool? correct,
          int? timeTaken,
          DateTime? answeredAt}) =>
      QuestionAttempt(
        id: id ?? this.id,
        levelId: levelId ?? this.levelId,
        questionId: questionId ?? this.questionId,
        correct: correct ?? this.correct,
        timeTaken: timeTaken ?? this.timeTaken,
        answeredAt: answeredAt ?? this.answeredAt,
      );
  QuestionAttempt copyWithCompanion(QuestionAttemptsCompanion data) {
    return QuestionAttempt(
      id: data.id.present ? data.id.value : this.id,
      levelId: data.levelId.present ? data.levelId.value : this.levelId,
      questionId:
          data.questionId.present ? data.questionId.value : this.questionId,
      correct: data.correct.present ? data.correct.value : this.correct,
      timeTaken: data.timeTaken.present ? data.timeTaken.value : this.timeTaken,
      answeredAt:
          data.answeredAt.present ? data.answeredAt.value : this.answeredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestionAttempt(')
          ..write('id: $id, ')
          ..write('levelId: $levelId, ')
          ..write('questionId: $questionId, ')
          ..write('correct: $correct, ')
          ..write('timeTaken: $timeTaken, ')
          ..write('answeredAt: $answeredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, levelId, questionId, correct, timeTaken, answeredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestionAttempt &&
          other.id == this.id &&
          other.levelId == this.levelId &&
          other.questionId == this.questionId &&
          other.correct == this.correct &&
          other.timeTaken == this.timeTaken &&
          other.answeredAt == this.answeredAt);
}

class QuestionAttemptsCompanion extends UpdateCompanion<QuestionAttempt> {
  final Value<String> id;
  final Value<String> levelId;
  final Value<String> questionId;
  final Value<bool> correct;
  final Value<int> timeTaken;
  final Value<DateTime> answeredAt;
  final Value<int> rowid;
  const QuestionAttemptsCompanion({
    this.id = const Value.absent(),
    this.levelId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.correct = const Value.absent(),
    this.timeTaken = const Value.absent(),
    this.answeredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestionAttemptsCompanion.insert({
    required String id,
    required String levelId,
    required String questionId,
    required bool correct,
    required int timeTaken,
    required DateTime answeredAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        levelId = Value(levelId),
        questionId = Value(questionId),
        correct = Value(correct),
        timeTaken = Value(timeTaken),
        answeredAt = Value(answeredAt);
  static Insertable<QuestionAttempt> custom({
    Expression<String>? id,
    Expression<String>? levelId,
    Expression<String>? questionId,
    Expression<bool>? correct,
    Expression<int>? timeTaken,
    Expression<DateTime>? answeredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (levelId != null) 'level_id': levelId,
      if (questionId != null) 'question_id': questionId,
      if (correct != null) 'correct': correct,
      if (timeTaken != null) 'time_taken': timeTaken,
      if (answeredAt != null) 'answered_at': answeredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestionAttemptsCompanion copyWith(
      {Value<String>? id,
      Value<String>? levelId,
      Value<String>? questionId,
      Value<bool>? correct,
      Value<int>? timeTaken,
      Value<DateTime>? answeredAt,
      Value<int>? rowid}) {
    return QuestionAttemptsCompanion(
      id: id ?? this.id,
      levelId: levelId ?? this.levelId,
      questionId: questionId ?? this.questionId,
      correct: correct ?? this.correct,
      timeTaken: timeTaken ?? this.timeTaken,
      answeredAt: answeredAt ?? this.answeredAt,
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
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (correct.present) {
      map['correct'] = Variable<bool>(correct.value);
    }
    if (timeTaken.present) {
      map['time_taken'] = Variable<int>(timeTaken.value);
    }
    if (answeredAt.present) {
      map['answered_at'] = Variable<DateTime>(answeredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionAttemptsCompanion(')
          ..write('id: $id, ')
          ..write('levelId: $levelId, ')
          ..write('questionId: $questionId, ')
          ..write('correct: $correct, ')
          ..write('timeTaken: $timeTaken, ')
          ..write('answeredAt: $answeredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserLevelProgressesTable extends UserLevelProgresses
    with TableInfo<$UserLevelProgressesTable, UserLevelProgressesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserLevelProgressesTable(this.attachedDatabase, [this._alias]);
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
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _topicIdMeta =
      const VerificationMeta('topicId');
  @override
  late final GeneratedColumn<String> topicId = GeneratedColumn<String>(
      'topic_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _completedMeta =
      const VerificationMeta('completed');
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
      'completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("completed" IN (0, 1))'));
  static const VerificationMeta _earnedXPMeta =
      const VerificationMeta('earnedXP');
  @override
  late final GeneratedColumn<int> earnedXP = GeneratedColumn<int>(
      'earned_x_p', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _bestScoreMeta =
      const VerificationMeta('bestScore');
  @override
  late final GeneratedColumn<double> bestScore = GeneratedColumn<double>(
      'best_score', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _attemptsMeta =
      const VerificationMeta('attempts');
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
      'attempts', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastPlayedMeta =
      const VerificationMeta('lastPlayed');
  @override
  late final GeneratedColumn<DateTime> lastPlayed = GeneratedColumn<DateTime>(
      'last_played', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        levelId,
        topicId,
        completed,
        earnedXP,
        bestScore,
        attempts,
        completedAt,
        lastPlayed
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_level_progresses';
  @override
  VerificationContext validateIntegrity(
      Insertable<UserLevelProgressesData> instance,
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
    if (data.containsKey('topic_id')) {
      context.handle(_topicIdMeta,
          topicId.isAcceptableOrUnknown(data['topic_id']!, _topicIdMeta));
    } else if (isInserting) {
      context.missing(_topicIdMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
    } else if (isInserting) {
      context.missing(_completedMeta);
    }
    if (data.containsKey('earned_x_p')) {
      context.handle(_earnedXPMeta,
          earnedXP.isAcceptableOrUnknown(data['earned_x_p']!, _earnedXPMeta));
    } else if (isInserting) {
      context.missing(_earnedXPMeta);
    }
    if (data.containsKey('best_score')) {
      context.handle(_bestScoreMeta,
          bestScore.isAcceptableOrUnknown(data['best_score']!, _bestScoreMeta));
    } else if (isInserting) {
      context.missing(_bestScoreMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(_attemptsMeta,
          attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta));
    } else if (isInserting) {
      context.missing(_attemptsMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('last_played')) {
      context.handle(
          _lastPlayedMeta,
          lastPlayed.isAcceptableOrUnknown(
              data['last_played']!, _lastPlayedMeta));
    } else if (isInserting) {
      context.missing(_lastPlayedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  UserLevelProgressesData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserLevelProgressesData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      levelId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level_id'])!,
      topicId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}topic_id'])!,
      completed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completed'])!,
      earnedXP: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}earned_x_p'])!,
      bestScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}best_score'])!,
      attempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempts'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      lastPlayed: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_played'])!,
    );
  }

  @override
  $UserLevelProgressesTable createAlias(String alias) {
    return $UserLevelProgressesTable(attachedDatabase, alias);
  }
}

class UserLevelProgressesData extends DataClass
    implements Insertable<UserLevelProgressesData> {
  final String id;
  final String levelId;
  final String topicId;
  final bool completed;
  final int earnedXP;
  final double bestScore;
  final int attempts;
  final DateTime? completedAt;
  final DateTime lastPlayed;
  const UserLevelProgressesData(
      {required this.id,
      required this.levelId,
      required this.topicId,
      required this.completed,
      required this.earnedXP,
      required this.bestScore,
      required this.attempts,
      this.completedAt,
      required this.lastPlayed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['level_id'] = Variable<String>(levelId);
    map['topic_id'] = Variable<String>(topicId);
    map['completed'] = Variable<bool>(completed);
    map['earned_x_p'] = Variable<int>(earnedXP);
    map['best_score'] = Variable<double>(bestScore);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['last_played'] = Variable<DateTime>(lastPlayed);
    return map;
  }

  UserLevelProgressesCompanion toCompanion(bool nullToAbsent) {
    return UserLevelProgressesCompanion(
      id: Value(id),
      levelId: Value(levelId),
      topicId: Value(topicId),
      completed: Value(completed),
      earnedXP: Value(earnedXP),
      bestScore: Value(bestScore),
      attempts: Value(attempts),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      lastPlayed: Value(lastPlayed),
    );
  }

  factory UserLevelProgressesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserLevelProgressesData(
      id: serializer.fromJson<String>(json['id']),
      levelId: serializer.fromJson<String>(json['levelId']),
      topicId: serializer.fromJson<String>(json['topicId']),
      completed: serializer.fromJson<bool>(json['completed']),
      earnedXP: serializer.fromJson<int>(json['earnedXP']),
      bestScore: serializer.fromJson<double>(json['bestScore']),
      attempts: serializer.fromJson<int>(json['attempts']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      lastPlayed: serializer.fromJson<DateTime>(json['lastPlayed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'levelId': serializer.toJson<String>(levelId),
      'topicId': serializer.toJson<String>(topicId),
      'completed': serializer.toJson<bool>(completed),
      'earnedXP': serializer.toJson<int>(earnedXP),
      'bestScore': serializer.toJson<double>(bestScore),
      'attempts': serializer.toJson<int>(attempts),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'lastPlayed': serializer.toJson<DateTime>(lastPlayed),
    };
  }

  UserLevelProgressesData copyWith(
          {String? id,
          String? levelId,
          String? topicId,
          bool? completed,
          int? earnedXP,
          double? bestScore,
          int? attempts,
          Value<DateTime?> completedAt = const Value.absent(),
          DateTime? lastPlayed}) =>
      UserLevelProgressesData(
        id: id ?? this.id,
        levelId: levelId ?? this.levelId,
        topicId: topicId ?? this.topicId,
        completed: completed ?? this.completed,
        earnedXP: earnedXP ?? this.earnedXP,
        bestScore: bestScore ?? this.bestScore,
        attempts: attempts ?? this.attempts,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        lastPlayed: lastPlayed ?? this.lastPlayed,
      );
  UserLevelProgressesData copyWithCompanion(UserLevelProgressesCompanion data) {
    return UserLevelProgressesData(
      id: data.id.present ? data.id.value : this.id,
      levelId: data.levelId.present ? data.levelId.value : this.levelId,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
      completed: data.completed.present ? data.completed.value : this.completed,
      earnedXP: data.earnedXP.present ? data.earnedXP.value : this.earnedXP,
      bestScore: data.bestScore.present ? data.bestScore.value : this.bestScore,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      lastPlayed:
          data.lastPlayed.present ? data.lastPlayed.value : this.lastPlayed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserLevelProgressesData(')
          ..write('id: $id, ')
          ..write('levelId: $levelId, ')
          ..write('topicId: $topicId, ')
          ..write('completed: $completed, ')
          ..write('earnedXP: $earnedXP, ')
          ..write('bestScore: $bestScore, ')
          ..write('attempts: $attempts, ')
          ..write('completedAt: $completedAt, ')
          ..write('lastPlayed: $lastPlayed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, levelId, topicId, completed, earnedXP,
      bestScore, attempts, completedAt, lastPlayed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserLevelProgressesData &&
          other.id == this.id &&
          other.levelId == this.levelId &&
          other.topicId == this.topicId &&
          other.completed == this.completed &&
          other.earnedXP == this.earnedXP &&
          other.bestScore == this.bestScore &&
          other.attempts == this.attempts &&
          other.completedAt == this.completedAt &&
          other.lastPlayed == this.lastPlayed);
}

class UserLevelProgressesCompanion
    extends UpdateCompanion<UserLevelProgressesData> {
  final Value<String> id;
  final Value<String> levelId;
  final Value<String> topicId;
  final Value<bool> completed;
  final Value<int> earnedXP;
  final Value<double> bestScore;
  final Value<int> attempts;
  final Value<DateTime?> completedAt;
  final Value<DateTime> lastPlayed;
  final Value<int> rowid;
  const UserLevelProgressesCompanion({
    this.id = const Value.absent(),
    this.levelId = const Value.absent(),
    this.topicId = const Value.absent(),
    this.completed = const Value.absent(),
    this.earnedXP = const Value.absent(),
    this.bestScore = const Value.absent(),
    this.attempts = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.lastPlayed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserLevelProgressesCompanion.insert({
    required String id,
    required String levelId,
    required String topicId,
    required bool completed,
    required int earnedXP,
    required double bestScore,
    required int attempts,
    this.completedAt = const Value.absent(),
    required DateTime lastPlayed,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        levelId = Value(levelId),
        topicId = Value(topicId),
        completed = Value(completed),
        earnedXP = Value(earnedXP),
        bestScore = Value(bestScore),
        attempts = Value(attempts),
        lastPlayed = Value(lastPlayed);
  static Insertable<UserLevelProgressesData> custom({
    Expression<String>? id,
    Expression<String>? levelId,
    Expression<String>? topicId,
    Expression<bool>? completed,
    Expression<int>? earnedXP,
    Expression<double>? bestScore,
    Expression<int>? attempts,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? lastPlayed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (levelId != null) 'level_id': levelId,
      if (topicId != null) 'topic_id': topicId,
      if (completed != null) 'completed': completed,
      if (earnedXP != null) 'earned_x_p': earnedXP,
      if (bestScore != null) 'best_score': bestScore,
      if (attempts != null) 'attempts': attempts,
      if (completedAt != null) 'completed_at': completedAt,
      if (lastPlayed != null) 'last_played': lastPlayed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserLevelProgressesCompanion copyWith(
      {Value<String>? id,
      Value<String>? levelId,
      Value<String>? topicId,
      Value<bool>? completed,
      Value<int>? earnedXP,
      Value<double>? bestScore,
      Value<int>? attempts,
      Value<DateTime?>? completedAt,
      Value<DateTime>? lastPlayed,
      Value<int>? rowid}) {
    return UserLevelProgressesCompanion(
      id: id ?? this.id,
      levelId: levelId ?? this.levelId,
      topicId: topicId ?? this.topicId,
      completed: completed ?? this.completed,
      earnedXP: earnedXP ?? this.earnedXP,
      bestScore: bestScore ?? this.bestScore,
      attempts: attempts ?? this.attempts,
      completedAt: completedAt ?? this.completedAt,
      lastPlayed: lastPlayed ?? this.lastPlayed,
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
    if (topicId.present) {
      map['topic_id'] = Variable<String>(topicId.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (earnedXP.present) {
      map['earned_x_p'] = Variable<int>(earnedXP.value);
    }
    if (bestScore.present) {
      map['best_score'] = Variable<double>(bestScore.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (lastPlayed.present) {
      map['last_played'] = Variable<DateTime>(lastPlayed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserLevelProgressesCompanion(')
          ..write('id: $id, ')
          ..write('levelId: $levelId, ')
          ..write('topicId: $topicId, ')
          ..write('completed: $completed, ')
          ..write('earnedXP: $earnedXP, ')
          ..write('bestScore: $bestScore, ')
          ..write('attempts: $attempts, ')
          ..write('completedAt: $completedAt, ')
          ..write('lastPlayed: $lastPlayed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserTopicProgressesTable extends UserTopicProgresses
    with TableInfo<$UserTopicProgressesTable, UserTopicProgressesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserTopicProgressesTable(this.attachedDatabase, [this._alias]);
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
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _earnedXPMeta =
      const VerificationMeta('earnedXP');
  @override
  late final GeneratedColumn<int> earnedXP = GeneratedColumn<int>(
      'earned_x_p', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _masteryMeta =
      const VerificationMeta('mastery');
  @override
  late final GeneratedColumn<double> mastery = GeneratedColumn<double>(
      'mastery', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _lastPlayedMeta =
      const VerificationMeta('lastPlayed');
  @override
  late final GeneratedColumn<DateTime> lastPlayed = GeneratedColumn<DateTime>(
      'last_played', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _favoriteMeta =
      const VerificationMeta('favorite');
  @override
  late final GeneratedColumn<bool> favorite = GeneratedColumn<bool>(
      'favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("favorite" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, topicId, earnedXP, mastery, lastPlayed, favorite];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_topic_progresses';
  @override
  VerificationContext validateIntegrity(
      Insertable<UserTopicProgressesData> instance,
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
    if (data.containsKey('earned_x_p')) {
      context.handle(_earnedXPMeta,
          earnedXP.isAcceptableOrUnknown(data['earned_x_p']!, _earnedXPMeta));
    } else if (isInserting) {
      context.missing(_earnedXPMeta);
    }
    if (data.containsKey('mastery')) {
      context.handle(_masteryMeta,
          mastery.isAcceptableOrUnknown(data['mastery']!, _masteryMeta));
    } else if (isInserting) {
      context.missing(_masteryMeta);
    }
    if (data.containsKey('last_played')) {
      context.handle(
          _lastPlayedMeta,
          lastPlayed.isAcceptableOrUnknown(
              data['last_played']!, _lastPlayedMeta));
    } else if (isInserting) {
      context.missing(_lastPlayedMeta);
    }
    if (data.containsKey('favorite')) {
      context.handle(_favoriteMeta,
          favorite.isAcceptableOrUnknown(data['favorite']!, _favoriteMeta));
    } else if (isInserting) {
      context.missing(_favoriteMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  UserTopicProgressesData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserTopicProgressesData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      topicId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}topic_id'])!,
      earnedXP: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}earned_x_p'])!,
      mastery: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}mastery'])!,
      lastPlayed: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_played'])!,
      favorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}favorite'])!,
    );
  }

  @override
  $UserTopicProgressesTable createAlias(String alias) {
    return $UserTopicProgressesTable(attachedDatabase, alias);
  }
}

class UserTopicProgressesData extends DataClass
    implements Insertable<UserTopicProgressesData> {
  final String id;
  final String topicId;
  final int earnedXP;
  final double mastery;
  final DateTime lastPlayed;
  final bool favorite;
  const UserTopicProgressesData(
      {required this.id,
      required this.topicId,
      required this.earnedXP,
      required this.mastery,
      required this.lastPlayed,
      required this.favorite});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['topic_id'] = Variable<String>(topicId);
    map['earned_x_p'] = Variable<int>(earnedXP);
    map['mastery'] = Variable<double>(mastery);
    map['last_played'] = Variable<DateTime>(lastPlayed);
    map['favorite'] = Variable<bool>(favorite);
    return map;
  }

  UserTopicProgressesCompanion toCompanion(bool nullToAbsent) {
    return UserTopicProgressesCompanion(
      id: Value(id),
      topicId: Value(topicId),
      earnedXP: Value(earnedXP),
      mastery: Value(mastery),
      lastPlayed: Value(lastPlayed),
      favorite: Value(favorite),
    );
  }

  factory UserTopicProgressesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserTopicProgressesData(
      id: serializer.fromJson<String>(json['id']),
      topicId: serializer.fromJson<String>(json['topicId']),
      earnedXP: serializer.fromJson<int>(json['earnedXP']),
      mastery: serializer.fromJson<double>(json['mastery']),
      lastPlayed: serializer.fromJson<DateTime>(json['lastPlayed']),
      favorite: serializer.fromJson<bool>(json['favorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'topicId': serializer.toJson<String>(topicId),
      'earnedXP': serializer.toJson<int>(earnedXP),
      'mastery': serializer.toJson<double>(mastery),
      'lastPlayed': serializer.toJson<DateTime>(lastPlayed),
      'favorite': serializer.toJson<bool>(favorite),
    };
  }

  UserTopicProgressesData copyWith(
          {String? id,
          String? topicId,
          int? earnedXP,
          double? mastery,
          DateTime? lastPlayed,
          bool? favorite}) =>
      UserTopicProgressesData(
        id: id ?? this.id,
        topicId: topicId ?? this.topicId,
        earnedXP: earnedXP ?? this.earnedXP,
        mastery: mastery ?? this.mastery,
        lastPlayed: lastPlayed ?? this.lastPlayed,
        favorite: favorite ?? this.favorite,
      );
  UserTopicProgressesData copyWithCompanion(UserTopicProgressesCompanion data) {
    return UserTopicProgressesData(
      id: data.id.present ? data.id.value : this.id,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
      earnedXP: data.earnedXP.present ? data.earnedXP.value : this.earnedXP,
      mastery: data.mastery.present ? data.mastery.value : this.mastery,
      lastPlayed:
          data.lastPlayed.present ? data.lastPlayed.value : this.lastPlayed,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserTopicProgressesData(')
          ..write('id: $id, ')
          ..write('topicId: $topicId, ')
          ..write('earnedXP: $earnedXP, ')
          ..write('mastery: $mastery, ')
          ..write('lastPlayed: $lastPlayed, ')
          ..write('favorite: $favorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, topicId, earnedXP, mastery, lastPlayed, favorite);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserTopicProgressesData &&
          other.id == this.id &&
          other.topicId == this.topicId &&
          other.earnedXP == this.earnedXP &&
          other.mastery == this.mastery &&
          other.lastPlayed == this.lastPlayed &&
          other.favorite == this.favorite);
}

class UserTopicProgressesCompanion
    extends UpdateCompanion<UserTopicProgressesData> {
  final Value<String> id;
  final Value<String> topicId;
  final Value<int> earnedXP;
  final Value<double> mastery;
  final Value<DateTime> lastPlayed;
  final Value<bool> favorite;
  final Value<int> rowid;
  const UserTopicProgressesCompanion({
    this.id = const Value.absent(),
    this.topicId = const Value.absent(),
    this.earnedXP = const Value.absent(),
    this.mastery = const Value.absent(),
    this.lastPlayed = const Value.absent(),
    this.favorite = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserTopicProgressesCompanion.insert({
    required String id,
    required String topicId,
    required int earnedXP,
    required double mastery,
    required DateTime lastPlayed,
    required bool favorite,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        topicId = Value(topicId),
        earnedXP = Value(earnedXP),
        mastery = Value(mastery),
        lastPlayed = Value(lastPlayed),
        favorite = Value(favorite);
  static Insertable<UserTopicProgressesData> custom({
    Expression<String>? id,
    Expression<String>? topicId,
    Expression<int>? earnedXP,
    Expression<double>? mastery,
    Expression<DateTime>? lastPlayed,
    Expression<bool>? favorite,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (topicId != null) 'topic_id': topicId,
      if (earnedXP != null) 'earned_x_p': earnedXP,
      if (mastery != null) 'mastery': mastery,
      if (lastPlayed != null) 'last_played': lastPlayed,
      if (favorite != null) 'favorite': favorite,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserTopicProgressesCompanion copyWith(
      {Value<String>? id,
      Value<String>? topicId,
      Value<int>? earnedXP,
      Value<double>? mastery,
      Value<DateTime>? lastPlayed,
      Value<bool>? favorite,
      Value<int>? rowid}) {
    return UserTopicProgressesCompanion(
      id: id ?? this.id,
      topicId: topicId ?? this.topicId,
      earnedXP: earnedXP ?? this.earnedXP,
      mastery: mastery ?? this.mastery,
      lastPlayed: lastPlayed ?? this.lastPlayed,
      favorite: favorite ?? this.favorite,
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
    if (earnedXP.present) {
      map['earned_x_p'] = Variable<int>(earnedXP.value);
    }
    if (mastery.present) {
      map['mastery'] = Variable<double>(mastery.value);
    }
    if (lastPlayed.present) {
      map['last_played'] = Variable<DateTime>(lastPlayed.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<bool>(favorite.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserTopicProgressesCompanion(')
          ..write('id: $id, ')
          ..write('topicId: $topicId, ')
          ..write('earnedXP: $earnedXP, ')
          ..write('mastery: $mastery, ')
          ..write('lastPlayed: $lastPlayed, ')
          ..write('favorite: $favorite, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudySessionTable extends StudySession
    with TableInfo<$StudySessionTable, StudySessionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudySessionTable(this.attachedDatabase, [this._alias]);
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
  @override
  late final GeneratedColumnWithTypeConverter<StudyActivity, String> activity =
      GeneratedColumn<String>('activity', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<StudyActivity>($StudySessionTable.$converteractivity);
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endedAtMeta =
      const VerificationMeta('endedAt');
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
      'ended_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _questionsAnsweredMeta =
      const VerificationMeta('questionsAnswered');
  @override
  late final GeneratedColumn<int> questionsAnswered = GeneratedColumn<int>(
      'questions_answered', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _correctAnswersMeta =
      const VerificationMeta('correctAnswers');
  @override
  late final GeneratedColumn<int> correctAnswers = GeneratedColumn<int>(
      'correct_answers', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _earnedXPMeta =
      const VerificationMeta('earnedXP');
  @override
  late final GeneratedColumn<int> earnedXP = GeneratedColumn<int>(
      'earned_x_p', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        topicId,
        activity,
        startedAt,
        endedAt,
        questionsAnswered,
        correctAnswers,
        earnedXP
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_session';
  @override
  VerificationContext validateIntegrity(Insertable<StudySessionData> instance,
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
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(_endedAtMeta,
          endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta));
    } else if (isInserting) {
      context.missing(_endedAtMeta);
    }
    if (data.containsKey('questions_answered')) {
      context.handle(
          _questionsAnsweredMeta,
          questionsAnswered.isAcceptableOrUnknown(
              data['questions_answered']!, _questionsAnsweredMeta));
    } else if (isInserting) {
      context.missing(_questionsAnsweredMeta);
    }
    if (data.containsKey('correct_answers')) {
      context.handle(
          _correctAnswersMeta,
          correctAnswers.isAcceptableOrUnknown(
              data['correct_answers']!, _correctAnswersMeta));
    } else if (isInserting) {
      context.missing(_correctAnswersMeta);
    }
    if (data.containsKey('earned_x_p')) {
      context.handle(_earnedXPMeta,
          earnedXP.isAcceptableOrUnknown(data['earned_x_p']!, _earnedXPMeta));
    } else if (isInserting) {
      context.missing(_earnedXPMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  StudySessionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudySessionData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      topicId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}topic_id'])!,
      activity: $StudySessionTable.$converteractivity.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}activity'])!),
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      endedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}ended_at'])!,
      questionsAnswered: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}questions_answered'])!,
      correctAnswers: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}correct_answers'])!,
      earnedXP: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}earned_x_p'])!,
    );
  }

  @override
  $StudySessionTable createAlias(String alias) {
    return $StudySessionTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<StudyActivity, String, String> $converteractivity =
      const EnumNameConverter<StudyActivity>(StudyActivity.values);
}

class StudySessionData extends DataClass
    implements Insertable<StudySessionData> {
  final String id;
  final String topicId;
  final StudyActivity activity;
  final DateTime startedAt;
  final DateTime endedAt;
  final int questionsAnswered;
  final int correctAnswers;
  final int earnedXP;
  const StudySessionData(
      {required this.id,
      required this.topicId,
      required this.activity,
      required this.startedAt,
      required this.endedAt,
      required this.questionsAnswered,
      required this.correctAnswers,
      required this.earnedXP});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['topic_id'] = Variable<String>(topicId);
    {
      map['activity'] = Variable<String>(
          $StudySessionTable.$converteractivity.toSql(activity));
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    map['ended_at'] = Variable<DateTime>(endedAt);
    map['questions_answered'] = Variable<int>(questionsAnswered);
    map['correct_answers'] = Variable<int>(correctAnswers);
    map['earned_x_p'] = Variable<int>(earnedXP);
    return map;
  }

  StudySessionCompanion toCompanion(bool nullToAbsent) {
    return StudySessionCompanion(
      id: Value(id),
      topicId: Value(topicId),
      activity: Value(activity),
      startedAt: Value(startedAt),
      endedAt: Value(endedAt),
      questionsAnswered: Value(questionsAnswered),
      correctAnswers: Value(correctAnswers),
      earnedXP: Value(earnedXP),
    );
  }

  factory StudySessionData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudySessionData(
      id: serializer.fromJson<String>(json['id']),
      topicId: serializer.fromJson<String>(json['topicId']),
      activity: $StudySessionTable.$converteractivity
          .fromJson(serializer.fromJson<String>(json['activity'])),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime>(json['endedAt']),
      questionsAnswered: serializer.fromJson<int>(json['questionsAnswered']),
      correctAnswers: serializer.fromJson<int>(json['correctAnswers']),
      earnedXP: serializer.fromJson<int>(json['earnedXP']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'topicId': serializer.toJson<String>(topicId),
      'activity': serializer.toJson<String>(
          $StudySessionTable.$converteractivity.toJson(activity)),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime>(endedAt),
      'questionsAnswered': serializer.toJson<int>(questionsAnswered),
      'correctAnswers': serializer.toJson<int>(correctAnswers),
      'earnedXP': serializer.toJson<int>(earnedXP),
    };
  }

  StudySessionData copyWith(
          {String? id,
          String? topicId,
          StudyActivity? activity,
          DateTime? startedAt,
          DateTime? endedAt,
          int? questionsAnswered,
          int? correctAnswers,
          int? earnedXP}) =>
      StudySessionData(
        id: id ?? this.id,
        topicId: topicId ?? this.topicId,
        activity: activity ?? this.activity,
        startedAt: startedAt ?? this.startedAt,
        endedAt: endedAt ?? this.endedAt,
        questionsAnswered: questionsAnswered ?? this.questionsAnswered,
        correctAnswers: correctAnswers ?? this.correctAnswers,
        earnedXP: earnedXP ?? this.earnedXP,
      );
  StudySessionData copyWithCompanion(StudySessionCompanion data) {
    return StudySessionData(
      id: data.id.present ? data.id.value : this.id,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
      activity: data.activity.present ? data.activity.value : this.activity,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      questionsAnswered: data.questionsAnswered.present
          ? data.questionsAnswered.value
          : this.questionsAnswered,
      correctAnswers: data.correctAnswers.present
          ? data.correctAnswers.value
          : this.correctAnswers,
      earnedXP: data.earnedXP.present ? data.earnedXP.value : this.earnedXP,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudySessionData(')
          ..write('id: $id, ')
          ..write('topicId: $topicId, ')
          ..write('activity: $activity, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('questionsAnswered: $questionsAnswered, ')
          ..write('correctAnswers: $correctAnswers, ')
          ..write('earnedXP: $earnedXP')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, topicId, activity, startedAt, endedAt,
      questionsAnswered, correctAnswers, earnedXP);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudySessionData &&
          other.id == this.id &&
          other.topicId == this.topicId &&
          other.activity == this.activity &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.questionsAnswered == this.questionsAnswered &&
          other.correctAnswers == this.correctAnswers &&
          other.earnedXP == this.earnedXP);
}

class StudySessionCompanion extends UpdateCompanion<StudySessionData> {
  final Value<String> id;
  final Value<String> topicId;
  final Value<StudyActivity> activity;
  final Value<DateTime> startedAt;
  final Value<DateTime> endedAt;
  final Value<int> questionsAnswered;
  final Value<int> correctAnswers;
  final Value<int> earnedXP;
  final Value<int> rowid;
  const StudySessionCompanion({
    this.id = const Value.absent(),
    this.topicId = const Value.absent(),
    this.activity = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.questionsAnswered = const Value.absent(),
    this.correctAnswers = const Value.absent(),
    this.earnedXP = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudySessionCompanion.insert({
    required String id,
    required String topicId,
    required StudyActivity activity,
    required DateTime startedAt,
    required DateTime endedAt,
    required int questionsAnswered,
    required int correctAnswers,
    required int earnedXP,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        topicId = Value(topicId),
        activity = Value(activity),
        startedAt = Value(startedAt),
        endedAt = Value(endedAt),
        questionsAnswered = Value(questionsAnswered),
        correctAnswers = Value(correctAnswers),
        earnedXP = Value(earnedXP);
  static Insertable<StudySessionData> custom({
    Expression<String>? id,
    Expression<String>? topicId,
    Expression<String>? activity,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? questionsAnswered,
    Expression<int>? correctAnswers,
    Expression<int>? earnedXP,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (topicId != null) 'topic_id': topicId,
      if (activity != null) 'activity': activity,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (questionsAnswered != null) 'questions_answered': questionsAnswered,
      if (correctAnswers != null) 'correct_answers': correctAnswers,
      if (earnedXP != null) 'earned_x_p': earnedXP,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudySessionCompanion copyWith(
      {Value<String>? id,
      Value<String>? topicId,
      Value<StudyActivity>? activity,
      Value<DateTime>? startedAt,
      Value<DateTime>? endedAt,
      Value<int>? questionsAnswered,
      Value<int>? correctAnswers,
      Value<int>? earnedXP,
      Value<int>? rowid}) {
    return StudySessionCompanion(
      id: id ?? this.id,
      topicId: topicId ?? this.topicId,
      activity: activity ?? this.activity,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      questionsAnswered: questionsAnswered ?? this.questionsAnswered,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      earnedXP: earnedXP ?? this.earnedXP,
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
    if (activity.present) {
      map['activity'] = Variable<String>(
          $StudySessionTable.$converteractivity.toSql(activity.value));
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (questionsAnswered.present) {
      map['questions_answered'] = Variable<int>(questionsAnswered.value);
    }
    if (correctAnswers.present) {
      map['correct_answers'] = Variable<int>(correctAnswers.value);
    }
    if (earnedXP.present) {
      map['earned_x_p'] = Variable<int>(earnedXP.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudySessionCompanion(')
          ..write('id: $id, ')
          ..write('topicId: $topicId, ')
          ..write('activity: $activity, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('questionsAnswered: $questionsAnswered, ')
          ..write('correctAnswers: $correctAnswers, ')
          ..write('earnedXP: $earnedXP, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DownloadedBundleTable extends DownloadedBundle
    with TableInfo<$DownloadedBundleTable, DownloadedBundleData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadedBundleTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _downloadedAtMeta =
      const VerificationMeta('downloadedAt');
  @override
  late final GeneratedColumn<DateTime> downloadedAt = GeneratedColumn<DateTime>(
      'downloaded_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, version, downloadedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'downloaded_bundle';
  @override
  VerificationContext validateIntegrity(
      Insertable<DownloadedBundleData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('downloaded_at')) {
      context.handle(
          _downloadedAtMeta,
          downloadedAt.isAcceptableOrUnknown(
              data['downloaded_at']!, _downloadedAtMeta));
    } else if (isInserting) {
      context.missing(_downloadedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  DownloadedBundleData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DownloadedBundleData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      downloadedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}downloaded_at'])!,
    );
  }

  @override
  $DownloadedBundleTable createAlias(String alias) {
    return $DownloadedBundleTable(attachedDatabase, alias);
  }
}

class DownloadedBundleData extends DataClass
    implements Insertable<DownloadedBundleData> {
  final String id;
  final int version;
  final DateTime downloadedAt;
  const DownloadedBundleData(
      {required this.id, required this.version, required this.downloadedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['version'] = Variable<int>(version);
    map['downloaded_at'] = Variable<DateTime>(downloadedAt);
    return map;
  }

  DownloadedBundleCompanion toCompanion(bool nullToAbsent) {
    return DownloadedBundleCompanion(
      id: Value(id),
      version: Value(version),
      downloadedAt: Value(downloadedAt),
    );
  }

  factory DownloadedBundleData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DownloadedBundleData(
      id: serializer.fromJson<String>(json['id']),
      version: serializer.fromJson<int>(json['version']),
      downloadedAt: serializer.fromJson<DateTime>(json['downloadedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'version': serializer.toJson<int>(version),
      'downloadedAt': serializer.toJson<DateTime>(downloadedAt),
    };
  }

  DownloadedBundleData copyWith(
          {String? id, int? version, DateTime? downloadedAt}) =>
      DownloadedBundleData(
        id: id ?? this.id,
        version: version ?? this.version,
        downloadedAt: downloadedAt ?? this.downloadedAt,
      );
  DownloadedBundleData copyWithCompanion(DownloadedBundleCompanion data) {
    return DownloadedBundleData(
      id: data.id.present ? data.id.value : this.id,
      version: data.version.present ? data.version.value : this.version,
      downloadedAt: data.downloadedAt.present
          ? data.downloadedAt.value
          : this.downloadedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DownloadedBundleData(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('downloadedAt: $downloadedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, version, downloadedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadedBundleData &&
          other.id == this.id &&
          other.version == this.version &&
          other.downloadedAt == this.downloadedAt);
}

class DownloadedBundleCompanion extends UpdateCompanion<DownloadedBundleData> {
  final Value<String> id;
  final Value<int> version;
  final Value<DateTime> downloadedAt;
  final Value<int> rowid;
  const DownloadedBundleCompanion({
    this.id = const Value.absent(),
    this.version = const Value.absent(),
    this.downloadedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DownloadedBundleCompanion.insert({
    required String id,
    required int version,
    required DateTime downloadedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        version = Value(version),
        downloadedAt = Value(downloadedAt);
  static Insertable<DownloadedBundleData> custom({
    Expression<String>? id,
    Expression<int>? version,
    Expression<DateTime>? downloadedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (version != null) 'version': version,
      if (downloadedAt != null) 'downloaded_at': downloadedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DownloadedBundleCompanion copyWith(
      {Value<String>? id,
      Value<int>? version,
      Value<DateTime>? downloadedAt,
      Value<int>? rowid}) {
    return DownloadedBundleCompanion(
      id: id ?? this.id,
      version: version ?? this.version,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (downloadedAt.present) {
      map['downloaded_at'] = Variable<DateTime>(downloadedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadedBundleCompanion(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('downloadedAt: $downloadedAt, ')
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
  late final $ExamPapersTable examPapers = $ExamPapersTable(this);
  late final $QuestionAttemptsTable questionAttempts =
      $QuestionAttemptsTable(this);
  late final $UserLevelProgressesTable userLevelProgresses =
      $UserLevelProgressesTable(this);
  late final $UserTopicProgressesTable userTopicProgresses =
      $UserTopicProgressesTable(this);
  late final $StudySessionTable studySession = $StudySessionTable(this);
  late final $DownloadedBundleTable downloadedBundle =
      $DownloadedBundleTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        topics,
        subjects,
        questions,
        levels,
        examPapers,
        questionAttempts,
        userLevelProgresses,
        userTopicProgresses,
        studySession,
        downloadedBundle
      ];
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
typedef $$ExamPapersTableCreateCompanionBuilder = ExamPapersCompanion Function({
  required String id,
  required String subjectId,
  Value<String?> parentPaperId,
  required String paperType,
  required String session,
  required String title,
  required bool isMemo,
  required String storagePath,
  Value<String?> province,
  required bool isNational,
  required int year,
  required int pageCount,
  required int version,
  Value<bool> downloaded,
  Value<int> rowid,
});
typedef $$ExamPapersTableUpdateCompanionBuilder = ExamPapersCompanion Function({
  Value<String> id,
  Value<String> subjectId,
  Value<String?> parentPaperId,
  Value<String> paperType,
  Value<String> session,
  Value<String> title,
  Value<bool> isMemo,
  Value<String> storagePath,
  Value<String?> province,
  Value<bool> isNational,
  Value<int> year,
  Value<int> pageCount,
  Value<int> version,
  Value<bool> downloaded,
  Value<int> rowid,
});

class $$ExamPapersTableFilterComposer
    extends Composer<_$AppDatabase, $ExamPapersTable> {
  $$ExamPapersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subjectId => $composableBuilder(
      column: $table.subjectId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parentPaperId => $composableBuilder(
      column: $table.parentPaperId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paperType => $composableBuilder(
      column: $table.paperType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get session => $composableBuilder(
      column: $table.session, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isMemo => $composableBuilder(
      column: $table.isMemo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get storagePath => $composableBuilder(
      column: $table.storagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get province => $composableBuilder(
      column: $table.province, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isNational => $composableBuilder(
      column: $table.isNational, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pageCount => $composableBuilder(
      column: $table.pageCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get downloaded => $composableBuilder(
      column: $table.downloaded, builder: (column) => ColumnFilters(column));
}

class $$ExamPapersTableOrderingComposer
    extends Composer<_$AppDatabase, $ExamPapersTable> {
  $$ExamPapersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subjectId => $composableBuilder(
      column: $table.subjectId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentPaperId => $composableBuilder(
      column: $table.parentPaperId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paperType => $composableBuilder(
      column: $table.paperType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get session => $composableBuilder(
      column: $table.session, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isMemo => $composableBuilder(
      column: $table.isMemo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get storagePath => $composableBuilder(
      column: $table.storagePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get province => $composableBuilder(
      column: $table.province, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isNational => $composableBuilder(
      column: $table.isNational, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pageCount => $composableBuilder(
      column: $table.pageCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get downloaded => $composableBuilder(
      column: $table.downloaded, builder: (column) => ColumnOrderings(column));
}

class $$ExamPapersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExamPapersTable> {
  $$ExamPapersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<String> get parentPaperId => $composableBuilder(
      column: $table.parentPaperId, builder: (column) => column);

  GeneratedColumn<String> get paperType =>
      $composableBuilder(column: $table.paperType, builder: (column) => column);

  GeneratedColumn<String> get session =>
      $composableBuilder(column: $table.session, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get isMemo =>
      $composableBuilder(column: $table.isMemo, builder: (column) => column);

  GeneratedColumn<String> get storagePath => $composableBuilder(
      column: $table.storagePath, builder: (column) => column);

  GeneratedColumn<String> get province =>
      $composableBuilder(column: $table.province, builder: (column) => column);

  GeneratedColumn<bool> get isNational => $composableBuilder(
      column: $table.isNational, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get pageCount =>
      $composableBuilder(column: $table.pageCount, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<bool> get downloaded => $composableBuilder(
      column: $table.downloaded, builder: (column) => column);
}

class $$ExamPapersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExamPapersTable,
    ExamPaper,
    $$ExamPapersTableFilterComposer,
    $$ExamPapersTableOrderingComposer,
    $$ExamPapersTableAnnotationComposer,
    $$ExamPapersTableCreateCompanionBuilder,
    $$ExamPapersTableUpdateCompanionBuilder,
    (ExamPaper, BaseReferences<_$AppDatabase, $ExamPapersTable, ExamPaper>),
    ExamPaper,
    PrefetchHooks Function()> {
  $$ExamPapersTableTableManager(_$AppDatabase db, $ExamPapersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExamPapersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExamPapersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExamPapersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> subjectId = const Value.absent(),
            Value<String?> parentPaperId = const Value.absent(),
            Value<String> paperType = const Value.absent(),
            Value<String> session = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<bool> isMemo = const Value.absent(),
            Value<String> storagePath = const Value.absent(),
            Value<String?> province = const Value.absent(),
            Value<bool> isNational = const Value.absent(),
            Value<int> year = const Value.absent(),
            Value<int> pageCount = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<bool> downloaded = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExamPapersCompanion(
            id: id,
            subjectId: subjectId,
            parentPaperId: parentPaperId,
            paperType: paperType,
            session: session,
            title: title,
            isMemo: isMemo,
            storagePath: storagePath,
            province: province,
            isNational: isNational,
            year: year,
            pageCount: pageCount,
            version: version,
            downloaded: downloaded,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String subjectId,
            Value<String?> parentPaperId = const Value.absent(),
            required String paperType,
            required String session,
            required String title,
            required bool isMemo,
            required String storagePath,
            Value<String?> province = const Value.absent(),
            required bool isNational,
            required int year,
            required int pageCount,
            required int version,
            Value<bool> downloaded = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExamPapersCompanion.insert(
            id: id,
            subjectId: subjectId,
            parentPaperId: parentPaperId,
            paperType: paperType,
            session: session,
            title: title,
            isMemo: isMemo,
            storagePath: storagePath,
            province: province,
            isNational: isNational,
            year: year,
            pageCount: pageCount,
            version: version,
            downloaded: downloaded,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExamPapersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExamPapersTable,
    ExamPaper,
    $$ExamPapersTableFilterComposer,
    $$ExamPapersTableOrderingComposer,
    $$ExamPapersTableAnnotationComposer,
    $$ExamPapersTableCreateCompanionBuilder,
    $$ExamPapersTableUpdateCompanionBuilder,
    (ExamPaper, BaseReferences<_$AppDatabase, $ExamPapersTable, ExamPaper>),
    ExamPaper,
    PrefetchHooks Function()>;
typedef $$QuestionAttemptsTableCreateCompanionBuilder
    = QuestionAttemptsCompanion Function({
  required String id,
  required String levelId,
  required String questionId,
  required bool correct,
  required int timeTaken,
  required DateTime answeredAt,
  Value<int> rowid,
});
typedef $$QuestionAttemptsTableUpdateCompanionBuilder
    = QuestionAttemptsCompanion Function({
  Value<String> id,
  Value<String> levelId,
  Value<String> questionId,
  Value<bool> correct,
  Value<int> timeTaken,
  Value<DateTime> answeredAt,
  Value<int> rowid,
});

class $$QuestionAttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionAttemptsTable> {
  $$QuestionAttemptsTableFilterComposer({
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

  ColumnFilters<String> get questionId => $composableBuilder(
      column: $table.questionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get correct => $composableBuilder(
      column: $table.correct, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timeTaken => $composableBuilder(
      column: $table.timeTaken, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get answeredAt => $composableBuilder(
      column: $table.answeredAt, builder: (column) => ColumnFilters(column));
}

class $$QuestionAttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionAttemptsTable> {
  $$QuestionAttemptsTableOrderingComposer({
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

  ColumnOrderings<String> get questionId => $composableBuilder(
      column: $table.questionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get correct => $composableBuilder(
      column: $table.correct, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timeTaken => $composableBuilder(
      column: $table.timeTaken, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get answeredAt => $composableBuilder(
      column: $table.answeredAt, builder: (column) => ColumnOrderings(column));
}

class $$QuestionAttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionAttemptsTable> {
  $$QuestionAttemptsTableAnnotationComposer({
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

  GeneratedColumn<String> get questionId => $composableBuilder(
      column: $table.questionId, builder: (column) => column);

  GeneratedColumn<bool> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);

  GeneratedColumn<int> get timeTaken =>
      $composableBuilder(column: $table.timeTaken, builder: (column) => column);

  GeneratedColumn<DateTime> get answeredAt => $composableBuilder(
      column: $table.answeredAt, builder: (column) => column);
}

class $$QuestionAttemptsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $QuestionAttemptsTable,
    QuestionAttempt,
    $$QuestionAttemptsTableFilterComposer,
    $$QuestionAttemptsTableOrderingComposer,
    $$QuestionAttemptsTableAnnotationComposer,
    $$QuestionAttemptsTableCreateCompanionBuilder,
    $$QuestionAttemptsTableUpdateCompanionBuilder,
    (
      QuestionAttempt,
      BaseReferences<_$AppDatabase, $QuestionAttemptsTable, QuestionAttempt>
    ),
    QuestionAttempt,
    PrefetchHooks Function()> {
  $$QuestionAttemptsTableTableManager(
      _$AppDatabase db, $QuestionAttemptsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> levelId = const Value.absent(),
            Value<String> questionId = const Value.absent(),
            Value<bool> correct = const Value.absent(),
            Value<int> timeTaken = const Value.absent(),
            Value<DateTime> answeredAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              QuestionAttemptsCompanion(
            id: id,
            levelId: levelId,
            questionId: questionId,
            correct: correct,
            timeTaken: timeTaken,
            answeredAt: answeredAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String levelId,
            required String questionId,
            required bool correct,
            required int timeTaken,
            required DateTime answeredAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              QuestionAttemptsCompanion.insert(
            id: id,
            levelId: levelId,
            questionId: questionId,
            correct: correct,
            timeTaken: timeTaken,
            answeredAt: answeredAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$QuestionAttemptsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $QuestionAttemptsTable,
    QuestionAttempt,
    $$QuestionAttemptsTableFilterComposer,
    $$QuestionAttemptsTableOrderingComposer,
    $$QuestionAttemptsTableAnnotationComposer,
    $$QuestionAttemptsTableCreateCompanionBuilder,
    $$QuestionAttemptsTableUpdateCompanionBuilder,
    (
      QuestionAttempt,
      BaseReferences<_$AppDatabase, $QuestionAttemptsTable, QuestionAttempt>
    ),
    QuestionAttempt,
    PrefetchHooks Function()>;
typedef $$UserLevelProgressesTableCreateCompanionBuilder
    = UserLevelProgressesCompanion Function({
  required String id,
  required String levelId,
  required String topicId,
  required bool completed,
  required int earnedXP,
  required double bestScore,
  required int attempts,
  Value<DateTime?> completedAt,
  required DateTime lastPlayed,
  Value<int> rowid,
});
typedef $$UserLevelProgressesTableUpdateCompanionBuilder
    = UserLevelProgressesCompanion Function({
  Value<String> id,
  Value<String> levelId,
  Value<String> topicId,
  Value<bool> completed,
  Value<int> earnedXP,
  Value<double> bestScore,
  Value<int> attempts,
  Value<DateTime?> completedAt,
  Value<DateTime> lastPlayed,
  Value<int> rowid,
});

class $$UserLevelProgressesTableFilterComposer
    extends Composer<_$AppDatabase, $UserLevelProgressesTable> {
  $$UserLevelProgressesTableFilterComposer({
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

  ColumnFilters<String> get topicId => $composableBuilder(
      column: $table.topicId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get earnedXP => $composableBuilder(
      column: $table.earnedXP, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bestScore => $composableBuilder(
      column: $table.bestScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastPlayed => $composableBuilder(
      column: $table.lastPlayed, builder: (column) => ColumnFilters(column));
}

class $$UserLevelProgressesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserLevelProgressesTable> {
  $$UserLevelProgressesTableOrderingComposer({
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

  ColumnOrderings<String> get topicId => $composableBuilder(
      column: $table.topicId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get earnedXP => $composableBuilder(
      column: $table.earnedXP, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bestScore => $composableBuilder(
      column: $table.bestScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastPlayed => $composableBuilder(
      column: $table.lastPlayed, builder: (column) => ColumnOrderings(column));
}

class $$UserLevelProgressesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserLevelProgressesTable> {
  $$UserLevelProgressesTableAnnotationComposer({
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

  GeneratedColumn<String> get topicId =>
      $composableBuilder(column: $table.topicId, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<int> get earnedXP =>
      $composableBuilder(column: $table.earnedXP, builder: (column) => column);

  GeneratedColumn<double> get bestScore =>
      $composableBuilder(column: $table.bestScore, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastPlayed => $composableBuilder(
      column: $table.lastPlayed, builder: (column) => column);
}

class $$UserLevelProgressesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserLevelProgressesTable,
    UserLevelProgressesData,
    $$UserLevelProgressesTableFilterComposer,
    $$UserLevelProgressesTableOrderingComposer,
    $$UserLevelProgressesTableAnnotationComposer,
    $$UserLevelProgressesTableCreateCompanionBuilder,
    $$UserLevelProgressesTableUpdateCompanionBuilder,
    (
      UserLevelProgressesData,
      BaseReferences<_$AppDatabase, $UserLevelProgressesTable,
          UserLevelProgressesData>
    ),
    UserLevelProgressesData,
    PrefetchHooks Function()> {
  $$UserLevelProgressesTableTableManager(
      _$AppDatabase db, $UserLevelProgressesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserLevelProgressesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserLevelProgressesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserLevelProgressesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> levelId = const Value.absent(),
            Value<String> topicId = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<int> earnedXP = const Value.absent(),
            Value<double> bestScore = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<DateTime> lastPlayed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserLevelProgressesCompanion(
            id: id,
            levelId: levelId,
            topicId: topicId,
            completed: completed,
            earnedXP: earnedXP,
            bestScore: bestScore,
            attempts: attempts,
            completedAt: completedAt,
            lastPlayed: lastPlayed,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String levelId,
            required String topicId,
            required bool completed,
            required int earnedXP,
            required double bestScore,
            required int attempts,
            Value<DateTime?> completedAt = const Value.absent(),
            required DateTime lastPlayed,
            Value<int> rowid = const Value.absent(),
          }) =>
              UserLevelProgressesCompanion.insert(
            id: id,
            levelId: levelId,
            topicId: topicId,
            completed: completed,
            earnedXP: earnedXP,
            bestScore: bestScore,
            attempts: attempts,
            completedAt: completedAt,
            lastPlayed: lastPlayed,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserLevelProgressesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserLevelProgressesTable,
    UserLevelProgressesData,
    $$UserLevelProgressesTableFilterComposer,
    $$UserLevelProgressesTableOrderingComposer,
    $$UserLevelProgressesTableAnnotationComposer,
    $$UserLevelProgressesTableCreateCompanionBuilder,
    $$UserLevelProgressesTableUpdateCompanionBuilder,
    (
      UserLevelProgressesData,
      BaseReferences<_$AppDatabase, $UserLevelProgressesTable,
          UserLevelProgressesData>
    ),
    UserLevelProgressesData,
    PrefetchHooks Function()>;
typedef $$UserTopicProgressesTableCreateCompanionBuilder
    = UserTopicProgressesCompanion Function({
  required String id,
  required String topicId,
  required int earnedXP,
  required double mastery,
  required DateTime lastPlayed,
  required bool favorite,
  Value<int> rowid,
});
typedef $$UserTopicProgressesTableUpdateCompanionBuilder
    = UserTopicProgressesCompanion Function({
  Value<String> id,
  Value<String> topicId,
  Value<int> earnedXP,
  Value<double> mastery,
  Value<DateTime> lastPlayed,
  Value<bool> favorite,
  Value<int> rowid,
});

class $$UserTopicProgressesTableFilterComposer
    extends Composer<_$AppDatabase, $UserTopicProgressesTable> {
  $$UserTopicProgressesTableFilterComposer({
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

  ColumnFilters<int> get earnedXP => $composableBuilder(
      column: $table.earnedXP, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get mastery => $composableBuilder(
      column: $table.mastery, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastPlayed => $composableBuilder(
      column: $table.lastPlayed, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get favorite => $composableBuilder(
      column: $table.favorite, builder: (column) => ColumnFilters(column));
}

class $$UserTopicProgressesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserTopicProgressesTable> {
  $$UserTopicProgressesTableOrderingComposer({
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

  ColumnOrderings<int> get earnedXP => $composableBuilder(
      column: $table.earnedXP, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get mastery => $composableBuilder(
      column: $table.mastery, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastPlayed => $composableBuilder(
      column: $table.lastPlayed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get favorite => $composableBuilder(
      column: $table.favorite, builder: (column) => ColumnOrderings(column));
}

class $$UserTopicProgressesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserTopicProgressesTable> {
  $$UserTopicProgressesTableAnnotationComposer({
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

  GeneratedColumn<int> get earnedXP =>
      $composableBuilder(column: $table.earnedXP, builder: (column) => column);

  GeneratedColumn<double> get mastery =>
      $composableBuilder(column: $table.mastery, builder: (column) => column);

  GeneratedColumn<DateTime> get lastPlayed => $composableBuilder(
      column: $table.lastPlayed, builder: (column) => column);

  GeneratedColumn<bool> get favorite =>
      $composableBuilder(column: $table.favorite, builder: (column) => column);
}

class $$UserTopicProgressesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserTopicProgressesTable,
    UserTopicProgressesData,
    $$UserTopicProgressesTableFilterComposer,
    $$UserTopicProgressesTableOrderingComposer,
    $$UserTopicProgressesTableAnnotationComposer,
    $$UserTopicProgressesTableCreateCompanionBuilder,
    $$UserTopicProgressesTableUpdateCompanionBuilder,
    (
      UserTopicProgressesData,
      BaseReferences<_$AppDatabase, $UserTopicProgressesTable,
          UserTopicProgressesData>
    ),
    UserTopicProgressesData,
    PrefetchHooks Function()> {
  $$UserTopicProgressesTableTableManager(
      _$AppDatabase db, $UserTopicProgressesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserTopicProgressesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserTopicProgressesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserTopicProgressesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> topicId = const Value.absent(),
            Value<int> earnedXP = const Value.absent(),
            Value<double> mastery = const Value.absent(),
            Value<DateTime> lastPlayed = const Value.absent(),
            Value<bool> favorite = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserTopicProgressesCompanion(
            id: id,
            topicId: topicId,
            earnedXP: earnedXP,
            mastery: mastery,
            lastPlayed: lastPlayed,
            favorite: favorite,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String topicId,
            required int earnedXP,
            required double mastery,
            required DateTime lastPlayed,
            required bool favorite,
            Value<int> rowid = const Value.absent(),
          }) =>
              UserTopicProgressesCompanion.insert(
            id: id,
            topicId: topicId,
            earnedXP: earnedXP,
            mastery: mastery,
            lastPlayed: lastPlayed,
            favorite: favorite,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserTopicProgressesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserTopicProgressesTable,
    UserTopicProgressesData,
    $$UserTopicProgressesTableFilterComposer,
    $$UserTopicProgressesTableOrderingComposer,
    $$UserTopicProgressesTableAnnotationComposer,
    $$UserTopicProgressesTableCreateCompanionBuilder,
    $$UserTopicProgressesTableUpdateCompanionBuilder,
    (
      UserTopicProgressesData,
      BaseReferences<_$AppDatabase, $UserTopicProgressesTable,
          UserTopicProgressesData>
    ),
    UserTopicProgressesData,
    PrefetchHooks Function()>;
typedef $$StudySessionTableCreateCompanionBuilder = StudySessionCompanion
    Function({
  required String id,
  required String topicId,
  required StudyActivity activity,
  required DateTime startedAt,
  required DateTime endedAt,
  required int questionsAnswered,
  required int correctAnswers,
  required int earnedXP,
  Value<int> rowid,
});
typedef $$StudySessionTableUpdateCompanionBuilder = StudySessionCompanion
    Function({
  Value<String> id,
  Value<String> topicId,
  Value<StudyActivity> activity,
  Value<DateTime> startedAt,
  Value<DateTime> endedAt,
  Value<int> questionsAnswered,
  Value<int> correctAnswers,
  Value<int> earnedXP,
  Value<int> rowid,
});

class $$StudySessionTableFilterComposer
    extends Composer<_$AppDatabase, $StudySessionTable> {
  $$StudySessionTableFilterComposer({
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

  ColumnWithTypeConverterFilters<StudyActivity, StudyActivity, String>
      get activity => $composableBuilder(
          column: $table.activity,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
      column: $table.endedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get questionsAnswered => $composableBuilder(
      column: $table.questionsAnswered,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get correctAnswers => $composableBuilder(
      column: $table.correctAnswers,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get earnedXP => $composableBuilder(
      column: $table.earnedXP, builder: (column) => ColumnFilters(column));
}

class $$StudySessionTableOrderingComposer
    extends Composer<_$AppDatabase, $StudySessionTable> {
  $$StudySessionTableOrderingComposer({
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

  ColumnOrderings<String> get activity => $composableBuilder(
      column: $table.activity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
      column: $table.endedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get questionsAnswered => $composableBuilder(
      column: $table.questionsAnswered,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get correctAnswers => $composableBuilder(
      column: $table.correctAnswers,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get earnedXP => $composableBuilder(
      column: $table.earnedXP, builder: (column) => ColumnOrderings(column));
}

class $$StudySessionTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudySessionTable> {
  $$StudySessionTableAnnotationComposer({
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

  GeneratedColumnWithTypeConverter<StudyActivity, String> get activity =>
      $composableBuilder(column: $table.activity, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get questionsAnswered => $composableBuilder(
      column: $table.questionsAnswered, builder: (column) => column);

  GeneratedColumn<int> get correctAnswers => $composableBuilder(
      column: $table.correctAnswers, builder: (column) => column);

  GeneratedColumn<int> get earnedXP =>
      $composableBuilder(column: $table.earnedXP, builder: (column) => column);
}

class $$StudySessionTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StudySessionTable,
    StudySessionData,
    $$StudySessionTableFilterComposer,
    $$StudySessionTableOrderingComposer,
    $$StudySessionTableAnnotationComposer,
    $$StudySessionTableCreateCompanionBuilder,
    $$StudySessionTableUpdateCompanionBuilder,
    (
      StudySessionData,
      BaseReferences<_$AppDatabase, $StudySessionTable, StudySessionData>
    ),
    StudySessionData,
    PrefetchHooks Function()> {
  $$StudySessionTableTableManager(_$AppDatabase db, $StudySessionTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudySessionTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudySessionTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudySessionTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> topicId = const Value.absent(),
            Value<StudyActivity> activity = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime> endedAt = const Value.absent(),
            Value<int> questionsAnswered = const Value.absent(),
            Value<int> correctAnswers = const Value.absent(),
            Value<int> earnedXP = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StudySessionCompanion(
            id: id,
            topicId: topicId,
            activity: activity,
            startedAt: startedAt,
            endedAt: endedAt,
            questionsAnswered: questionsAnswered,
            correctAnswers: correctAnswers,
            earnedXP: earnedXP,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String topicId,
            required StudyActivity activity,
            required DateTime startedAt,
            required DateTime endedAt,
            required int questionsAnswered,
            required int correctAnswers,
            required int earnedXP,
            Value<int> rowid = const Value.absent(),
          }) =>
              StudySessionCompanion.insert(
            id: id,
            topicId: topicId,
            activity: activity,
            startedAt: startedAt,
            endedAt: endedAt,
            questionsAnswered: questionsAnswered,
            correctAnswers: correctAnswers,
            earnedXP: earnedXP,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StudySessionTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StudySessionTable,
    StudySessionData,
    $$StudySessionTableFilterComposer,
    $$StudySessionTableOrderingComposer,
    $$StudySessionTableAnnotationComposer,
    $$StudySessionTableCreateCompanionBuilder,
    $$StudySessionTableUpdateCompanionBuilder,
    (
      StudySessionData,
      BaseReferences<_$AppDatabase, $StudySessionTable, StudySessionData>
    ),
    StudySessionData,
    PrefetchHooks Function()>;
typedef $$DownloadedBundleTableCreateCompanionBuilder
    = DownloadedBundleCompanion Function({
  required String id,
  required int version,
  required DateTime downloadedAt,
  Value<int> rowid,
});
typedef $$DownloadedBundleTableUpdateCompanionBuilder
    = DownloadedBundleCompanion Function({
  Value<String> id,
  Value<int> version,
  Value<DateTime> downloadedAt,
  Value<int> rowid,
});

class $$DownloadedBundleTableFilterComposer
    extends Composer<_$AppDatabase, $DownloadedBundleTable> {
  $$DownloadedBundleTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get downloadedAt => $composableBuilder(
      column: $table.downloadedAt, builder: (column) => ColumnFilters(column));
}

class $$DownloadedBundleTableOrderingComposer
    extends Composer<_$AppDatabase, $DownloadedBundleTable> {
  $$DownloadedBundleTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get downloadedAt => $composableBuilder(
      column: $table.downloadedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$DownloadedBundleTableAnnotationComposer
    extends Composer<_$AppDatabase, $DownloadedBundleTable> {
  $$DownloadedBundleTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get downloadedAt => $composableBuilder(
      column: $table.downloadedAt, builder: (column) => column);
}

class $$DownloadedBundleTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DownloadedBundleTable,
    DownloadedBundleData,
    $$DownloadedBundleTableFilterComposer,
    $$DownloadedBundleTableOrderingComposer,
    $$DownloadedBundleTableAnnotationComposer,
    $$DownloadedBundleTableCreateCompanionBuilder,
    $$DownloadedBundleTableUpdateCompanionBuilder,
    (
      DownloadedBundleData,
      BaseReferences<_$AppDatabase, $DownloadedBundleTable,
          DownloadedBundleData>
    ),
    DownloadedBundleData,
    PrefetchHooks Function()> {
  $$DownloadedBundleTableTableManager(
      _$AppDatabase db, $DownloadedBundleTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadedBundleTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DownloadedBundleTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DownloadedBundleTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<DateTime> downloadedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DownloadedBundleCompanion(
            id: id,
            version: version,
            downloadedAt: downloadedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required int version,
            required DateTime downloadedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              DownloadedBundleCompanion.insert(
            id: id,
            version: version,
            downloadedAt: downloadedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DownloadedBundleTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DownloadedBundleTable,
    DownloadedBundleData,
    $$DownloadedBundleTableFilterComposer,
    $$DownloadedBundleTableOrderingComposer,
    $$DownloadedBundleTableAnnotationComposer,
    $$DownloadedBundleTableCreateCompanionBuilder,
    $$DownloadedBundleTableUpdateCompanionBuilder,
    (
      DownloadedBundleData,
      BaseReferences<_$AppDatabase, $DownloadedBundleTable,
          DownloadedBundleData>
    ),
    DownloadedBundleData,
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
  $$ExamPapersTableTableManager get examPapers =>
      $$ExamPapersTableTableManager(_db, _db.examPapers);
  $$QuestionAttemptsTableTableManager get questionAttempts =>
      $$QuestionAttemptsTableTableManager(_db, _db.questionAttempts);
  $$UserLevelProgressesTableTableManager get userLevelProgresses =>
      $$UserLevelProgressesTableTableManager(_db, _db.userLevelProgresses);
  $$UserTopicProgressesTableTableManager get userTopicProgresses =>
      $$UserTopicProgressesTableTableManager(_db, _db.userTopicProgresses);
  $$StudySessionTableTableManager get studySession =>
      $$StudySessionTableTableManager(_db, _db.studySession);
  $$DownloadedBundleTableTableManager get downloadedBundle =>
      $$DownloadedBundleTableTableManager(_db, _db.downloadedBundle);
}
