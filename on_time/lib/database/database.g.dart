// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PontosTable extends Pontos with TableInfo<$PontosTable, Ponto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PontosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<DateTime> sessionId = GeneratedColumn<DateTime>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, sessionId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pontos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Ponto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ponto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ponto(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      date:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}date'],
          )!,
      sessionId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}session_id'],
          )!,
    );
  }

  @override
  $PontosTable createAlias(String alias) {
    return $PontosTable(attachedDatabase, alias);
  }
}

class Ponto extends DataClass implements Insertable<Ponto> {
  final int id;
  final DateTime date;
  final DateTime sessionId;
  const Ponto({required this.id, required this.date, required this.sessionId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['session_id'] = Variable<DateTime>(sessionId);
    return map;
  }

  PontosCompanion toCompanion(bool nullToAbsent) {
    return PontosCompanion(
      id: Value(id),
      date: Value(date),
      sessionId: Value(sessionId),
    );
  }

  factory Ponto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ponto(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      sessionId: serializer.fromJson<DateTime>(json['sessionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'sessionId': serializer.toJson<DateTime>(sessionId),
    };
  }

  Ponto copyWith({int? id, DateTime? date, DateTime? sessionId}) => Ponto(
    id: id ?? this.id,
    date: date ?? this.date,
    sessionId: sessionId ?? this.sessionId,
  );
  Ponto copyWithCompanion(PontosCompanion data) {
    return Ponto(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ponto(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('sessionId: $sessionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, sessionId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ponto &&
          other.id == this.id &&
          other.date == this.date &&
          other.sessionId == this.sessionId);
}

class PontosCompanion extends UpdateCompanion<Ponto> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<DateTime> sessionId;
  const PontosCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.sessionId = const Value.absent(),
  });
  PontosCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required DateTime sessionId,
  }) : date = Value(date),
       sessionId = Value(sessionId);
  static Insertable<Ponto> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<DateTime>? sessionId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (sessionId != null) 'session_id': sessionId,
    });
  }

  PontosCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<DateTime>? sessionId,
  }) {
    return PontosCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      sessionId: sessionId ?? this.sessionId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<DateTime>(sessionId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PontosCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('sessionId: $sessionId')
          ..write(')'))
        .toString();
  }
}

class $SessionTable extends Session with TableInfo<$SessionTable, SessionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<DateTime> day = GeneratedColumn<DateTime>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _minutesWorkedMeta = const VerificationMeta(
    'minutesWorked',
  );
  @override
  late final GeneratedColumn<int> minutesWorked = GeneratedColumn<int>(
    'minutes_worked',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hourValueMeta = const VerificationMeta(
    'hourValue',
  );
  @override
  late final GeneratedColumn<double> hourValue = GeneratedColumn<double>(
    'hour_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _profitMeta = const VerificationMeta('profit');
  @override
  late final GeneratedColumn<double> profit = GeneratedColumn<double>(
    'profit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _workIdMeta = const VerificationMeta('workId');
  @override
  late final GeneratedColumn<String> workId = GeneratedColumn<String>(
    'work_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    day,
    minutesWorked,
    hourValue,
    profit,
    workId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('minutes_worked')) {
      context.handle(
        _minutesWorkedMeta,
        minutesWorked.isAcceptableOrUnknown(
          data['minutes_worked']!,
          _minutesWorkedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_minutesWorkedMeta);
    }
    if (data.containsKey('hour_value')) {
      context.handle(
        _hourValueMeta,
        hourValue.isAcceptableOrUnknown(data['hour_value']!, _hourValueMeta),
      );
    }
    if (data.containsKey('profit')) {
      context.handle(
        _profitMeta,
        profit.isAcceptableOrUnknown(data['profit']!, _profitMeta),
      );
    }
    if (data.containsKey('work_id')) {
      context.handle(
        _workIdMeta,
        workId.isAcceptableOrUnknown(data['work_id']!, _workIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  SessionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionData(
      day:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}day'],
          )!,
      minutesWorked:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}minutes_worked'],
          )!,
      hourValue:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}hour_value'],
          )!,
      profit:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}profit'],
          )!,
      workId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_id'],
      ),
    );
  }

  @override
  $SessionTable createAlias(String alias) {
    return $SessionTable(attachedDatabase, alias);
  }
}

