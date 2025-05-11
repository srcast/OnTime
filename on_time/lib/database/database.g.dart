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
  static const VerificationMeta _entradaMeta = const VerificationMeta(
    'entrada',
  );
  @override
  late final GeneratedColumn<DateTime> entrada = GeneratedColumn<DateTime>(
    'entrada',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saidaMeta = const VerificationMeta('saida');
  @override
  late final GeneratedColumn<DateTime> saida = GeneratedColumn<DateTime>(
    'saida',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _horasTrabalhadasMeta = const VerificationMeta(
    'horasTrabalhadas',
  );
  @override
  late final GeneratedColumn<double> horasTrabalhadas = GeneratedColumn<double>(
    'horas_trabalhadas',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, entrada, saida, horasTrabalhadas];
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
    if (data.containsKey('entrada')) {
      context.handle(
        _entradaMeta,
        entrada.isAcceptableOrUnknown(data['entrada']!, _entradaMeta),
      );
    } else if (isInserting) {
      context.missing(_entradaMeta);
    }
    if (data.containsKey('saida')) {
      context.handle(
        _saidaMeta,
        saida.isAcceptableOrUnknown(data['saida']!, _saidaMeta),
      );
    }
    if (data.containsKey('horas_trabalhadas')) {
      context.handle(
        _horasTrabalhadasMeta,
        horasTrabalhadas.isAcceptableOrUnknown(
          data['horas_trabalhadas']!,
          _horasTrabalhadasMeta,
        ),
      );
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
      entrada:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}entrada'],
          )!,
      saida: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}saida'],
      ),
      horasTrabalhadas: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}horas_trabalhadas'],
      ),
    );
  }

  @override
  $PontosTable createAlias(String alias) {
    return $PontosTable(attachedDatabase, alias);
  }
}

class Ponto extends DataClass implements Insertable<Ponto> {
  final int id;
  final DateTime entrada;
  final DateTime? saida;
  final double? horasTrabalhadas;
  const Ponto({
    required this.id,
    required this.entrada,
    this.saida,
    this.horasTrabalhadas,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entrada'] = Variable<DateTime>(entrada);
    if (!nullToAbsent || saida != null) {
      map['saida'] = Variable<DateTime>(saida);
    }
    if (!nullToAbsent || horasTrabalhadas != null) {
      map['horas_trabalhadas'] = Variable<double>(horasTrabalhadas);
    }
    return map;
  }

  PontosCompanion toCompanion(bool nullToAbsent) {
    return PontosCompanion(
      id: Value(id),
      entrada: Value(entrada),
      saida:
          saida == null && nullToAbsent ? const Value.absent() : Value(saida),
      horasTrabalhadas:
          horasTrabalhadas == null && nullToAbsent
              ? const Value.absent()
              : Value(horasTrabalhadas),
    );
  }

  factory Ponto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ponto(
      id: serializer.fromJson<int>(json['id']),
      entrada: serializer.fromJson<DateTime>(json['entrada']),
      saida: serializer.fromJson<DateTime?>(json['saida']),
      horasTrabalhadas: serializer.fromJson<double?>(json['horasTrabalhadas']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entrada': serializer.toJson<DateTime>(entrada),
      'saida': serializer.toJson<DateTime?>(saida),
      'horasTrabalhadas': serializer.toJson<double?>(horasTrabalhadas),
    };
  }

  Ponto copyWith({
    int? id,
    DateTime? entrada,
    Value<DateTime?> saida = const Value.absent(),
    Value<double?> horasTrabalhadas = const Value.absent(),
  }) => Ponto(
    id: id ?? this.id,
    entrada: entrada ?? this.entrada,
    saida: saida.present ? saida.value : this.saida,
    horasTrabalhadas:
        horasTrabalhadas.present
            ? horasTrabalhadas.value
            : this.horasTrabalhadas,
  );
  Ponto copyWithCompanion(PontosCompanion data) {
    return Ponto(
      id: data.id.present ? data.id.value : this.id,
      entrada: data.entrada.present ? data.entrada.value : this.entrada,
      saida: data.saida.present ? data.saida.value : this.saida,
      horasTrabalhadas:
          data.horasTrabalhadas.present
              ? data.horasTrabalhadas.value
              : this.horasTrabalhadas,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ponto(')
          ..write('id: $id, ')
          ..write('entrada: $entrada, ')
          ..write('saida: $saida, ')
          ..write('horasTrabalhadas: $horasTrabalhadas')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entrada, saida, horasTrabalhadas);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ponto &&
          other.id == this.id &&
          other.entrada == this.entrada &&
          other.saida == this.saida &&
          other.horasTrabalhadas == this.horasTrabalhadas);
}

class PontosCompanion extends UpdateCompanion<Ponto> {
  final Value<int> id;
  final Value<DateTime> entrada;
  final Value<DateTime?> saida;
  final Value<double?> horasTrabalhadas;
  const PontosCompanion({
    this.id = const Value.absent(),
    this.entrada = const Value.absent(),
    this.saida = const Value.absent(),
    this.horasTrabalhadas = const Value.absent(),
  });
  PontosCompanion.insert({
    this.id = const Value.absent(),
    required DateTime entrada,
    this.saida = const Value.absent(),
    this.horasTrabalhadas = const Value.absent(),
  }) : entrada = Value(entrada);
  static Insertable<Ponto> custom({
    Expression<int>? id,
    Expression<DateTime>? entrada,
    Expression<DateTime>? saida,
    Expression<double>? horasTrabalhadas,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entrada != null) 'entrada': entrada,
      if (saida != null) 'saida': saida,
      if (horasTrabalhadas != null) 'horas_trabalhadas': horasTrabalhadas,
    });
  }

  PontosCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? entrada,
    Value<DateTime?>? saida,
    Value<double?>? horasTrabalhadas,
  }) {
    return PontosCompanion(
      id: id ?? this.id,
      entrada: entrada ?? this.entrada,
      saida: saida ?? this.saida,
      horasTrabalhadas: horasTrabalhadas ?? this.horasTrabalhadas,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entrada.present) {
      map['entrada'] = Variable<DateTime>(entrada.value);
    }
    if (saida.present) {
      map['saida'] = Variable<DateTime>(saida.value);
    }
    if (horasTrabalhadas.present) {
      map['horas_trabalhadas'] = Variable<double>(horasTrabalhadas.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PontosCompanion(')
          ..write('id: $id, ')
          ..write('entrada: $entrada, ')
          ..write('saida: $saida, ')
          ..write('horasTrabalhadas: $horasTrabalhadas')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PontosTable pontos = $PontosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [pontos];
}

typedef $$PontosTableCreateCompanionBuilder =
    PontosCompanion Function({
      Value<int> id,
      required DateTime entrada,
      Value<DateTime?> saida,
      Value<double?> horasTrabalhadas,
    });
typedef $$PontosTableUpdateCompanionBuilder =
    PontosCompanion Function({
      Value<int> id,
      Value<DateTime> entrada,
      Value<DateTime?> saida,
      Value<double?> horasTrabalhadas,
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

  ColumnFilters<DateTime> get entrada => $composableBuilder(
    column: $table.entrada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get saida => $composableBuilder(
    column: $table.saida,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get horasTrabalhadas => $composableBuilder(
    column: $table.horasTrabalhadas,
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

  ColumnOrderings<DateTime> get entrada => $composableBuilder(
    column: $table.entrada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get saida => $composableBuilder(
    column: $table.saida,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get horasTrabalhadas => $composableBuilder(
    column: $table.horasTrabalhadas,
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

  GeneratedColumn<DateTime> get entrada =>
      $composableBuilder(column: $table.entrada, builder: (column) => column);

  GeneratedColumn<DateTime> get saida =>
      $composableBuilder(column: $table.saida, builder: (column) => column);

  GeneratedColumn<double> get horasTrabalhadas => $composableBuilder(
    column: $table.horasTrabalhadas,
    builder: (column) => column,
  );
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
                Value<DateTime> entrada = const Value.absent(),
                Value<DateTime?> saida = const Value.absent(),
                Value<double?> horasTrabalhadas = const Value.absent(),
              }) => PontosCompanion(
                id: id,
                entrada: entrada,
                saida: saida,
                horasTrabalhadas: horasTrabalhadas,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime entrada,
                Value<DateTime?> saida = const Value.absent(),
                Value<double?> horasTrabalhadas = const Value.absent(),
              }) => PontosCompanion.insert(
                id: id,
                entrada: entrada,
                saida: saida,
                horasTrabalhadas: horasTrabalhadas,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PontosTableTableManager get pontos =>
      $$PontosTableTableManager(_db, _db.pontos);
}
