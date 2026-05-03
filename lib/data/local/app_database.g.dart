// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _externalIdMeta =
      const VerificationMeta('externalId');
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
      'external_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bodyPartMeta =
      const VerificationMeta('bodyPart');
  @override
  late final GeneratedColumn<String> bodyPart = GeneratedColumn<String>(
      'body_part', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetPrimaryMeta =
      const VerificationMeta('targetPrimary');
  @override
  late final GeneratedColumn<String> targetPrimary = GeneratedColumn<String>(
      'target_primary', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _equipmentMeta =
      const VerificationMeta('equipment');
  @override
  late final GeneratedColumn<String> equipment = GeneratedColumn<String>(
      'equipment', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gifUrlMeta = const VerificationMeta('gifUrl');
  @override
  late final GeneratedColumn<String> gifUrl = GeneratedColumn<String>(
      'gif_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _muscleGroupMeta =
      const VerificationMeta('muscleGroup');
  @override
  late final GeneratedColumn<String> muscleGroup = GeneratedColumn<String>(
      'muscle_group', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _defaultSetsMeta =
      const VerificationMeta('defaultSets');
  @override
  late final GeneratedColumn<int> defaultSets = GeneratedColumn<int>(
      'default_sets', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _defaultRepsMeta =
      const VerificationMeta('defaultReps');
  @override
  late final GeneratedColumn<int> defaultReps = GeneratedColumn<int>(
      'default_reps', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _defaultRestSecondsMeta =
      const VerificationMeta('defaultRestSeconds');
  @override
  late final GeneratedColumn<int> defaultRestSeconds = GeneratedColumn<int>(
      'default_rest_seconds', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _defaultTypeMeta =
      const VerificationMeta('defaultType');
  @override
  late final GeneratedColumn<String> defaultType = GeneratedColumn<String>(
      'default_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        externalId,
        source,
        name,
        bodyPart,
        targetPrimary,
        equipment,
        gifUrl,
        muscleGroup,
        defaultSets,
        defaultReps,
        defaultRestSeconds,
        defaultType
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(Insertable<Exercise> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('external_id')) {
      context.handle(
          _externalIdMeta,
          externalId.isAcceptableOrUnknown(
              data['external_id']!, _externalIdMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('body_part')) {
      context.handle(_bodyPartMeta,
          bodyPart.isAcceptableOrUnknown(data['body_part']!, _bodyPartMeta));
    } else if (isInserting) {
      context.missing(_bodyPartMeta);
    }
    if (data.containsKey('target_primary')) {
      context.handle(
          _targetPrimaryMeta,
          targetPrimary.isAcceptableOrUnknown(
              data['target_primary']!, _targetPrimaryMeta));
    } else if (isInserting) {
      context.missing(_targetPrimaryMeta);
    }
    if (data.containsKey('equipment')) {
      context.handle(_equipmentMeta,
          equipment.isAcceptableOrUnknown(data['equipment']!, _equipmentMeta));
    } else if (isInserting) {
      context.missing(_equipmentMeta);
    }
    if (data.containsKey('gif_url')) {
      context.handle(_gifUrlMeta,
          gifUrl.isAcceptableOrUnknown(data['gif_url']!, _gifUrlMeta));
    }
    if (data.containsKey('muscle_group')) {
      context.handle(
          _muscleGroupMeta,
          muscleGroup.isAcceptableOrUnknown(
              data['muscle_group']!, _muscleGroupMeta));
    }
    if (data.containsKey('default_sets')) {
      context.handle(
          _defaultSetsMeta,
          defaultSets.isAcceptableOrUnknown(
              data['default_sets']!, _defaultSetsMeta));
    }
    if (data.containsKey('default_reps')) {
      context.handle(
          _defaultRepsMeta,
          defaultReps.isAcceptableOrUnknown(
              data['default_reps']!, _defaultRepsMeta));
    }
    if (data.containsKey('default_rest_seconds')) {
      context.handle(
          _defaultRestSecondsMeta,
          defaultRestSeconds.isAcceptableOrUnknown(
              data['default_rest_seconds']!, _defaultRestSecondsMeta));
    }
    if (data.containsKey('default_type')) {
      context.handle(
          _defaultTypeMeta,
          defaultType.isAcceptableOrUnknown(
              data['default_type']!, _defaultTypeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      externalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}external_id']),
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      bodyPart: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body_part'])!,
      targetPrimary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_primary'])!,
      equipment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}equipment'])!,
      gifUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gif_url']),
      muscleGroup: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}muscle_group']),
      defaultSets: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}default_sets']),
      defaultReps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}default_reps']),
      defaultRestSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}default_rest_seconds']),
      defaultType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}default_type']),
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }
}

class Exercise extends DataClass implements Insertable<Exercise> {
  final String id;
  final String? externalId;
  final String source;
  final String name;
  final String bodyPart;
  final String targetPrimary;
  final String equipment;
  final String? gifUrl;
  final String? muscleGroup;
  final int? defaultSets;
  final int? defaultReps;
  final int? defaultRestSeconds;
  final String? defaultType;
  const Exercise(
      {required this.id,
      this.externalId,
      required this.source,
      required this.name,
      required this.bodyPart,
      required this.targetPrimary,
      required this.equipment,
      this.gifUrl,
      this.muscleGroup,
      this.defaultSets,
      this.defaultReps,
      this.defaultRestSeconds,
      this.defaultType});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || externalId != null) {
      map['external_id'] = Variable<String>(externalId);
    }
    map['source'] = Variable<String>(source);
    map['name'] = Variable<String>(name);
    map['body_part'] = Variable<String>(bodyPart);
    map['target_primary'] = Variable<String>(targetPrimary);
    map['equipment'] = Variable<String>(equipment);
    if (!nullToAbsent || gifUrl != null) {
      map['gif_url'] = Variable<String>(gifUrl);
    }
    if (!nullToAbsent || muscleGroup != null) {
      map['muscle_group'] = Variable<String>(muscleGroup);
    }
    if (!nullToAbsent || defaultSets != null) {
      map['default_sets'] = Variable<int>(defaultSets);
    }
    if (!nullToAbsent || defaultReps != null) {
      map['default_reps'] = Variable<int>(defaultReps);
    }
    if (!nullToAbsent || defaultRestSeconds != null) {
      map['default_rest_seconds'] = Variable<int>(defaultRestSeconds);
    }
    if (!nullToAbsent || defaultType != null) {
      map['default_type'] = Variable<String>(defaultType);
    }
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      externalId: externalId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalId),
      source: Value(source),
      name: Value(name),
      bodyPart: Value(bodyPart),
      targetPrimary: Value(targetPrimary),
      equipment: Value(equipment),
      gifUrl:
          gifUrl == null && nullToAbsent ? const Value.absent() : Value(gifUrl),
      muscleGroup: muscleGroup == null && nullToAbsent
          ? const Value.absent()
          : Value(muscleGroup),
      defaultSets: defaultSets == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultSets),
      defaultReps: defaultReps == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultReps),
      defaultRestSeconds: defaultRestSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultRestSeconds),
      defaultType: defaultType == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultType),
    );
  }

  factory Exercise.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<String>(json['id']),
      externalId: serializer.fromJson<String?>(json['externalId']),
      source: serializer.fromJson<String>(json['source']),
      name: serializer.fromJson<String>(json['name']),
      bodyPart: serializer.fromJson<String>(json['bodyPart']),
      targetPrimary: serializer.fromJson<String>(json['targetPrimary']),
      equipment: serializer.fromJson<String>(json['equipment']),
      gifUrl: serializer.fromJson<String?>(json['gifUrl']),
      muscleGroup: serializer.fromJson<String?>(json['muscleGroup']),
      defaultSets: serializer.fromJson<int?>(json['defaultSets']),
      defaultReps: serializer.fromJson<int?>(json['defaultReps']),
      defaultRestSeconds: serializer.fromJson<int?>(json['defaultRestSeconds']),
      defaultType: serializer.fromJson<String?>(json['defaultType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'externalId': serializer.toJson<String?>(externalId),
      'source': serializer.toJson<String>(source),
      'name': serializer.toJson<String>(name),
      'bodyPart': serializer.toJson<String>(bodyPart),
      'targetPrimary': serializer.toJson<String>(targetPrimary),
      'equipment': serializer.toJson<String>(equipment),
      'gifUrl': serializer.toJson<String?>(gifUrl),
      'muscleGroup': serializer.toJson<String?>(muscleGroup),
      'defaultSets': serializer.toJson<int?>(defaultSets),
      'defaultReps': serializer.toJson<int?>(defaultReps),
      'defaultRestSeconds': serializer.toJson<int?>(defaultRestSeconds),
      'defaultType': serializer.toJson<String?>(defaultType),
    };
  }

  Exercise copyWith(
          {String? id,
          Value<String?> externalId = const Value.absent(),
          String? source,
          String? name,
          String? bodyPart,
          String? targetPrimary,
          String? equipment,
          Value<String?> gifUrl = const Value.absent(),
          Value<String?> muscleGroup = const Value.absent(),
          Value<int?> defaultSets = const Value.absent(),
          Value<int?> defaultReps = const Value.absent(),
          Value<int?> defaultRestSeconds = const Value.absent(),
          Value<String?> defaultType = const Value.absent()}) =>
      Exercise(
        id: id ?? this.id,
        externalId: externalId.present ? externalId.value : this.externalId,
        source: source ?? this.source,
        name: name ?? this.name,
        bodyPart: bodyPart ?? this.bodyPart,
        targetPrimary: targetPrimary ?? this.targetPrimary,
        equipment: equipment ?? this.equipment,
        gifUrl: gifUrl.present ? gifUrl.value : this.gifUrl,
        muscleGroup: muscleGroup.present ? muscleGroup.value : this.muscleGroup,
        defaultSets: defaultSets.present ? defaultSets.value : this.defaultSets,
        defaultReps: defaultReps.present ? defaultReps.value : this.defaultReps,
        defaultRestSeconds: defaultRestSeconds.present
            ? defaultRestSeconds.value
            : this.defaultRestSeconds,
        defaultType: defaultType.present ? defaultType.value : this.defaultType,
      );
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      externalId:
          data.externalId.present ? data.externalId.value : this.externalId,
      source: data.source.present ? data.source.value : this.source,
      name: data.name.present ? data.name.value : this.name,
      bodyPart: data.bodyPart.present ? data.bodyPart.value : this.bodyPart,
      targetPrimary: data.targetPrimary.present
          ? data.targetPrimary.value
          : this.targetPrimary,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      gifUrl: data.gifUrl.present ? data.gifUrl.value : this.gifUrl,
      muscleGroup:
          data.muscleGroup.present ? data.muscleGroup.value : this.muscleGroup,
      defaultSets:
          data.defaultSets.present ? data.defaultSets.value : this.defaultSets,
      defaultReps:
          data.defaultReps.present ? data.defaultReps.value : this.defaultReps,
      defaultRestSeconds: data.defaultRestSeconds.present
          ? data.defaultRestSeconds.value
          : this.defaultRestSeconds,
      defaultType:
          data.defaultType.present ? data.defaultType.value : this.defaultType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('externalId: $externalId, ')
          ..write('source: $source, ')
          ..write('name: $name, ')
          ..write('bodyPart: $bodyPart, ')
          ..write('targetPrimary: $targetPrimary, ')
          ..write('equipment: $equipment, ')
          ..write('gifUrl: $gifUrl, ')
          ..write('muscleGroup: $muscleGroup, ')
          ..write('defaultSets: $defaultSets, ')
          ..write('defaultReps: $defaultReps, ')
          ..write('defaultRestSeconds: $defaultRestSeconds, ')
          ..write('defaultType: $defaultType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      externalId,
      source,
      name,
      bodyPart,
      targetPrimary,
      equipment,
      gifUrl,
      muscleGroup,
      defaultSets,
      defaultReps,
      defaultRestSeconds,
      defaultType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.externalId == this.externalId &&
          other.source == this.source &&
          other.name == this.name &&
          other.bodyPart == this.bodyPart &&
          other.targetPrimary == this.targetPrimary &&
          other.equipment == this.equipment &&
          other.gifUrl == this.gifUrl &&
          other.muscleGroup == this.muscleGroup &&
          other.defaultSets == this.defaultSets &&
          other.defaultReps == this.defaultReps &&
          other.defaultRestSeconds == this.defaultRestSeconds &&
          other.defaultType == this.defaultType);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<String> id;
  final Value<String?> externalId;
  final Value<String> source;
  final Value<String> name;
  final Value<String> bodyPart;
  final Value<String> targetPrimary;
  final Value<String> equipment;
  final Value<String?> gifUrl;
  final Value<String?> muscleGroup;
  final Value<int?> defaultSets;
  final Value<int?> defaultReps;
  final Value<int?> defaultRestSeconds;
  final Value<String?> defaultType;
  final Value<int> rowid;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.externalId = const Value.absent(),
    this.source = const Value.absent(),
    this.name = const Value.absent(),
    this.bodyPart = const Value.absent(),
    this.targetPrimary = const Value.absent(),
    this.equipment = const Value.absent(),
    this.gifUrl = const Value.absent(),
    this.muscleGroup = const Value.absent(),
    this.defaultSets = const Value.absent(),
    this.defaultReps = const Value.absent(),
    this.defaultRestSeconds = const Value.absent(),
    this.defaultType = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExercisesCompanion.insert({
    required String id,
    this.externalId = const Value.absent(),
    required String source,
    required String name,
    required String bodyPart,
    required String targetPrimary,
    required String equipment,
    this.gifUrl = const Value.absent(),
    this.muscleGroup = const Value.absent(),
    this.defaultSets = const Value.absent(),
    this.defaultReps = const Value.absent(),
    this.defaultRestSeconds = const Value.absent(),
    this.defaultType = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        source = Value(source),
        name = Value(name),
        bodyPart = Value(bodyPart),
        targetPrimary = Value(targetPrimary),
        equipment = Value(equipment);
  static Insertable<Exercise> custom({
    Expression<String>? id,
    Expression<String>? externalId,
    Expression<String>? source,
    Expression<String>? name,
    Expression<String>? bodyPart,
    Expression<String>? targetPrimary,
    Expression<String>? equipment,
    Expression<String>? gifUrl,
    Expression<String>? muscleGroup,
    Expression<int>? defaultSets,
    Expression<int>? defaultReps,
    Expression<int>? defaultRestSeconds,
    Expression<String>? defaultType,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (externalId != null) 'external_id': externalId,
      if (source != null) 'source': source,
      if (name != null) 'name': name,
      if (bodyPart != null) 'body_part': bodyPart,
      if (targetPrimary != null) 'target_primary': targetPrimary,
      if (equipment != null) 'equipment': equipment,
      if (gifUrl != null) 'gif_url': gifUrl,
      if (muscleGroup != null) 'muscle_group': muscleGroup,
      if (defaultSets != null) 'default_sets': defaultSets,
      if (defaultReps != null) 'default_reps': defaultReps,
      if (defaultRestSeconds != null)
        'default_rest_seconds': defaultRestSeconds,
      if (defaultType != null) 'default_type': defaultType,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExercisesCompanion copyWith(
      {Value<String>? id,
      Value<String?>? externalId,
      Value<String>? source,
      Value<String>? name,
      Value<String>? bodyPart,
      Value<String>? targetPrimary,
      Value<String>? equipment,
      Value<String?>? gifUrl,
      Value<String?>? muscleGroup,
      Value<int?>? defaultSets,
      Value<int?>? defaultReps,
      Value<int?>? defaultRestSeconds,
      Value<String?>? defaultType,
      Value<int>? rowid}) {
    return ExercisesCompanion(
      id: id ?? this.id,
      externalId: externalId ?? this.externalId,
      source: source ?? this.source,
      name: name ?? this.name,
      bodyPart: bodyPart ?? this.bodyPart,
      targetPrimary: targetPrimary ?? this.targetPrimary,
      equipment: equipment ?? this.equipment,
      gifUrl: gifUrl ?? this.gifUrl,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      defaultSets: defaultSets ?? this.defaultSets,
      defaultReps: defaultReps ?? this.defaultReps,
      defaultRestSeconds: defaultRestSeconds ?? this.defaultRestSeconds,
      defaultType: defaultType ?? this.defaultType,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (bodyPart.present) {
      map['body_part'] = Variable<String>(bodyPart.value);
    }
    if (targetPrimary.present) {
      map['target_primary'] = Variable<String>(targetPrimary.value);
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(equipment.value);
    }
    if (gifUrl.present) {
      map['gif_url'] = Variable<String>(gifUrl.value);
    }
    if (muscleGroup.present) {
      map['muscle_group'] = Variable<String>(muscleGroup.value);
    }
    if (defaultSets.present) {
      map['default_sets'] = Variable<int>(defaultSets.value);
    }
    if (defaultReps.present) {
      map['default_reps'] = Variable<int>(defaultReps.value);
    }
    if (defaultRestSeconds.present) {
      map['default_rest_seconds'] = Variable<int>(defaultRestSeconds.value);
    }
    if (defaultType.present) {
      map['default_type'] = Variable<String>(defaultType.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('externalId: $externalId, ')
          ..write('source: $source, ')
          ..write('name: $name, ')
          ..write('bodyPart: $bodyPart, ')
          ..write('targetPrimary: $targetPrimary, ')
          ..write('equipment: $equipment, ')
          ..write('gifUrl: $gifUrl, ')
          ..write('muscleGroup: $muscleGroup, ')
          ..write('defaultSets: $defaultSets, ')
          ..write('defaultReps: $defaultReps, ')
          ..write('defaultRestSeconds: $defaultRestSeconds, ')
          ..write('defaultType: $defaultType, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutsTable extends Workouts
    with TableInfo<$WorkoutsTable, WorkoutRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _globalRestSMeta =
      const VerificationMeta('globalRestS');
  @override
  late final GeneratedColumn<int> globalRestS = GeneratedColumn<int>(
      'global_rest_s', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _warmupSecondsMeta =
      const VerificationMeta('warmupSeconds');
  @override
  late final GeneratedColumn<int> warmupSeconds = GeneratedColumn<int>(
      'warmup_seconds', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _cooldownSMeta =
      const VerificationMeta('cooldownS');
  @override
  late final GeneratedColumn<int> cooldownS = GeneratedColumn<int>(
      'cooldown_s', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        tags,
        globalRestS,
        warmupSeconds,
        cooldownS,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workouts';
  @override
  VerificationContext validateIntegrity(Insertable<WorkoutRow> instance,
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
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('global_rest_s')) {
      context.handle(
          _globalRestSMeta,
          globalRestS.isAcceptableOrUnknown(
              data['global_rest_s']!, _globalRestSMeta));
    }
    if (data.containsKey('warmup_seconds')) {
      context.handle(
          _warmupSecondsMeta,
          warmupSeconds.isAcceptableOrUnknown(
              data['warmup_seconds']!, _warmupSecondsMeta));
    }
    if (data.containsKey('cooldown_s')) {
      context.handle(_cooldownSMeta,
          cooldownS.isAcceptableOrUnknown(data['cooldown_s']!, _cooldownSMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  WorkoutRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      globalRestS: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}global_rest_s']),
      warmupSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}warmup_seconds']),
      cooldownS: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cooldown_s']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $WorkoutsTable createAlias(String alias) {
    return $WorkoutsTable(attachedDatabase, alias);
  }
}

class WorkoutRow extends DataClass implements Insertable<WorkoutRow> {
  final String id;
  final String name;
  final String? description;
  final String tags;
  final int? globalRestS;
  final int? warmupSeconds;
  final int? cooldownS;
  final int createdAt;
  final int updatedAt;
  const WorkoutRow(
      {required this.id,
      required this.name,
      this.description,
      required this.tags,
      this.globalRestS,
      this.warmupSeconds,
      this.cooldownS,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['tags'] = Variable<String>(tags);
    if (!nullToAbsent || globalRestS != null) {
      map['global_rest_s'] = Variable<int>(globalRestS);
    }
    if (!nullToAbsent || warmupSeconds != null) {
      map['warmup_seconds'] = Variable<int>(warmupSeconds);
    }
    if (!nullToAbsent || cooldownS != null) {
      map['cooldown_s'] = Variable<int>(cooldownS);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  WorkoutsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      tags: Value(tags),
      globalRestS: globalRestS == null && nullToAbsent
          ? const Value.absent()
          : Value(globalRestS),
      warmupSeconds: warmupSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(warmupSeconds),
      cooldownS: cooldownS == null && nullToAbsent
          ? const Value.absent()
          : Value(cooldownS),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WorkoutRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      tags: serializer.fromJson<String>(json['tags']),
      globalRestS: serializer.fromJson<int?>(json['globalRestS']),
      warmupSeconds: serializer.fromJson<int?>(json['warmupSeconds']),
      cooldownS: serializer.fromJson<int?>(json['cooldownS']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'tags': serializer.toJson<String>(tags),
      'globalRestS': serializer.toJson<int?>(globalRestS),
      'warmupSeconds': serializer.toJson<int?>(warmupSeconds),
      'cooldownS': serializer.toJson<int?>(cooldownS),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  WorkoutRow copyWith(
          {String? id,
          String? name,
          Value<String?> description = const Value.absent(),
          String? tags,
          Value<int?> globalRestS = const Value.absent(),
          Value<int?> warmupSeconds = const Value.absent(),
          Value<int?> cooldownS = const Value.absent(),
          int? createdAt,
          int? updatedAt}) =>
      WorkoutRow(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        tags: tags ?? this.tags,
        globalRestS: globalRestS.present ? globalRestS.value : this.globalRestS,
        warmupSeconds:
            warmupSeconds.present ? warmupSeconds.value : this.warmupSeconds,
        cooldownS: cooldownS.present ? cooldownS.value : this.cooldownS,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  WorkoutRow copyWithCompanion(WorkoutsCompanion data) {
    return WorkoutRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      tags: data.tags.present ? data.tags.value : this.tags,
      globalRestS:
          data.globalRestS.present ? data.globalRestS.value : this.globalRestS,
      warmupSeconds: data.warmupSeconds.present
          ? data.warmupSeconds.value
          : this.warmupSeconds,
      cooldownS: data.cooldownS.present ? data.cooldownS.value : this.cooldownS,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('tags: $tags, ')
          ..write('globalRestS: $globalRestS, ')
          ..write('warmupSeconds: $warmupSeconds, ')
          ..write('cooldownS: $cooldownS, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, tags, globalRestS,
      warmupSeconds, cooldownS, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.tags == this.tags &&
          other.globalRestS == this.globalRestS &&
          other.warmupSeconds == this.warmupSeconds &&
          other.cooldownS == this.cooldownS &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WorkoutsCompanion extends UpdateCompanion<WorkoutRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> tags;
  final Value<int?> globalRestS;
  final Value<int?> warmupSeconds;
  final Value<int?> cooldownS;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const WorkoutsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.tags = const Value.absent(),
    this.globalRestS = const Value.absent(),
    this.warmupSeconds = const Value.absent(),
    this.cooldownS = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.tags = const Value.absent(),
    this.globalRestS = const Value.absent(),
    this.warmupSeconds = const Value.absent(),
    this.cooldownS = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<WorkoutRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? tags,
    Expression<int>? globalRestS,
    Expression<int>? warmupSeconds,
    Expression<int>? cooldownS,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (tags != null) 'tags': tags,
      if (globalRestS != null) 'global_rest_s': globalRestS,
      if (warmupSeconds != null) 'warmup_seconds': warmupSeconds,
      if (cooldownS != null) 'cooldown_s': cooldownS,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<String>? tags,
      Value<int?>? globalRestS,
      Value<int?>? warmupSeconds,
      Value<int?>? cooldownS,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return WorkoutsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      globalRestS: globalRestS ?? this.globalRestS,
      warmupSeconds: warmupSeconds ?? this.warmupSeconds,
      cooldownS: cooldownS ?? this.cooldownS,
      createdAt: createdAt ?? this.createdAt,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (globalRestS.present) {
      map['global_rest_s'] = Variable<int>(globalRestS.value);
    }
    if (warmupSeconds.present) {
      map['warmup_seconds'] = Variable<int>(warmupSeconds.value);
    }
    if (cooldownS.present) {
      map['cooldown_s'] = Variable<int>(cooldownS.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('tags: $tags, ')
          ..write('globalRestS: $globalRestS, ')
          ..write('warmupSeconds: $warmupSeconds, ')
          ..write('cooldownS: $cooldownS, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutStepsTable extends WorkoutSteps
    with TableInfo<$WorkoutStepsTable, WorkoutStepRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutStepsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _workoutIdMeta =
      const VerificationMeta('workoutId');
  @override
  late final GeneratedColumn<String> workoutId = GeneratedColumn<String>(
      'workout_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES workouts (id) ON DELETE CASCADE'));
  static const VerificationMeta _orderIndexMeta =
      const VerificationMeta('orderIndex');
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
      'order_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _exerciseIdMeta =
      const VerificationMeta('exerciseId');
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
      'exercise_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _stepModeMeta =
      const VerificationMeta('stepMode');
  @override
  late final GeneratedColumn<String> stepMode = GeneratedColumn<String>(
      'step_mode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _setsMeta = const VerificationMeta('sets');
  @override
  late final GeneratedColumn<int> sets = GeneratedColumn<int>(
      'sets', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
      'reps', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _workSecondsMeta =
      const VerificationMeta('workSeconds');
  @override
  late final GeneratedColumn<int> workSeconds = GeneratedColumn<int>(
      'work_seconds', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _restSecondsMeta =
      const VerificationMeta('restSeconds');
  @override
  late final GeneratedColumn<int> restSeconds = GeneratedColumn<int>(
      'rest_seconds', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _tempoMeta = const VerificationMeta('tempo');
  @override
  late final GeneratedColumn<String> tempo = GeneratedColumn<String>(
      'tempo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isConfiguredMeta =
      const VerificationMeta('isConfigured');
  @override
  late final GeneratedColumn<bool> isConfigured = GeneratedColumn<bool>(
      'is_configured', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_configured" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _circuitRoundsMeta =
      const VerificationMeta('circuitRounds');
  @override
  late final GeneratedColumn<int> circuitRounds = GeneratedColumn<int>(
      'circuit_rounds', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _parentStepIdMeta =
      const VerificationMeta('parentStepId');
  @override
  late final GeneratedColumn<String> parentStepId = GeneratedColumn<String>(
      'parent_step_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nestingDepthMeta =
      const VerificationMeta('nestingDepth');
  @override
  late final GeneratedColumn<int> nestingDepth = GeneratedColumn<int>(
      'nesting_depth', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        workoutId,
        orderIndex,
        type,
        exerciseId,
        stepMode,
        sets,
        reps,
        workSeconds,
        restSeconds,
        tempo,
        isConfigured,
        circuitRounds,
        parentStepId,
        nestingDepth
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_steps';
  @override
  VerificationContext validateIntegrity(Insertable<WorkoutStepRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workout_id')) {
      context.handle(_workoutIdMeta,
          workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta));
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
          _orderIndexMeta,
          orderIndex.isAcceptableOrUnknown(
              data['order_index']!, _orderIndexMeta));
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
          _exerciseIdMeta,
          exerciseId.isAcceptableOrUnknown(
              data['exercise_id']!, _exerciseIdMeta));
    }
    if (data.containsKey('step_mode')) {
      context.handle(_stepModeMeta,
          stepMode.isAcceptableOrUnknown(data['step_mode']!, _stepModeMeta));
    }
    if (data.containsKey('sets')) {
      context.handle(
          _setsMeta, sets.isAcceptableOrUnknown(data['sets']!, _setsMeta));
    }
    if (data.containsKey('reps')) {
      context.handle(
          _repsMeta, reps.isAcceptableOrUnknown(data['reps']!, _repsMeta));
    }
    if (data.containsKey('work_seconds')) {
      context.handle(
          _workSecondsMeta,
          workSeconds.isAcceptableOrUnknown(
              data['work_seconds']!, _workSecondsMeta));
    }
    if (data.containsKey('rest_seconds')) {
      context.handle(
          _restSecondsMeta,
          restSeconds.isAcceptableOrUnknown(
              data['rest_seconds']!, _restSecondsMeta));
    }
    if (data.containsKey('tempo')) {
      context.handle(
          _tempoMeta, tempo.isAcceptableOrUnknown(data['tempo']!, _tempoMeta));
    }
    if (data.containsKey('is_configured')) {
      context.handle(
          _isConfiguredMeta,
          isConfigured.isAcceptableOrUnknown(
              data['is_configured']!, _isConfiguredMeta));
    }
    if (data.containsKey('circuit_rounds')) {
      context.handle(
          _circuitRoundsMeta,
          circuitRounds.isAcceptableOrUnknown(
              data['circuit_rounds']!, _circuitRoundsMeta));
    }
    if (data.containsKey('parent_step_id')) {
      context.handle(
          _parentStepIdMeta,
          parentStepId.isAcceptableOrUnknown(
              data['parent_step_id']!, _parentStepIdMeta));
    }
    if (data.containsKey('nesting_depth')) {
      context.handle(
          _nestingDepthMeta,
          nestingDepth.isAcceptableOrUnknown(
              data['nesting_depth']!, _nestingDepthMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutStepRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutStepRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      workoutId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}workout_id'])!,
      orderIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_index'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      exerciseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exercise_id']),
      stepMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}step_mode']),
      sets: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sets']),
      reps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reps']),
      workSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}work_seconds']),
      restSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rest_seconds']),
      tempo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tempo']),
      isConfigured: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_configured'])!,
      circuitRounds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}circuit_rounds']),
      parentStepId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_step_id']),
      nestingDepth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}nesting_depth'])!,
    );
  }

  @override
  $WorkoutStepsTable createAlias(String alias) {
    return $WorkoutStepsTable(attachedDatabase, alias);
  }
}

class WorkoutStepRow extends DataClass implements Insertable<WorkoutStepRow> {
  final String id;
  final String workoutId;
  final int orderIndex;
  final String type;
  final String? exerciseId;
  final String? stepMode;
  final int? sets;
  final int? reps;
  final int? workSeconds;
  final int? restSeconds;
  final String? tempo;
  final bool isConfigured;
  final int? circuitRounds;
  final String? parentStepId;
  final int nestingDepth;
  const WorkoutStepRow(
      {required this.id,
      required this.workoutId,
      required this.orderIndex,
      required this.type,
      this.exerciseId,
      this.stepMode,
      this.sets,
      this.reps,
      this.workSeconds,
      this.restSeconds,
      this.tempo,
      required this.isConfigured,
      this.circuitRounds,
      this.parentStepId,
      required this.nestingDepth});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workout_id'] = Variable<String>(workoutId);
    map['order_index'] = Variable<int>(orderIndex);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || exerciseId != null) {
      map['exercise_id'] = Variable<String>(exerciseId);
    }
    if (!nullToAbsent || stepMode != null) {
      map['step_mode'] = Variable<String>(stepMode);
    }
    if (!nullToAbsent || sets != null) {
      map['sets'] = Variable<int>(sets);
    }
    if (!nullToAbsent || reps != null) {
      map['reps'] = Variable<int>(reps);
    }
    if (!nullToAbsent || workSeconds != null) {
      map['work_seconds'] = Variable<int>(workSeconds);
    }
    if (!nullToAbsent || restSeconds != null) {
      map['rest_seconds'] = Variable<int>(restSeconds);
    }
    if (!nullToAbsent || tempo != null) {
      map['tempo'] = Variable<String>(tempo);
    }
    map['is_configured'] = Variable<bool>(isConfigured);
    if (!nullToAbsent || circuitRounds != null) {
      map['circuit_rounds'] = Variable<int>(circuitRounds);
    }
    if (!nullToAbsent || parentStepId != null) {
      map['parent_step_id'] = Variable<String>(parentStepId);
    }
    map['nesting_depth'] = Variable<int>(nestingDepth);
    return map;
  }

  WorkoutStepsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutStepsCompanion(
      id: Value(id),
      workoutId: Value(workoutId),
      orderIndex: Value(orderIndex),
      type: Value(type),
      exerciseId: exerciseId == null && nullToAbsent
          ? const Value.absent()
          : Value(exerciseId),
      stepMode: stepMode == null && nullToAbsent
          ? const Value.absent()
          : Value(stepMode),
      sets: sets == null && nullToAbsent ? const Value.absent() : Value(sets),
      reps: reps == null && nullToAbsent ? const Value.absent() : Value(reps),
      workSeconds: workSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(workSeconds),
      restSeconds: restSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(restSeconds),
      tempo:
          tempo == null && nullToAbsent ? const Value.absent() : Value(tempo),
      isConfigured: Value(isConfigured),
      circuitRounds: circuitRounds == null && nullToAbsent
          ? const Value.absent()
          : Value(circuitRounds),
      parentStepId: parentStepId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentStepId),
      nestingDepth: Value(nestingDepth),
    );
  }

  factory WorkoutStepRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutStepRow(
      id: serializer.fromJson<String>(json['id']),
      workoutId: serializer.fromJson<String>(json['workoutId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      type: serializer.fromJson<String>(json['type']),
      exerciseId: serializer.fromJson<String?>(json['exerciseId']),
      stepMode: serializer.fromJson<String?>(json['stepMode']),
      sets: serializer.fromJson<int?>(json['sets']),
      reps: serializer.fromJson<int?>(json['reps']),
      workSeconds: serializer.fromJson<int?>(json['workSeconds']),
      restSeconds: serializer.fromJson<int?>(json['restSeconds']),
      tempo: serializer.fromJson<String?>(json['tempo']),
      isConfigured: serializer.fromJson<bool>(json['isConfigured']),
      circuitRounds: serializer.fromJson<int?>(json['circuitRounds']),
      parentStepId: serializer.fromJson<String?>(json['parentStepId']),
      nestingDepth: serializer.fromJson<int>(json['nestingDepth']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workoutId': serializer.toJson<String>(workoutId),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'type': serializer.toJson<String>(type),
      'exerciseId': serializer.toJson<String?>(exerciseId),
      'stepMode': serializer.toJson<String?>(stepMode),
      'sets': serializer.toJson<int?>(sets),
      'reps': serializer.toJson<int?>(reps),
      'workSeconds': serializer.toJson<int?>(workSeconds),
      'restSeconds': serializer.toJson<int?>(restSeconds),
      'tempo': serializer.toJson<String?>(tempo),
      'isConfigured': serializer.toJson<bool>(isConfigured),
      'circuitRounds': serializer.toJson<int?>(circuitRounds),
      'parentStepId': serializer.toJson<String?>(parentStepId),
      'nestingDepth': serializer.toJson<int>(nestingDepth),
    };
  }

  WorkoutStepRow copyWith(
          {String? id,
          String? workoutId,
          int? orderIndex,
          String? type,
          Value<String?> exerciseId = const Value.absent(),
          Value<String?> stepMode = const Value.absent(),
          Value<int?> sets = const Value.absent(),
          Value<int?> reps = const Value.absent(),
          Value<int?> workSeconds = const Value.absent(),
          Value<int?> restSeconds = const Value.absent(),
          Value<String?> tempo = const Value.absent(),
          bool? isConfigured,
          Value<int?> circuitRounds = const Value.absent(),
          Value<String?> parentStepId = const Value.absent(),
          int? nestingDepth}) =>
      WorkoutStepRow(
        id: id ?? this.id,
        workoutId: workoutId ?? this.workoutId,
        orderIndex: orderIndex ?? this.orderIndex,
        type: type ?? this.type,
        exerciseId: exerciseId.present ? exerciseId.value : this.exerciseId,
        stepMode: stepMode.present ? stepMode.value : this.stepMode,
        sets: sets.present ? sets.value : this.sets,
        reps: reps.present ? reps.value : this.reps,
        workSeconds: workSeconds.present ? workSeconds.value : this.workSeconds,
        restSeconds: restSeconds.present ? restSeconds.value : this.restSeconds,
        tempo: tempo.present ? tempo.value : this.tempo,
        isConfigured: isConfigured ?? this.isConfigured,
        circuitRounds:
            circuitRounds.present ? circuitRounds.value : this.circuitRounds,
        parentStepId:
            parentStepId.present ? parentStepId.value : this.parentStepId,
        nestingDepth: nestingDepth ?? this.nestingDepth,
      );
  WorkoutStepRow copyWithCompanion(WorkoutStepsCompanion data) {
    return WorkoutStepRow(
      id: data.id.present ? data.id.value : this.id,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
      orderIndex:
          data.orderIndex.present ? data.orderIndex.value : this.orderIndex,
      type: data.type.present ? data.type.value : this.type,
      exerciseId:
          data.exerciseId.present ? data.exerciseId.value : this.exerciseId,
      stepMode: data.stepMode.present ? data.stepMode.value : this.stepMode,
      sets: data.sets.present ? data.sets.value : this.sets,
      reps: data.reps.present ? data.reps.value : this.reps,
      workSeconds:
          data.workSeconds.present ? data.workSeconds.value : this.workSeconds,
      restSeconds:
          data.restSeconds.present ? data.restSeconds.value : this.restSeconds,
      tempo: data.tempo.present ? data.tempo.value : this.tempo,
      isConfigured: data.isConfigured.present
          ? data.isConfigured.value
          : this.isConfigured,
      circuitRounds: data.circuitRounds.present
          ? data.circuitRounds.value
          : this.circuitRounds,
      parentStepId: data.parentStepId.present
          ? data.parentStepId.value
          : this.parentStepId,
      nestingDepth: data.nestingDepth.present
          ? data.nestingDepth.value
          : this.nestingDepth,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutStepRow(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('type: $type, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('stepMode: $stepMode, ')
          ..write('sets: $sets, ')
          ..write('reps: $reps, ')
          ..write('workSeconds: $workSeconds, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('tempo: $tempo, ')
          ..write('isConfigured: $isConfigured, ')
          ..write('circuitRounds: $circuitRounds, ')
          ..write('parentStepId: $parentStepId, ')
          ..write('nestingDepth: $nestingDepth')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      workoutId,
      orderIndex,
      type,
      exerciseId,
      stepMode,
      sets,
      reps,
      workSeconds,
      restSeconds,
      tempo,
      isConfigured,
      circuitRounds,
      parentStepId,
      nestingDepth);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutStepRow &&
          other.id == this.id &&
          other.workoutId == this.workoutId &&
          other.orderIndex == this.orderIndex &&
          other.type == this.type &&
          other.exerciseId == this.exerciseId &&
          other.stepMode == this.stepMode &&
          other.sets == this.sets &&
          other.reps == this.reps &&
          other.workSeconds == this.workSeconds &&
          other.restSeconds == this.restSeconds &&
          other.tempo == this.tempo &&
          other.isConfigured == this.isConfigured &&
          other.circuitRounds == this.circuitRounds &&
          other.parentStepId == this.parentStepId &&
          other.nestingDepth == this.nestingDepth);
}

class WorkoutStepsCompanion extends UpdateCompanion<WorkoutStepRow> {
  final Value<String> id;
  final Value<String> workoutId;
  final Value<int> orderIndex;
  final Value<String> type;
  final Value<String?> exerciseId;
  final Value<String?> stepMode;
  final Value<int?> sets;
  final Value<int?> reps;
  final Value<int?> workSeconds;
  final Value<int?> restSeconds;
  final Value<String?> tempo;
  final Value<bool> isConfigured;
  final Value<int?> circuitRounds;
  final Value<String?> parentStepId;
  final Value<int> nestingDepth;
  final Value<int> rowid;
  const WorkoutStepsCompanion({
    this.id = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.type = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.stepMode = const Value.absent(),
    this.sets = const Value.absent(),
    this.reps = const Value.absent(),
    this.workSeconds = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.tempo = const Value.absent(),
    this.isConfigured = const Value.absent(),
    this.circuitRounds = const Value.absent(),
    this.parentStepId = const Value.absent(),
    this.nestingDepth = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutStepsCompanion.insert({
    required String id,
    required String workoutId,
    required int orderIndex,
    required String type,
    this.exerciseId = const Value.absent(),
    this.stepMode = const Value.absent(),
    this.sets = const Value.absent(),
    this.reps = const Value.absent(),
    this.workSeconds = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.tempo = const Value.absent(),
    this.isConfigured = const Value.absent(),
    this.circuitRounds = const Value.absent(),
    this.parentStepId = const Value.absent(),
    this.nestingDepth = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        workoutId = Value(workoutId),
        orderIndex = Value(orderIndex),
        type = Value(type);
  static Insertable<WorkoutStepRow> custom({
    Expression<String>? id,
    Expression<String>? workoutId,
    Expression<int>? orderIndex,
    Expression<String>? type,
    Expression<String>? exerciseId,
    Expression<String>? stepMode,
    Expression<int>? sets,
    Expression<int>? reps,
    Expression<int>? workSeconds,
    Expression<int>? restSeconds,
    Expression<String>? tempo,
    Expression<bool>? isConfigured,
    Expression<int>? circuitRounds,
    Expression<String>? parentStepId,
    Expression<int>? nestingDepth,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutId != null) 'workout_id': workoutId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (type != null) 'type': type,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (stepMode != null) 'step_mode': stepMode,
      if (sets != null) 'sets': sets,
      if (reps != null) 'reps': reps,
      if (workSeconds != null) 'work_seconds': workSeconds,
      if (restSeconds != null) 'rest_seconds': restSeconds,
      if (tempo != null) 'tempo': tempo,
      if (isConfigured != null) 'is_configured': isConfigured,
      if (circuitRounds != null) 'circuit_rounds': circuitRounds,
      if (parentStepId != null) 'parent_step_id': parentStepId,
      if (nestingDepth != null) 'nesting_depth': nestingDepth,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutStepsCompanion copyWith(
      {Value<String>? id,
      Value<String>? workoutId,
      Value<int>? orderIndex,
      Value<String>? type,
      Value<String?>? exerciseId,
      Value<String?>? stepMode,
      Value<int?>? sets,
      Value<int?>? reps,
      Value<int?>? workSeconds,
      Value<int?>? restSeconds,
      Value<String?>? tempo,
      Value<bool>? isConfigured,
      Value<int?>? circuitRounds,
      Value<String?>? parentStepId,
      Value<int>? nestingDepth,
      Value<int>? rowid}) {
    return WorkoutStepsCompanion(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      orderIndex: orderIndex ?? this.orderIndex,
      type: type ?? this.type,
      exerciseId: exerciseId ?? this.exerciseId,
      stepMode: stepMode ?? this.stepMode,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      workSeconds: workSeconds ?? this.workSeconds,
      restSeconds: restSeconds ?? this.restSeconds,
      tempo: tempo ?? this.tempo,
      isConfigured: isConfigured ?? this.isConfigured,
      circuitRounds: circuitRounds ?? this.circuitRounds,
      parentStepId: parentStepId ?? this.parentStepId,
      nestingDepth: nestingDepth ?? this.nestingDepth,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<String>(workoutId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (stepMode.present) {
      map['step_mode'] = Variable<String>(stepMode.value);
    }
    if (sets.present) {
      map['sets'] = Variable<int>(sets.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (workSeconds.present) {
      map['work_seconds'] = Variable<int>(workSeconds.value);
    }
    if (restSeconds.present) {
      map['rest_seconds'] = Variable<int>(restSeconds.value);
    }
    if (tempo.present) {
      map['tempo'] = Variable<String>(tempo.value);
    }
    if (isConfigured.present) {
      map['is_configured'] = Variable<bool>(isConfigured.value);
    }
    if (circuitRounds.present) {
      map['circuit_rounds'] = Variable<int>(circuitRounds.value);
    }
    if (parentStepId.present) {
      map['parent_step_id'] = Variable<String>(parentStepId.value);
    }
    if (nestingDepth.present) {
      map['nesting_depth'] = Variable<int>(nestingDepth.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutStepsCompanion(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('type: $type, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('stepMode: $stepMode, ')
          ..write('sets: $sets, ')
          ..write('reps: $reps, ')
          ..write('workSeconds: $workSeconds, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('tempo: $tempo, ')
          ..write('isConfigured: $isConfigured, ')
          ..write('circuitRounds: $circuitRounds, ')
          ..write('parentStepId: $parentStepId, ')
          ..write('nestingDepth: $nestingDepth, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $WorkoutsTable workouts = $WorkoutsTable(this);
  late final $WorkoutStepsTable workoutSteps = $WorkoutStepsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [exercises, workouts, workoutSteps];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('workouts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('workout_steps', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$ExercisesTableCreateCompanionBuilder = ExercisesCompanion Function({
  required String id,
  Value<String?> externalId,
  required String source,
  required String name,
  required String bodyPart,
  required String targetPrimary,
  required String equipment,
  Value<String?> gifUrl,
  Value<String?> muscleGroup,
  Value<int?> defaultSets,
  Value<int?> defaultReps,
  Value<int?> defaultRestSeconds,
  Value<String?> defaultType,
  Value<int> rowid,
});
typedef $$ExercisesTableUpdateCompanionBuilder = ExercisesCompanion Function({
  Value<String> id,
  Value<String?> externalId,
  Value<String> source,
  Value<String> name,
  Value<String> bodyPart,
  Value<String> targetPrimary,
  Value<String> equipment,
  Value<String?> gifUrl,
  Value<String?> muscleGroup,
  Value<int?> defaultSets,
  Value<int?> defaultReps,
  Value<int?> defaultRestSeconds,
  Value<String?> defaultType,
  Value<int> rowid,
});

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get externalId => $composableBuilder(
      column: $table.externalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bodyPart => $composableBuilder(
      column: $table.bodyPart, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetPrimary => $composableBuilder(
      column: $table.targetPrimary, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get equipment => $composableBuilder(
      column: $table.equipment, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gifUrl => $composableBuilder(
      column: $table.gifUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get muscleGroup => $composableBuilder(
      column: $table.muscleGroup, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get defaultSets => $composableBuilder(
      column: $table.defaultSets, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get defaultReps => $composableBuilder(
      column: $table.defaultReps, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get defaultRestSeconds => $composableBuilder(
      column: $table.defaultRestSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get defaultType => $composableBuilder(
      column: $table.defaultType, builder: (column) => ColumnFilters(column));
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get externalId => $composableBuilder(
      column: $table.externalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bodyPart => $composableBuilder(
      column: $table.bodyPart, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetPrimary => $composableBuilder(
      column: $table.targetPrimary,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get equipment => $composableBuilder(
      column: $table.equipment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gifUrl => $composableBuilder(
      column: $table.gifUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get muscleGroup => $composableBuilder(
      column: $table.muscleGroup, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get defaultSets => $composableBuilder(
      column: $table.defaultSets, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get defaultReps => $composableBuilder(
      column: $table.defaultReps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get defaultRestSeconds => $composableBuilder(
      column: $table.defaultRestSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get defaultType => $composableBuilder(
      column: $table.defaultType, builder: (column) => ColumnOrderings(column));
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get externalId => $composableBuilder(
      column: $table.externalId, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get bodyPart =>
      $composableBuilder(column: $table.bodyPart, builder: (column) => column);

  GeneratedColumn<String> get targetPrimary => $composableBuilder(
      column: $table.targetPrimary, builder: (column) => column);

  GeneratedColumn<String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  GeneratedColumn<String> get gifUrl =>
      $composableBuilder(column: $table.gifUrl, builder: (column) => column);

  GeneratedColumn<String> get muscleGroup => $composableBuilder(
      column: $table.muscleGroup, builder: (column) => column);

  GeneratedColumn<int> get defaultSets => $composableBuilder(
      column: $table.defaultSets, builder: (column) => column);

  GeneratedColumn<int> get defaultReps => $composableBuilder(
      column: $table.defaultReps, builder: (column) => column);

  GeneratedColumn<int> get defaultRestSeconds => $composableBuilder(
      column: $table.defaultRestSeconds, builder: (column) => column);

  GeneratedColumn<String> get defaultType => $composableBuilder(
      column: $table.defaultType, builder: (column) => column);
}

class $$ExercisesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExercisesTable,
    Exercise,
    $$ExercisesTableFilterComposer,
    $$ExercisesTableOrderingComposer,
    $$ExercisesTableAnnotationComposer,
    $$ExercisesTableCreateCompanionBuilder,
    $$ExercisesTableUpdateCompanionBuilder,
    (Exercise, BaseReferences<_$AppDatabase, $ExercisesTable, Exercise>),
    Exercise,
    PrefetchHooks Function()> {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> externalId = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> bodyPart = const Value.absent(),
            Value<String> targetPrimary = const Value.absent(),
            Value<String> equipment = const Value.absent(),
            Value<String?> gifUrl = const Value.absent(),
            Value<String?> muscleGroup = const Value.absent(),
            Value<int?> defaultSets = const Value.absent(),
            Value<int?> defaultReps = const Value.absent(),
            Value<int?> defaultRestSeconds = const Value.absent(),
            Value<String?> defaultType = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExercisesCompanion(
            id: id,
            externalId: externalId,
            source: source,
            name: name,
            bodyPart: bodyPart,
            targetPrimary: targetPrimary,
            equipment: equipment,
            gifUrl: gifUrl,
            muscleGroup: muscleGroup,
            defaultSets: defaultSets,
            defaultReps: defaultReps,
            defaultRestSeconds: defaultRestSeconds,
            defaultType: defaultType,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> externalId = const Value.absent(),
            required String source,
            required String name,
            required String bodyPart,
            required String targetPrimary,
            required String equipment,
            Value<String?> gifUrl = const Value.absent(),
            Value<String?> muscleGroup = const Value.absent(),
            Value<int?> defaultSets = const Value.absent(),
            Value<int?> defaultReps = const Value.absent(),
            Value<int?> defaultRestSeconds = const Value.absent(),
            Value<String?> defaultType = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExercisesCompanion.insert(
            id: id,
            externalId: externalId,
            source: source,
            name: name,
            bodyPart: bodyPart,
            targetPrimary: targetPrimary,
            equipment: equipment,
            gifUrl: gifUrl,
            muscleGroup: muscleGroup,
            defaultSets: defaultSets,
            defaultReps: defaultReps,
            defaultRestSeconds: defaultRestSeconds,
            defaultType: defaultType,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExercisesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExercisesTable,
    Exercise,
    $$ExercisesTableFilterComposer,
    $$ExercisesTableOrderingComposer,
    $$ExercisesTableAnnotationComposer,
    $$ExercisesTableCreateCompanionBuilder,
    $$ExercisesTableUpdateCompanionBuilder,
    (Exercise, BaseReferences<_$AppDatabase, $ExercisesTable, Exercise>),
    Exercise,
    PrefetchHooks Function()>;
typedef $$WorkoutsTableCreateCompanionBuilder = WorkoutsCompanion Function({
  required String id,
  required String name,
  Value<String?> description,
  Value<String> tags,
  Value<int?> globalRestS,
  Value<int?> warmupSeconds,
  Value<int?> cooldownS,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$WorkoutsTableUpdateCompanionBuilder = WorkoutsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> description,
  Value<String> tags,
  Value<int?> globalRestS,
  Value<int?> warmupSeconds,
  Value<int?> cooldownS,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

final class $$WorkoutsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutsTable, WorkoutRow> {
  $$WorkoutsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WorkoutStepsTable, List<WorkoutStepRow>>
      _workoutStepsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.workoutSteps,
          aliasName:
              $_aliasNameGenerator(db.workouts.id, db.workoutSteps.workoutId));

  $$WorkoutStepsTableProcessedTableManager get workoutStepsRefs {
    final manager = $$WorkoutStepsTableTableManager($_db, $_db.workoutSteps)
        .filter((f) => f.workoutId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutStepsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$WorkoutsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableFilterComposer({
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

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get globalRestS => $composableBuilder(
      column: $table.globalRestS, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get warmupSeconds => $composableBuilder(
      column: $table.warmupSeconds, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cooldownS => $composableBuilder(
      column: $table.cooldownS, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> workoutStepsRefs(
      Expression<bool> Function($$WorkoutStepsTableFilterComposer f) f) {
    final $$WorkoutStepsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.workoutSteps,
        getReferencedColumn: (t) => t.workoutId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutStepsTableFilterComposer(
              $db: $db,
              $table: $db.workoutSteps,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WorkoutsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableOrderingComposer({
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

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get globalRestS => $composableBuilder(
      column: $table.globalRestS, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get warmupSeconds => $composableBuilder(
      column: $table.warmupSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cooldownS => $composableBuilder(
      column: $table.cooldownS, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$WorkoutsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableAnnotationComposer({
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

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<int> get globalRestS => $composableBuilder(
      column: $table.globalRestS, builder: (column) => column);

  GeneratedColumn<int> get warmupSeconds => $composableBuilder(
      column: $table.warmupSeconds, builder: (column) => column);

  GeneratedColumn<int> get cooldownS =>
      $composableBuilder(column: $table.cooldownS, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> workoutStepsRefs<T extends Object>(
      Expression<T> Function($$WorkoutStepsTableAnnotationComposer a) f) {
    final $$WorkoutStepsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.workoutSteps,
        getReferencedColumn: (t) => t.workoutId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutStepsTableAnnotationComposer(
              $db: $db,
              $table: $db.workoutSteps,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WorkoutsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkoutsTable,
    WorkoutRow,
    $$WorkoutsTableFilterComposer,
    $$WorkoutsTableOrderingComposer,
    $$WorkoutsTableAnnotationComposer,
    $$WorkoutsTableCreateCompanionBuilder,
    $$WorkoutsTableUpdateCompanionBuilder,
    (WorkoutRow, $$WorkoutsTableReferences),
    WorkoutRow,
    PrefetchHooks Function({bool workoutStepsRefs})> {
  $$WorkoutsTableTableManager(_$AppDatabase db, $WorkoutsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<int?> globalRestS = const Value.absent(),
            Value<int?> warmupSeconds = const Value.absent(),
            Value<int?> cooldownS = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutsCompanion(
            id: id,
            name: name,
            description: description,
            tags: tags,
            globalRestS: globalRestS,
            warmupSeconds: warmupSeconds,
            cooldownS: cooldownS,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> description = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<int?> globalRestS = const Value.absent(),
            Value<int?> warmupSeconds = const Value.absent(),
            Value<int?> cooldownS = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutsCompanion.insert(
            id: id,
            name: name,
            description: description,
            tags: tags,
            globalRestS: globalRestS,
            warmupSeconds: warmupSeconds,
            cooldownS: cooldownS,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$WorkoutsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({workoutStepsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (workoutStepsRefs) db.workoutSteps],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutStepsRefs)
                    await $_getPrefetchedData<WorkoutRow, $WorkoutsTable,
                            WorkoutStepRow>(
                        currentTable: table,
                        referencedTable: $$WorkoutsTableReferences
                            ._workoutStepsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WorkoutsTableReferences(db, table, p0)
                                .workoutStepsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.workoutId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$WorkoutsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkoutsTable,
    WorkoutRow,
    $$WorkoutsTableFilterComposer,
    $$WorkoutsTableOrderingComposer,
    $$WorkoutsTableAnnotationComposer,
    $$WorkoutsTableCreateCompanionBuilder,
    $$WorkoutsTableUpdateCompanionBuilder,
    (WorkoutRow, $$WorkoutsTableReferences),
    WorkoutRow,
    PrefetchHooks Function({bool workoutStepsRefs})>;
typedef $$WorkoutStepsTableCreateCompanionBuilder = WorkoutStepsCompanion
    Function({
  required String id,
  required String workoutId,
  required int orderIndex,
  required String type,
  Value<String?> exerciseId,
  Value<String?> stepMode,
  Value<int?> sets,
  Value<int?> reps,
  Value<int?> workSeconds,
  Value<int?> restSeconds,
  Value<String?> tempo,
  Value<bool> isConfigured,
  Value<int?> circuitRounds,
  Value<String?> parentStepId,
  Value<int> nestingDepth,
  Value<int> rowid,
});
typedef $$WorkoutStepsTableUpdateCompanionBuilder = WorkoutStepsCompanion
    Function({
  Value<String> id,
  Value<String> workoutId,
  Value<int> orderIndex,
  Value<String> type,
  Value<String?> exerciseId,
  Value<String?> stepMode,
  Value<int?> sets,
  Value<int?> reps,
  Value<int?> workSeconds,
  Value<int?> restSeconds,
  Value<String?> tempo,
  Value<bool> isConfigured,
  Value<int?> circuitRounds,
  Value<String?> parentStepId,
  Value<int> nestingDepth,
  Value<int> rowid,
});

final class $$WorkoutStepsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutStepsTable, WorkoutStepRow> {
  $$WorkoutStepsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutsTable _workoutIdTable(_$AppDatabase db) =>
      db.workouts.createAlias(
          $_aliasNameGenerator(db.workoutSteps.workoutId, db.workouts.id));

  $$WorkoutsTableProcessedTableManager get workoutId {
    final $_column = $_itemColumn<String>('workout_id')!;

    final manager = $$WorkoutsTableTableManager($_db, $_db.workouts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$WorkoutStepsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutStepsTable> {
  $$WorkoutStepsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get stepMode => $composableBuilder(
      column: $table.stepMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sets => $composableBuilder(
      column: $table.sets, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get workSeconds => $composableBuilder(
      column: $table.workSeconds, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get restSeconds => $composableBuilder(
      column: $table.restSeconds, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tempo => $composableBuilder(
      column: $table.tempo, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isConfigured => $composableBuilder(
      column: $table.isConfigured, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get circuitRounds => $composableBuilder(
      column: $table.circuitRounds, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parentStepId => $composableBuilder(
      column: $table.parentStepId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get nestingDepth => $composableBuilder(
      column: $table.nestingDepth, builder: (column) => ColumnFilters(column));

  $$WorkoutsTableFilterComposer get workoutId {
    final $$WorkoutsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workoutId,
        referencedTable: $db.workouts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutsTableFilterComposer(
              $db: $db,
              $table: $db.workouts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkoutStepsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutStepsTable> {
  $$WorkoutStepsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get stepMode => $composableBuilder(
      column: $table.stepMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sets => $composableBuilder(
      column: $table.sets, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get workSeconds => $composableBuilder(
      column: $table.workSeconds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get restSeconds => $composableBuilder(
      column: $table.restSeconds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tempo => $composableBuilder(
      column: $table.tempo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isConfigured => $composableBuilder(
      column: $table.isConfigured,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get circuitRounds => $composableBuilder(
      column: $table.circuitRounds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentStepId => $composableBuilder(
      column: $table.parentStepId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get nestingDepth => $composableBuilder(
      column: $table.nestingDepth,
      builder: (column) => ColumnOrderings(column));

  $$WorkoutsTableOrderingComposer get workoutId {
    final $$WorkoutsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workoutId,
        referencedTable: $db.workouts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutsTableOrderingComposer(
              $db: $db,
              $table: $db.workouts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkoutStepsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutStepsTable> {
  $$WorkoutStepsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => column);

  GeneratedColumn<String> get stepMode =>
      $composableBuilder(column: $table.stepMode, builder: (column) => column);

  GeneratedColumn<int> get sets =>
      $composableBuilder(column: $table.sets, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get workSeconds => $composableBuilder(
      column: $table.workSeconds, builder: (column) => column);

  GeneratedColumn<int> get restSeconds => $composableBuilder(
      column: $table.restSeconds, builder: (column) => column);

  GeneratedColumn<String> get tempo =>
      $composableBuilder(column: $table.tempo, builder: (column) => column);

  GeneratedColumn<bool> get isConfigured => $composableBuilder(
      column: $table.isConfigured, builder: (column) => column);

  GeneratedColumn<int> get circuitRounds => $composableBuilder(
      column: $table.circuitRounds, builder: (column) => column);

  GeneratedColumn<String> get parentStepId => $composableBuilder(
      column: $table.parentStepId, builder: (column) => column);

  GeneratedColumn<int> get nestingDepth => $composableBuilder(
      column: $table.nestingDepth, builder: (column) => column);

  $$WorkoutsTableAnnotationComposer get workoutId {
    final $$WorkoutsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workoutId,
        referencedTable: $db.workouts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutsTableAnnotationComposer(
              $db: $db,
              $table: $db.workouts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkoutStepsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkoutStepsTable,
    WorkoutStepRow,
    $$WorkoutStepsTableFilterComposer,
    $$WorkoutStepsTableOrderingComposer,
    $$WorkoutStepsTableAnnotationComposer,
    $$WorkoutStepsTableCreateCompanionBuilder,
    $$WorkoutStepsTableUpdateCompanionBuilder,
    (WorkoutStepRow, $$WorkoutStepsTableReferences),
    WorkoutStepRow,
    PrefetchHooks Function({bool workoutId})> {
  $$WorkoutStepsTableTableManager(_$AppDatabase db, $WorkoutStepsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutStepsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutStepsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutStepsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> workoutId = const Value.absent(),
            Value<int> orderIndex = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> exerciseId = const Value.absent(),
            Value<String?> stepMode = const Value.absent(),
            Value<int?> sets = const Value.absent(),
            Value<int?> reps = const Value.absent(),
            Value<int?> workSeconds = const Value.absent(),
            Value<int?> restSeconds = const Value.absent(),
            Value<String?> tempo = const Value.absent(),
            Value<bool> isConfigured = const Value.absent(),
            Value<int?> circuitRounds = const Value.absent(),
            Value<String?> parentStepId = const Value.absent(),
            Value<int> nestingDepth = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutStepsCompanion(
            id: id,
            workoutId: workoutId,
            orderIndex: orderIndex,
            type: type,
            exerciseId: exerciseId,
            stepMode: stepMode,
            sets: sets,
            reps: reps,
            workSeconds: workSeconds,
            restSeconds: restSeconds,
            tempo: tempo,
            isConfigured: isConfigured,
            circuitRounds: circuitRounds,
            parentStepId: parentStepId,
            nestingDepth: nestingDepth,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String workoutId,
            required int orderIndex,
            required String type,
            Value<String?> exerciseId = const Value.absent(),
            Value<String?> stepMode = const Value.absent(),
            Value<int?> sets = const Value.absent(),
            Value<int?> reps = const Value.absent(),
            Value<int?> workSeconds = const Value.absent(),
            Value<int?> restSeconds = const Value.absent(),
            Value<String?> tempo = const Value.absent(),
            Value<bool> isConfigured = const Value.absent(),
            Value<int?> circuitRounds = const Value.absent(),
            Value<String?> parentStepId = const Value.absent(),
            Value<int> nestingDepth = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutStepsCompanion.insert(
            id: id,
            workoutId: workoutId,
            orderIndex: orderIndex,
            type: type,
            exerciseId: exerciseId,
            stepMode: stepMode,
            sets: sets,
            reps: reps,
            workSeconds: workSeconds,
            restSeconds: restSeconds,
            tempo: tempo,
            isConfigured: isConfigured,
            circuitRounds: circuitRounds,
            parentStepId: parentStepId,
            nestingDepth: nestingDepth,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WorkoutStepsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({workoutId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (workoutId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.workoutId,
                    referencedTable:
                        $$WorkoutStepsTableReferences._workoutIdTable(db),
                    referencedColumn:
                        $$WorkoutStepsTableReferences._workoutIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$WorkoutStepsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkoutStepsTable,
    WorkoutStepRow,
    $$WorkoutStepsTableFilterComposer,
    $$WorkoutStepsTableOrderingComposer,
    $$WorkoutStepsTableAnnotationComposer,
    $$WorkoutStepsTableCreateCompanionBuilder,
    $$WorkoutStepsTableUpdateCompanionBuilder,
    (WorkoutStepRow, $$WorkoutStepsTableReferences),
    WorkoutStepRow,
    PrefetchHooks Function({bool workoutId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$WorkoutsTableTableManager get workouts =>
      $$WorkoutsTableTableManager(_db, _db.workouts);
  $$WorkoutStepsTableTableManager get workoutSteps =>
      $$WorkoutStepsTableTableManager(_db, _db.workoutSteps);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'96b544ff7ce456f0fc1edbdafdf332306a9affed';

/// See also [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = Provider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppDatabaseRef = ProviderRef<AppDatabase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