class SessionData extends DataClass implements Insertable<SessionData> {
  final DateTime day;
  final int minutesWorked;
  final double hourValue;
  final double profit;
  final String? workId;
  const SessionData({
    required this.day,
    required this.minutesWorked,
    required this.hourValue,
    required this.profit,
    this.workId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['day'] = Variable<DateTime>(day);
    map['minutes_worked'] = Variable<int>(minutesWorked);
    map['hour_value'] = Variable<double>(hourValue);
    map['profit'] = Variable<double>(profit);
    if (!nullToAbsent || workId != null) {
      map['work_id'] = Variable<String>(workId);
    }
    return map;
  }

  SessionCompanion toCompanion(bool nullToAbsent) {
    return SessionCompanion(
      day: Value(day),
      minutesWorked: Value(minutesWorked),
      hourValue: Value(hourValue),
      profit: Value(profit),
      workId:
          workId == null && nullToAbsent ? const Value.absent() : Value(workId),
    );
  }

  factory SessionData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionData(
      day: serializer.fromJson<DateTime>(json['day']),
      minutesWorked: serializer.fromJson<int>(json['minutesWorked']),
      hourValue: serializer.fromJson<double>(json['hourValue']),
      profit: serializer.fromJson<double>(json['profit']),
      workId: serializer.fromJson<String?>(json['workId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'day': serializer.toJson<DateTime>(day),
      'minutesWorked': serializer.toJson<int>(minutesWorked),
      'hourValue': serializer.toJson<double>(hourValue),
      'profit': serializer.toJson<double>(profit),
      'workId': serializer.toJson<String?>(workId),
    };
  }

  SessionData copyWith({
    DateTime? day,
    int? minutesWorked,
    double? hourValue,
    double? profit,
    Value<String?> workId = const Value.absent(),
  }) => SessionData(
    day: day ?? this.day,
    minutesWorked: minutesWorked ?? this.minutesWorked,
    hourValue: hourValue ?? this.hourValue,
    profit: profit ?? this.profit,
    workId: workId.present ? workId.value : this.workId,
  );
  SessionData copyWithCompanion(SessionCompanion data) {
    return SessionData(
      day: data.day.present ? data.day.value : this.day,
      minutesWorked:
          data.minutesWorked.present
              ? data.minutesWorked.value
              : this.minutesWorked,
      hourValue: data.hourValue.present ? data.hourValue.value : this.hourValue,
      profit: data.profit.present ? data.profit.value : this.profit,
      workId: data.workId.present ? data.workId.value : this.workId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionData(')
          ..write('day: $day, ')
          ..write('minutesWorked: $minutesWorked, ')
          ..write('hourValue: $hourValue, ')
          ..write('profit: $profit, ')
          ..write('workId: $workId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(day, minutesWorked, hourValue, profit, workId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionData &&
          other.day == this.day &&
          other.minutesWorked == this.minutesWorked &&
          other.hourValue == this.hourValue &&
          other.profit == this.profit &&
          other.workId == this.workId);
}

class SessionCompanion extends UpdateCompanion<SessionData> {
  final Value<DateTime> day;
  final Value<int> minutesWorked;
  final Value<double> hourValue;
  final Value<double> profit;
  final Value<String?> workId;
  final Value<int> rowid;
  const SessionCompanion({
    this.day = const Value.absent(),
    this.minutesWorked = const Value.absent(),
    this.hourValue = const Value.absent(),
    this.profit = const Value.absent(),
    this.workId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionCompanion.insert({
    required DateTime day,
    required int minutesWorked,
    this.hourValue = const Value.absent(),
    this.profit = const Value.absent(),
    this.workId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : day = Value(day),
       minutesWorked = Value(minutesWorked);
  static Insertable<SessionData> custom({
    Expression<DateTime>? day,
    Expression<int>? minutesWorked,
    Expression<double>? hourValue,
    Expression<double>? profit,
    Expression<String>? workId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (day != null) 'day': day,
      if (minutesWorked != null) 'minutes_worked': minutesWorked,
      if (hourValue != null) 'hour_value': hourValue,
      if (profit != null) 'profit': profit,
      if (workId != null) 'work_id': workId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionCompanion copyWith({
    Value<DateTime>? day,
    Value<int>? minutesWorked,
    Value<double>? hourValue,
    Value<double>? profit,
    Value<String?>? workId,
    Value<int>? rowid,
  }) {
    return SessionCompanion(
      day: day ?? this.day,
      minutesWorked: minutesWorked ?? this.minutesWorked,
      hourValue: hourValue ?? this.hourValue,
      profit: profit ?? this.profit,
      workId: workId ?? this.workId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (day.present) {
      map['day'] = Variable<DateTime>(day.value);
    }
    if (minutesWorked.present) {
      map['minutes_worked'] = Variable<int>(minutesWorked.value);
    }
    if (hourValue.present) {
      map['hour_value'] = Variable<double>(hourValue.value);
    }
    if (profit.present) {
      map['profit'] = Variable<double>(profit.value);
    }
    if (workId.present) {
      map['work_id'] = Variable<String>(workId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionCompanion(')
          ..write('day: $day, ')
          ..write('minutesWorked: $minutesWorked, ')
          ..write('hourValue: $hourValue, ')
          ..write('profit: $profit, ')
          ..write('workId: $workId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConfigurationsTable extends Configurations
    with TableInfo<$ConfigurationsTable, Configuration> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConfigurationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _hourValueBaseMeta = const VerificationMeta(
    'hourValueBase',
  );
  @override
  late final GeneratedColumn<double> hourValueBase = GeneratedColumn<double>(
    'hour_value_base',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taxesPercentageMeta = const VerificationMeta(
    'taxesPercentage',
  );
  @override
  late final GeneratedColumn<double> taxesPercentage = GeneratedColumn<double>(
    'taxes_percentage',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _valuesNotTaxableMeta = const VerificationMeta(
    'valuesNotTaxable',
  );
  @override
  late final GeneratedColumn<double> valuesNotTaxable = GeneratedColumn<double>(
    'values_not_taxable',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _extraValueMeta = const VerificationMeta(
    'extraValue',
  );
  @override
  late final GeneratedColumn<double> extraValue = GeneratedColumn<double>(
    'extra_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    hourValueBase,
    taxesPercentage,
    valuesNotTaxable,
    extraValue,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'configurations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Configuration> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('hour_value_base')) {
      context.handle(
        _hourValueBaseMeta,
        hourValueBase.isAcceptableOrUnknown(
          data['hour_value_base']!,
          _hourValueBaseMeta,
        ),
      );
    }
    if (data.containsKey('taxes_percentage')) {
      context.handle(
        _taxesPercentageMeta,
        taxesPercentage.isAcceptableOrUnknown(
          data['taxes_percentage']!,
          _taxesPercentageMeta,
        ),
      );
    }
    if (data.containsKey('values_not_taxable')) {
      context.handle(
        _valuesNotTaxableMeta,
        valuesNotTaxable.isAcceptableOrUnknown(
          data['values_not_taxable']!,
          _valuesNotTaxableMeta,
        ),
      );
    }
    if (data.containsKey('extra_value')) {
      context.handle(
        _extraValueMeta,
        extraValue.isAcceptableOrUnknown(data['extra_value']!, _extraValueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Configuration map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Configuration(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      hourValueBase: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hour_value_base'],
      ),
      taxesPercentage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}taxes_percentage'],
      ),
      valuesNotTaxable: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}values_not_taxable'],
      ),
      extraValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}extra_value'],
      ),
    );
  }

  @override
  $ConfigurationsTable createAlias(String alias) {
    return $ConfigurationsTable(attachedDatabase, alias);
  }
}

class Configuration extends DataClass implements Insertable<Configuration> {
  final int id;
  final double? hourValueBase;
  final double? taxesPercentage;
  final double? valuesNotTaxable;
  final double? extraValue;
  const Configuration({
    required this.id,
    this.hourValueBase,
    this.taxesPercentage,
    this.valuesNotTaxable,
    this.extraValue,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || hourValueBase != null) {
      map['hour_value_base'] = Variable<double>(hourValueBase);
    }
    if (!nullToAbsent || taxesPercentage != null) {
      map['taxes_percentage'] = Variable<double>(taxesPercentage);
    }
    if (!nullToAbsent || valuesNotTaxable != null) {
      map['values_not_taxable'] = Variable<double>(valuesNotTaxable);
    }
    if (!nullToAbsent || extraValue != null) {
      map['extra_value'] = Variable<double>(extraValue);
    }
    return map;
  }

  ConfigurationsCompanion toCompanion(bool nullToAbsent) {
    return ConfigurationsCompanion(
      id: Value(id),
      hourValueBase:
          hourValueBase == null && nullToAbsent
              ? const Value.absent()
              : Value(hourValueBase),
      taxesPercentage:
          taxesPercentage == null && nullToAbsent
              ? const Value.absent()
              : Value(taxesPercentage),
      valuesNotTaxable:
          valuesNotTaxable == null && nullToAbsent
              ? const Value.absent()
              : Value(valuesNotTaxable),
      extraValue:
          extraValue == null && nullToAbsent
              ? const Value.absent()
              : Value(extraValue),
    );
  }

  factory Configuration.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Configuration(
      id: serializer.fromJson<int>(json['id']),
      hourValueBase: serializer.fromJson<double?>(json['hourValueBase']),
      taxesPercentage: serializer.fromJson<double?>(json['taxesPercentage']),
      valuesNotTaxable: serializer.fromJson<double?>(json['valuesNotTaxable']),
      extraValue: serializer.fromJson<double?>(json['extraValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'hourValueBase': serializer.toJson<double?>(hourValueBase),
      'taxesPercentage': serializer.toJson<double?>(taxesPercentage),
      'valuesNotTaxable': serializer.toJson<double?>(valuesNotTaxable),
      'extraValue': serializer.toJson<double?>(extraValue),
    };
  }

  Configuration copyWith({
    int? id,
    Value<double?> hourValueBase = const Value.absent(),
    Value<double?> taxesPercentage = const Value.absent(),
    Value<double?> valuesNotTaxable = const Value.absent(),
    Value<double?> extraValue = const Value.absent(),
  }) => Configuration(
    id: id ?? this.id,
    hourValueBase:
        hourValueBase.present ? hourValueBase.value : this.hourValueBase,
    taxesPercentage:
        taxesPercentage.present ? taxesPercentage.value : this.taxesPercentage,
    valuesNotTaxable:
        valuesNotTaxable.present
            ? valuesNotTaxable.value
            : this.valuesNotTaxable,
    extraValue: extraValue.present ? extraValue.value : this.extraValue,
  );
  Configuration copyWithCompanion(ConfigurationsCompanion data) {
    return Configuration(
      id: data.id.present ? data.id.value : this.id,
      hourValueBase:
          data.hourValueBase.present
              ? data.hourValueBase.value
              : this.hourValueBase,
      taxesPercentage:
          data.taxesPercentage.present
              ? data.taxesPercentage.value
              : this.taxesPercentage,
      valuesNotTaxable:
          data.valuesNotTaxable.present
              ? data.valuesNotTaxable.value
              : this.valuesNotTaxable,
      extraValue:
          data.extraValue.present ? data.extraValue.value : this.extraValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Configuration(')
          ..write('id: $id, ')
          ..write('hourValueBase: $hourValueBase, ')
          ..write('taxesPercentage: $taxesPercentage, ')
          ..write('valuesNotTaxable: $valuesNotTaxable, ')
          ..write('extraValue: $extraValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    hourValueBase,
    taxesPercentage,
    valuesNotTaxable,
    extraValue,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Configuration &&
          other.id == this.id &&
          other.hourValueBase == this.hourValueBase &&
          other.taxesPercentage == this.taxesPercentage &&
          other.valuesNotTaxable == this.valuesNotTaxable &&
          other.extraValue == this.extraValue);
}

class ConfigurationsCompanion extends UpdateCompanion<Configuration> {
  final Value<int> id;
  final Value<double?> hourValueBase;
  final Value<double?> taxesPercentage;
  final Value<double?> valuesNotTaxable;
  final Value<double?> extraValue;
  const ConfigurationsCompanion({
    this.id = const Value.absent(),
    this.hourValueBase = const Value.absent(),
    this.taxesPercentage = const Value.absent(),
    this.valuesNotTaxable = const Value.absent(),
    this.extraValue = const Value.absent(),
  });
  ConfigurationsCompanion.insert({
    this.id = const Value.absent(),
    this.hourValueBase = const Value.absent(),
    this.taxesPercentage = const Value.absent(),
    this.valuesNotTaxable = const Value.absent(),
    this.extraValue = const Value.absent(),
  });
  static Insertable<Configuration> custom({
    Expression<int>? id,
    Expression<double>? hourValueBase,
    Expression<double>? taxesPercentage,
    Expression<double>? valuesNotTaxable,
    Expression<double>? extraValue,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hourValueBase != null) 'hour_value_base': hourValueBase,
      if (taxesPercentage != null) 'taxes_percentage': taxesPercentage,
      if (valuesNotTaxable != null) 'values_not_taxable': valuesNotTaxable,
      if (extraValue != null) 'extra_value': extraValue,
    });
  }

  ConfigurationsCompanion copyWith({
    Value<int>? id,
    Value<double?>? hourValueBase,
    Value<double?>? taxesPercentage,
    Value<double?>? valuesNotTaxable,
    Value<double?>? extraValue,
  }) {
    return ConfigurationsCompanion(
      id: id ?? this.id,
      hourValueBase: hourValueBase ?? this.hourValueBase,
      taxesPercentage: taxesPercentage ?? this.taxesPercentage,
      valuesNotTaxable: valuesNotTaxable ?? this.valuesNotTaxable,
      extraValue: extraValue ?? this.extraValue,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (hourValueBase.present) {
      map['hour_value_base'] = Variable<double>(hourValueBase.value);
    }
    if (taxesPercentage.present) {
      map['taxes_percentage'] = Variable<double>(taxesPercentage.value);
    }
    if (valuesNotTaxable.present) {
      map['values_not_taxable'] = Variable<double>(valuesNotTaxable.value);
    }
    if (extraValue.present) {
      map['extra_value'] = Variable<double>(extraValue.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConfigurationsCompanion(')
          ..write('id: $id, ')
          ..write('hourValueBase: $hourValueBase, ')
          ..write('taxesPercentage: $taxesPercentage, ')
          ..write('valuesNotTaxable: $valuesNotTaxable, ')
          ..write('extraValue: $extraValue')
          ..write(')'))
        .toString();
  }
}

class $HourValuePoliticsTable extends HourValuePolitics
    with TableInfo<$HourValuePoliticsTable, HourValuePolitic> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HourValuePoliticsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _hourValueMeta = const VerificationMeta(
    'hourValue',
  );
  @override
  late final GeneratedColumn<double> hourValue = GeneratedColumn<double>(
    'hour_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _percentageMeta = const VerificationMeta(
    'percentage',
  );
  @override
  late final GeneratedColumn<int> percentage = GeneratedColumn<int>(
    'percentage',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dayOffWeekMeta = const VerificationMeta(
    'dayOffWeek',
  );
  @override
  late final GeneratedColumn<String> dayOffWeek = GeneratedColumn<String>(
    'day_off_week',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _afterMinutesWorkedMeta =
      const VerificationMeta('afterMinutesWorked');
  @override
  late final GeneratedColumn<int> afterMinutesWorked = GeneratedColumn<int>(
    'after_minutes_worked',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _afterScheduleMeta = const VerificationMeta(
    'afterSchedule',
  );
  @override
  late final GeneratedColumn<DateTime> afterSchedule =
      GeneratedColumn<DateTime>(
        'after_schedule',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    hourValue,
    percentage,
    dayOffWeek,
    afterMinutesWorked,
    afterSchedule,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hour_value_politics';
  @override
  VerificationContext validateIntegrity(
    Insertable<HourValuePolitic> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('hour_value')) {
      context.handle(
        _hourValueMeta,
        hourValue.isAcceptableOrUnknown(data['hour_value']!, _hourValueMeta),
      );
    }
    if (data.containsKey('percentage')) {
      context.handle(
        _percentageMeta,
        percentage.isAcceptableOrUnknown(data['percentage']!, _percentageMeta),
      );
    }
    if (data.containsKey('day_off_week')) {
      context.handle(
        _dayOffWeekMeta,
        dayOffWeek.isAcceptableOrUnknown(
          data['day_off_week']!,
          _dayOffWeekMeta,
        ),
      );
    }
    if (data.containsKey('after_minutes_worked')) {
      context.handle(
        _afterMinutesWorkedMeta,
        afterMinutesWorked.isAcceptableOrUnknown(
          data['after_minutes_worked']!,
          _afterMinutesWorkedMeta,
        ),
      );
    }
    if (data.containsKey('after_schedule')) {
      context.handle(
        _afterScheduleMeta,
        afterSchedule.isAcceptableOrUnknown(
          data['after_schedule']!,
          _afterScheduleMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HourValuePolitic map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HourValuePolitic(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      hourValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hour_value'],
      ),
      percentage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}percentage'],
      ),
      dayOffWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_off_week'],
      ),
      afterMinutesWorked: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}after_minutes_worked'],
      ),
      afterSchedule: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}after_schedule'],
      ),
    );
  }

  @override
  $HourValuePoliticsTable createAlias(String alias) {
    return $HourValuePoliticsTable(attachedDatabase, alias);
  }
}

class HourValuePolitic extends DataClass
    implements Insertable<HourValuePolitic> {
  final int id;
  final double? hourValue;
  final int? percentage;
  final String? dayOffWeek;
  final int? afterMinutesWorked;
  final DateTime? afterSchedule;
  const HourValuePolitic({
    required this.id,
    this.hourValue,
    this.percentage,
    this.dayOffWeek,
    this.afterMinutesWorked,
    this.afterSchedule,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || hourValue != null) {
      map['hour_value'] = Variable<double>(hourValue);
    }
    if (!nullToAbsent || percentage != null) {
      map['percentage'] = Variable<int>(percentage);
    }
    if (!nullToAbsent || dayOffWeek != null) {
      map['day_off_week'] = Variable<String>(dayOffWeek);
    }
    if (!nullToAbsent || afterMinutesWorked != null) {
      map['after_minutes_worked'] = Variable<int>(afterMinutesWorked);
    }
    if (!nullToAbsent || afterSchedule != null) {
      map['after_schedule'] = Variable<DateTime>(afterSchedule);
    }
    return map;
  }

  HourValuePoliticsCompanion toCompanion(bool nullToAbsent) {
    return HourValuePoliticsCompanion(
      id: Value(id),
      hourValue:
          hourValue == null && nullToAbsent
              ? const Value.absent()
              : Value(hourValue),
      percentage:
          percentage == null && nullToAbsent
              ? const Value.absent()
              : Value(percentage),
      dayOffWeek:
          dayOffWeek == null && nullToAbsent
              ? const Value.absent()
              : Value(dayOffWeek),
      afterMinutesWorked:
          afterMinutesWorked == null && nullToAbsent
              ? const Value.absent()
              : Value(afterMinutesWorked),
      afterSchedule:
          afterSchedule == null && nullToAbsent
              ? const Value.absent()
              : Value(afterSchedule),
    );
  }

  factory HourValuePolitic.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HourValuePolitic(
      id: serializer.fromJson<int>(json['id']),
      hourValue: serializer.fromJson<double?>(json['hourValue']),
      percentage: serializer.fromJson<int?>(json['percentage']),
      dayOffWeek: serializer.fromJson<String?>(json['dayOffWeek']),
      afterMinutesWorked: serializer.fromJson<int?>(json['afterMinutesWorked']),
      afterSchedule: serializer.fromJson<DateTime?>(json['afterSchedule']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'hourValue': serializer.toJson<double?>(hourValue),
      'percentage': serializer.toJson<int?>(percentage),
      'dayOffWeek': serializer.toJson<String?>(dayOffWeek),
      'afterMinutesWorked': serializer.toJson<int?>(afterMinutesWorked),
      'afterSchedule': serializer.toJson<DateTime?>(afterSchedule),
    };
  }

  HourValuePolitic copyWith({
    int? id,
    Value<double?> hourValue = const Value.absent(),
    Value<int?> percentage = const Value.absent(),
    Value<String?> dayOffWeek = const Value.absent(),
    Value<int?> afterMinutesWorked = const Value.absent(),
    Value<DateTime?> afterSchedule = const Value.absent(),
  }) => HourValuePolitic(
    id: id ?? this.id,
    hourValue: hourValue.present ? hourValue.value : this.hourValue,
    percentage: percentage.present ? percentage.value : this.percentage,
    dayOffWeek: dayOffWeek.present ? dayOffWeek.value : this.dayOffWeek,
    afterMinutesWorked:
        afterMinutesWorked.present
            ? afterMinutesWorked.value
            : this.afterMinutesWorked,
    afterSchedule:
        afterSchedule.present ? afterSchedule.value : this.afterSchedule,
  );
  HourValuePolitic copyWithCompanion(HourValuePoliticsCompanion data) {
    return HourValuePolitic(
      id: data.id.present ? data.id.value : this.id,
      hourValue: data.hourValue.present ? data.hourValue.value : this.hourValue,
      percentage:
          data.percentage.present ? data.percentage.value : this.percentage,
      dayOffWeek:
          data.dayOffWeek.present ? data.dayOffWeek.value : this.dayOffWeek,
      afterMinutesWorked:
          data.afterMinutesWorked.present
              ? data.afterMinutesWorked.value
              : this.afterMinutesWorked,
      afterSchedule:
          data.afterSchedule.present
              ? data.afterSchedule.value
              : this.afterSchedule,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HourValuePolitic(')
          ..write('id: $id, ')
          ..write('hourValue: $hourValue, ')
          ..write('percentage: $percentage, ')
          ..write('dayOffWeek: $dayOffWeek, ')
          ..write('afterMinutesWorked: $afterMinutesWorked, ')
          ..write('afterSchedule: $afterSchedule')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    hourValue,
    percentage,
    dayOffWeek,
    afterMinutesWorked,
    afterSchedule,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HourValuePolitic &&
          other.id == this.id &&
          other.hourValue == this.hourValue &&
          other.percentage == this.percentage &&
          other.dayOffWeek == this.dayOffWeek &&
          other.afterMinutesWorked == this.afterMinutesWorked &&
          other.afterSchedule == this.afterSchedule);
}

class HourValuePoliticsCompanion extends UpdateCompanion<HourValuePolitic> {
  final Value<int> id;
  final Value<double?> hourValue;
  final Value<int?> percentage;
  final Value<String?> dayOffWeek;
  final Value<int?> afterMinutesWorked;
  final Value<DateTime?> afterSchedule;
  const HourValuePoliticsCompanion({
    this.id = const Value.absent(),
    this.hourValue = const Value.absent(),
    this.percentage = const Value.absent(),
    this.dayOffWeek = const Value.absent(),
    this.afterMinutesWorked = const Value.absent(),
    this.afterSchedule = const Value.absent(),
  });
  HourValuePoliticsCompanion.insert({
    this.id = const Value.absent(),
    this.hourValue = const Value.absent(),
    this.percentage = const Value.absent(),
    this.dayOffWeek = const Value.absent(),
    this.afterMinutesWorked = const Value.absent(),
    this.afterSchedule = const Value.absent(),
  });
  static Insertable<HourValuePolitic> custom({
    Expression<int>? id,
    Expression<double>? hourValue,
    Expression<int>? percentage,
    Expression<String>? dayOffWeek,
    Expression<int>? afterMinutesWorked,
    Expression<DateTime>? afterSchedule,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hourValue != null) 'hour_value': hourValue,
      if (percentage != null) 'percentage': percentage,
      if (dayOffWeek != null) 'day_off_week': dayOffWeek,
      if (afterMinutesWorked != null)
        'after_minutes_worked': afterMinutesWorked,
      if (afterSchedule != null) 'after_schedule': afterSchedule,
    });
  }

  HourValuePoliticsCompanion copyWith({
    Value<int>? id,
    Value<double?>? hourValue,
    Value<int?>? percentage,
    Value<String?>? dayOffWeek,
    Value<int?>? afterMinutesWorked,
    Value<DateTime?>? afterSchedule,
  }) {
    return HourValuePoliticsCompanion(
      id: id ?? this.id,
      hourValue: hourValue ?? this.hourValue,
      percentage: percentage ?? this.percentage,
      dayOffWeek: dayOffWeek ?? this.dayOffWeek,
      afterMinutesWorked: afterMinutesWorked ?? this.afterMinutesWorked,
      afterSchedule: afterSchedule ?? this.afterSchedule,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (hourValue.present) {
      map['hour_value'] = Variable<double>(hourValue.value);
    }
    if (percentage.present) {
      map['percentage'] = Variable<int>(percentage.value);
    }
    if (dayOffWeek.present) {
      map['day_off_week'] = Variable<String>(dayOffWeek.value);
    }
    if (afterMinutesWorked.present) {
      map['after_minutes_worked'] = Variable<int>(afterMinutesWorked.value);
    }
    if (afterSchedule.present) {
      map['after_schedule'] = Variable<DateTime>(afterSchedule.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HourValuePoliticsCompanion(')
          ..write('id: $id, ')
          ..write('hourValue: $hourValue, ')
          ..write('percentage: $percentage, ')
          ..write('dayOffWeek: $dayOffWeek, ')
          ..write('afterMinutesWorked: $afterMinutesWorked, ')
          ..write('afterSchedule: $afterSchedule')
          ..write(')'))
        .toString();
  }
}

class $WorkTable extends Work with TableInfo<$WorkTable, WorkData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _designationMeta = const VerificationMeta(
    'designation',
  );
  @override
  late final GeneratedColumn<String> designation = GeneratedColumn<String>(
    'designation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, designation];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('designation')) {
      context.handle(
        _designationMeta,
        designation.isAcceptableOrUnknown(
          data['designation']!,
          _designationMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      designation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}designation'],
      ),
    );
  }

  @override
  $WorkTable createAlias(String alias) {
    return $WorkTable(attachedDatabase, alias);
  }
}

class WorkData extends DataClass implements Insertable<WorkData> {
  final int id;
  final String? designation;
  const WorkData({required this.id, this.designation});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || designation != null) {
      map['designation'] = Variable<String>(designation);
    }
    return map;
  }

  WorkCompanion toCompanion(bool nullToAbsent) {
    return WorkCompanion(
      id: Value(id),
      designation:
          designation == null && nullToAbsent
              ? const Value.absent()
              : Value(designation),
    );
  }

  factory WorkData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkData(
      id: serializer.fromJson<int>(json['id']),
      designation: serializer.fromJson<String?>(json['designation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'designation': serializer.toJson<String?>(designation),
    };
  }

  WorkData copyWith({
    int? id,
    Value<String?> designation = const Value.absent(),
  }) => WorkData(
    id: id ?? this.id,
    designation: designation.present ? designation.value : this.designation,
  );
  WorkData copyWithCompanion(WorkCompanion data) {
    return WorkData(
      id: data.id.present ? data.id.value : this.id,
      designation:
          data.designation.present ? data.designation.value : this.designation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkData(')
          ..write('id: $id, ')
          ..write('designation: $designation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, designation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkData &&
          other.id == this.id &&
          other.designation == this.designation);
}

class WorkCompanion extends UpdateCompanion<WorkData> {
  final Value<int> id;
  final Value<String?> designation;
  const WorkCompanion({
    this.id = const Value.absent(),
    this.designation = const Value.absent(),
  });
  WorkCompanion.insert({
    this.id = const Value.absent(),
    this.designation = const Value.absent(),
  });
  static Insertable<WorkData> custom({
    Expression<int>? id,
    Expression<String>? designation,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (designation != null) 'designation': designation,
    });
  }

  WorkCompanion copyWith({Value<int>? id, Value<String?>? designation}) {
    return WorkCompanion(
      id: id ?? this.id,
      designation: designation ?? this.designation,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (designation.present) {
      map['designation'] = Variable<String>(designation.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkCompanion(')
          ..write('id: $id, ')
          ..write('designation: $designation')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PontosTable pontos = $PontosTable(this);
  late final $SessionTable session = $SessionTable(this);
  late final $ConfigurationsTable configurations = $ConfigurationsTable(this);
  late final $HourValuePoliticsTable hourValuePolitics =
      $HourValuePoliticsTable(this);
  late final $WorkTable work = $WorkTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    pontos,
    session,
    configurations,
    hourValuePolitics,
    work,
  ];
}

typedef $$PontosTableCreateCompanionBuilder =
    PontosCompanion Function({
      Value<int> id,
      required DateTime date,
      required DateTime sessionId,
    });
typedef $$PontosTableUpdateCompanionBuilder =
    PontosCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<DateTime> sessionId,
    });

class $$PontosTableFilterComposer
    extends Composer<_$AppDatabase, $PontosTable> {
  $$PontosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PontosTableOrderingComposer
    extends Composer<_$AppDatabase, $PontosTable> {
  $$PontosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PontosTableAnnotationComposer
    extends Composer<_$AppDatabase, $PontosTable> {
  $$PontosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);
}

class $$PontosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PontosTable,
          Ponto,
          $$PontosTableFilterComposer,
          $$PontosTableOrderingComposer,
          $$PontosTableAnnotationComposer,
          $$PontosTableCreateCompanionBuilder,
          $$PontosTableUpdateCompanionBuilder,
          (Ponto, BaseReferences<_$AppDatabase, $PontosTable, Ponto>),
          Ponto,
          PrefetchHooks Function()
        > {
  $$PontosTableTableManager(_$AppDatabase db, $PontosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PontosTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$PontosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$PontosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<DateTime> sessionId = const Value.absent(),
              }) => PontosCompanion(id: id, date: date, sessionId: sessionId),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required DateTime sessionId,
              }) => PontosCompanion.insert(
                id: id,
                date: date,
                sessionId: sessionId,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PontosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PontosTable,
      Ponto,
      $$PontosTableFilterComposer,
      $$PontosTableOrderingComposer,
      $$PontosTableAnnotationComposer,
      $$PontosTableCreateCompanionBuilder,
      $$PontosTableUpdateCompanionBuilder,
      (Ponto, BaseReferences<_$AppDatabase, $PontosTable, Ponto>),
      Ponto,
      PrefetchHooks Function()
    >;
typedef $$SessionTableCreateCompanionBuilder =
    SessionCompanion Function({
      required DateTime day,
      required int minutesWorked,
      Value<double> hourValue,
      Value<double> profit,
      Value<String?> workId,
      Value<int> rowid,
    });
typedef $$SessionTableUpdateCompanionBuilder =
    SessionCompanion Function({
      Value<DateTime> day,
      Value<int> minutesWorked,
      Value<double> hourValue,
      Value<double> profit,
      Value<String?> workId,
      Value<int> rowid,
    });

class $$SessionTableFilterComposer
    extends Composer<_$AppDatabase, $SessionTable> {
  $$SessionTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minutesWorked => $composableBuilder(
    column: $table.minutesWorked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hourValue => $composableBuilder(
    column: $table.hourValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get profit => $composableBuilder(
    column: $table.profit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workId => $composableBuilder(
    column: $table.workId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionTable> {
  $$SessionTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minutesWorked => $composableBuilder(
    column: $table.minutesWorked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hourValue => $composableBuilder(
    column: $table.hourValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get profit => $composableBuilder(
    column: $table.profit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workId => $composableBuilder(
    column: $table.workId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionTable> {
  $$SessionTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get minutesWorked => $composableBuilder(
    column: $table.minutesWorked,
    builder: (column) => column,
  );

  GeneratedColumn<double> get hourValue =>
      $composableBuilder(column: $table.hourValue, builder: (column) => column);

  GeneratedColumn<double> get profit =>
      $composableBuilder(column: $table.profit, builder: (column) => column);

  GeneratedColumn<String> get workId =>
      $composableBuilder(column: $table.workId, builder: (column) => column);
}

class $$SessionTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionTable,
          SessionData,
          $$SessionTableFilterComposer,
          $$SessionTableOrderingComposer,
          $$SessionTableAnnotationComposer,
          $$SessionTableCreateCompanionBuilder,
          $$SessionTableUpdateCompanionBuilder,
          (
            SessionData,
            BaseReferences<_$AppDatabase, $SessionTable, SessionData>,
          ),
          SessionData,
          PrefetchHooks Function()
        > {
  $$SessionTableTableManager(_$AppDatabase db, $SessionTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SessionTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SessionTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$SessionTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> day = const Value.absent(),
                Value<int> minutesWorked = const Value.absent(),
                Value<double> hourValue = const Value.absent(),
                Value<double> profit = const Value.absent(),
                Value<String?> workId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionCompanion(
                day: day,
                minutesWorked: minutesWorked,
                hourValue: hourValue,
                profit: profit,
                workId: workId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime day,
                required int minutesWorked,
                Value<double> hourValue = const Value.absent(),
                Value<double> profit = const Value.absent(),
                Value<String?> workId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionCompanion.insert(
                day: day,
                minutesWorked: minutesWorked,
                hourValue: hourValue,
                profit: profit,
                workId: workId,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionTable,
      SessionData,
      $$SessionTableFilterComposer,
      $$SessionTableOrderingComposer,
      $$SessionTableAnnotationComposer,
      $$SessionTableCreateCompanionBuilder,
      $$SessionTableUpdateCompanionBuilder,
      (SessionData, BaseReferences<_$AppDatabase, $SessionTable, SessionData>),
      SessionData,
      PrefetchHooks Function()
    >;
typedef $$ConfigurationsTableCreateCompanionBuilder =
    ConfigurationsCompanion Function({
      Value<int> id,
      Value<double?> hourValueBase,
      Value<double?> taxesPercentage,
      Value<double?> valuesNotTaxable,
      Value<double?> extraValue,
    });
typedef $$ConfigurationsTableUpdateCompanionBuilder =
    ConfigurationsCompanion Function({
      Value<int> id,
      Value<double?> hourValueBase,
      Value<double?> taxesPercentage,
      Value<double?> valuesNotTaxable,
      Value<double?> extraValue,
    });

class $$ConfigurationsTableFilterComposer
    extends Composer<_$AppDatabase, $ConfigurationsTable> {
  $$ConfigurationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hourValueBase => $composableBuilder(
    column: $table.hourValueBase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxesPercentage => $composableBuilder(
    column: $table.taxesPercentage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valuesNotTaxable => $composableBuilder(
    column: $table.valuesNotTaxable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get extraValue => $composableBuilder(
    column: $table.extraValue,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConfigurationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConfigurationsTable> {
  $$ConfigurationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hourValueBase => $composableBuilder(
    column: $table.hourValueBase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxesPercentage => $composableBuilder(
    column: $table.taxesPercentage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valuesNotTaxable => $composableBuilder(
    column: $table.valuesNotTaxable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get extraValue => $composableBuilder(
    column: $table.extraValue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConfigurationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConfigurationsTable> {
  $$ConfigurationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get hourValueBase => $composableBuilder(
    column: $table.hourValueBase,
    builder: (column) => column,
  );

  GeneratedColumn<double> get taxesPercentage => $composableBuilder(
    column: $table.taxesPercentage,
    builder: (column) => column,
  );

  GeneratedColumn<double> get valuesNotTaxable => $composableBuilder(
    column: $table.valuesNotTaxable,
    builder: (column) => column,
  );

  GeneratedColumn<double> get extraValue => $composableBuilder(
    column: $table.extraValue,
    builder: (column) => column,
  );
}

class $$ConfigurationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConfigurationsTable,
          Configuration,
          $$ConfigurationsTableFilterComposer,
          $$ConfigurationsTableOrderingComposer,
          $$ConfigurationsTableAnnotationComposer,
          $$ConfigurationsTableCreateCompanionBuilder,
          $$ConfigurationsTableUpdateCompanionBuilder,
          (
            Configuration,
            BaseReferences<_$AppDatabase, $ConfigurationsTable, Configuration>,
          ),
          Configuration,
          PrefetchHooks Function()
        > {
  $$ConfigurationsTableTableManager(
    _$AppDatabase db,
    $ConfigurationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ConfigurationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$ConfigurationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ConfigurationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double?> hourValueBase = const Value.absent(),
                Value<double?> taxesPercentage = const Value.absent(),
                Value<double?> valuesNotTaxable = const Value.absent(),
                Value<double?> extraValue = const Value.absent(),
              }) => ConfigurationsCompanion(
                id: id,
                hourValueBase: hourValueBase,
                taxesPercentage: taxesPercentage,
                valuesNotTaxable: valuesNotTaxable,
                extraValue: extraValue,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double?> hourValueBase = const Value.absent(),
                Value<double?> taxesPercentage = const Value.absent(),
                Value<double?> valuesNotTaxable = const Value.absent(),
                Value<double?> extraValue = const Value.absent(),
              }) => ConfigurationsCompanion.insert(
                id: id,
                hourValueBase: hourValueBase,
                taxesPercentage: taxesPercentage,
                valuesNotTaxable: valuesNotTaxable,
                extraValue: extraValue,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConfigurationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConfigurationsTable,
      Configuration,
      $$ConfigurationsTableFilterComposer,
      $$ConfigurationsTableOrderingComposer,
      $$ConfigurationsTableAnnotationComposer,
      $$ConfigurationsTableCreateCompanionBuilder,
      $$ConfigurationsTableUpdateCompanionBuilder,
      (
        Configuration,
        BaseReferences<_$AppDatabase, $ConfigurationsTable, Configuration>,
      ),
      Configuration,
      PrefetchHooks Function()
    >;
typedef $$HourValuePoliticsTableCreateCompanionBuilder =
    HourValuePoliticsCompanion Function({
      Value<int> id,
      Value<double?> hourValue,
      Value<int?> percentage,
      Value<String?> dayOffWeek,
      Value<int?> afterMinutesWorked,
      Value<DateTime?> afterSchedule,
    });
typedef $$HourValuePoliticsTableUpdateCompanionBuilder =
    HourValuePoliticsCompanion Function({
      Value<int> id,
      Value<double?> hourValue,
      Value<int?> percentage,
      Value<String?> dayOffWeek,
      Value<int?> afterMinutesWorked,
      Value<DateTime?> afterSchedule,
    });

class $$HourValuePoliticsTableFilterComposer
    extends Composer<_$AppDatabase, $HourValuePoliticsTable> {
  $$HourValuePoliticsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hourValue => $composableBuilder(
    column: $table.hourValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get percentage => $composableBuilder(
    column: $table.percentage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayOffWeek => $composableBuilder(
    column: $table.dayOffWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get afterMinutesWorked => $composableBuilder(
    column: $table.afterMinutesWorked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get afterSchedule => $composableBuilder(
    column: $table.afterSchedule,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HourValuePoliticsTableOrderingComposer
    extends Composer<_$AppDatabase, $HourValuePoliticsTable> {
  $$HourValuePoliticsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hourValue => $composableBuilder(
    column: $table.hourValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get percentage => $composableBuilder(
    column: $table.percentage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayOffWeek => $composableBuilder(
    column: $table.dayOffWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get afterMinutesWorked => $composableBuilder(
    column: $table.afterMinutesWorked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get afterSchedule => $composableBuilder(
    column: $table.afterSchedule,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HourValuePoliticsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HourValuePoliticsTable> {
  $$HourValuePoliticsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get hourValue =>
      $composableBuilder(column: $table.hourValue, builder: (column) => column);

  GeneratedColumn<int> get percentage => $composableBuilder(
    column: $table.percentage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dayOffWeek => $composableBuilder(
    column: $table.dayOffWeek,
    builder: (column) => column,
  );

  GeneratedColumn<int> get afterMinutesWorked => $composableBuilder(
    column: $table.afterMinutesWorked,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get afterSchedule => $composableBuilder(
    column: $table.afterSchedule,
    builder: (column) => column,
  );
}

class $$HourValuePoliticsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HourValuePoliticsTable,
          HourValuePolitic,
          $$HourValuePoliticsTableFilterComposer,
          $$HourValuePoliticsTableOrderingComposer,
          $$HourValuePoliticsTableAnnotationComposer,
          $$HourValuePoliticsTableCreateCompanionBuilder,
          $$HourValuePoliticsTableUpdateCompanionBuilder,
          (
            HourValuePolitic,
            BaseReferences<
              _$AppDatabase,
              $HourValuePoliticsTable,
              HourValuePolitic
            >,
          ),
          HourValuePolitic,
          PrefetchHooks Function()
        > {
  $$HourValuePoliticsTableTableManager(
    _$AppDatabase db,
    $HourValuePoliticsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$HourValuePoliticsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$HourValuePoliticsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$HourValuePoliticsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double?> hourValue = const Value.absent(),
                Value<int?> percentage = const Value.absent(),
                Value<String?> dayOffWeek = const Value.absent(),
                Value<int?> afterMinutesWorked = const Value.absent(),
                Value<DateTime?> afterSchedule = const Value.absent(),
              }) => HourValuePoliticsCompanion(
                id: id,
                hourValue: hourValue,
                percentage: percentage,
                dayOffWeek: dayOffWeek,
                afterMinutesWorked: afterMinutesWorked,
                afterSchedule: afterSchedule,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double?> hourValue = const Value.absent(),
                Value<int?> percentage = const Value.absent(),
                Value<String?> dayOffWeek = const Value.absent(),
                Value<int?> afterMinutesWorked = const Value.absent(),
                Value<DateTime?> afterSchedule = const Value.absent(),
              }) => HourValuePoliticsCompanion.insert(
                id: id,
                hourValue: hourValue,
                percentage: percentage,
                dayOffWeek: dayOffWeek,
                afterMinutesWorked: afterMinutesWorked,
                afterSchedule: afterSchedule,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HourValuePoliticsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HourValuePoliticsTable,
      HourValuePolitic,
      $$HourValuePoliticsTableFilterComposer,
      $$HourValuePoliticsTableOrderingComposer,
      $$HourValuePoliticsTableAnnotationComposer,
      $$HourValuePoliticsTableCreateCompanionBuilder,
      $$HourValuePoliticsTableUpdateCompanionBuilder,
      (
        HourValuePolitic,
        BaseReferences<
          _$AppDatabase,
          $HourValuePoliticsTable,
          HourValuePolitic
        >,
      ),
      HourValuePolitic,
      PrefetchHooks Function()
    >;
typedef $$WorkTableCreateCompanionBuilder =
    WorkCompanion Function({Value<int> id, Value<String?> designation});
typedef $$WorkTableUpdateCompanionBuilder =
    WorkCompanion Function({Value<int> id, Value<String?> designation});

class $$WorkTableFilterComposer extends Composer<_$AppDatabase, $WorkTable> {
  $$WorkTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get designation => $composableBuilder(
    column: $table.designation,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkTableOrderingComposer extends Composer<_$AppDatabase, $WorkTable> {
  $$WorkTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get designation => $composableBuilder(
    column: $table.designation,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkTable> {
  $$WorkTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get designation => $composableBuilder(
    column: $table.designation,
    builder: (column) => column,
  );
}

class $$WorkTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkTable,
          WorkData,
          $$WorkTableFilterComposer,
          $$WorkTableOrderingComposer,
          $$WorkTableAnnotationComposer,
          $$WorkTableCreateCompanionBuilder,
          $$WorkTableUpdateCompanionBuilder,
          (WorkData, BaseReferences<_$AppDatabase, $WorkTable, WorkData>),
          WorkData,
          PrefetchHooks Function()
        > {
  $$WorkTableTableManager(_$AppDatabase db, $WorkTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$WorkTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$WorkTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$WorkTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> designation = const Value.absent(),
              }) => WorkCompanion(id: id, designation: designation),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> designation = const Value.absent(),
              }) => WorkCompanion.insert(id: id, designation: designation),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkTable,
      WorkData,
      $$WorkTableFilterComposer,
      $$WorkTableOrderingComposer,
      $$WorkTableAnnotationComposer,
      $$WorkTableCreateCompanionBuilder,
      $$WorkTableUpdateCompanionBuilder,
      (WorkData, BaseReferences<_$AppDatabase, $WorkTable, WorkData>),
      WorkData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PontosTableTableManager get pontos =>
      $$PontosTableTableManager(_db, _db.pontos);
  $$SessionTableTableManager get session =>
      $$SessionTableTableManager(_db, _db.session);
  $$ConfigurationsTableTableManager get configurations =>
      $$ConfigurationsTableTableManager(_db, _db.configurations);
  $$HourValuePoliticsTableTableManager get hourValuePolitics =>
      $$HourValuePoliticsTableTableManager(_db, _db.hourValuePolitics);
  $$WorkTableTableManager get work => $$WorkTableTableManager(_db, _db.work);
}
