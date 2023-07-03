// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorFlutterDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$FlutterDatabaseBuilder databaseBuilder(String name) =>
      _$FlutterDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$FlutterDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$FlutterDatabaseBuilder(null);
}

class _$FlutterDatabaseBuilder {
  _$FlutterDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$FlutterDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$FlutterDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<FlutterDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$FlutterDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$FlutterDatabase extends FlutterDatabase {
  _$FlutterDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  WaterDao? _waterDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `water_table` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `ml` INTEGER, `date` TEXT, `time` TEXT, `date_time` TEXT, `total` INTEGER)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  WaterDao get waterDao {
    return _waterDaoInstance ??= _$WaterDao(database, changeListener);
  }
}

class _$WaterDao extends WaterDao {
  _$WaterDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _waterDataInsertionAdapter = InsertionAdapter(
            database,
            'water_table',
            (WaterData item) => <String, Object?>{
                  'id': item.id,
                  'ml': item.ml,
                  'date': item.date,
                  'time': item.time,
                  'date_time': item.dateTime,
                  'total': item.total
                }),
        _waterDataDeletionAdapter = DeletionAdapter(
            database,
            'water_table',
            ['id'],
            (WaterData item) => <String, Object?>{
                  'id': item.id,
                  'ml': item.ml,
                  'date': item.date,
                  'time': item.time,
                  'date_time': item.dateTime,
                  'total': item.total
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<WaterData> _waterDataInsertionAdapter;

  final DeletionAdapter<WaterData> _waterDataDeletionAdapter;

  @override
  Future<List<WaterData>> getTodayDrinkWater(String date) async {
    return _queryAdapter.queryList(
        'SELECT * FROM water_table WHERE date = ?1 ORDER BY id DESC',
        mapper: (Map<String, Object?> row) => WaterData(
            id: row['id'] as int?,
            ml: row['ml'] as int?,
            date: row['date'] as String?,
            time: row['time'] as String?,
            dateTime: row['date_time'] as String?,
            total: row['total'] as int?),
        arguments: [date]);
  }

  @override
  Future<WaterData?> getTotalOfDrinkWater(String date) async {
    return _queryAdapter.query(
        'SELECT IFNULL(SUM(ml),0) as total FROM water_table WHERE date = ?1',
        mapper: (Map<String, Object?> row) => WaterData(
            id: row['id'] as int?,
            ml: row['ml'] as int?,
            date: row['date'] as String?,
            time: row['time'] as String?,
            dateTime: row['date_time'] as String?,
            total: row['total'] as int?),
        arguments: [date]);
  }

  @override
  Future<List<WaterData>> getTotalDrinkWaterAllDays(List<String> date) async {
    const offset = 1;
    final _sqliteVariablesForDate =
        Iterable<String>.generate(date.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryList(
        'SELECT *, (SELECT IFNULL(SUM(ml),0) FROM water_table WHERE date = wt2.date) as total FROM water_table as wt2 WHERE date IN(' +
            _sqliteVariablesForDate +
            ') GROUP BY date',
        mapper: (Map<String, Object?> row) => WaterData(id: row['id'] as int?, ml: row['ml'] as int?, date: row['date'] as String?, time: row['time'] as String?, dateTime: row['date_time'] as String?, total: row['total'] as int?),
        arguments: [...date]);
  }

  @override
  Future<WaterData?> getTotalDrinkWaterAverage(List<String> date) async {
    const offset = 1;
    final _sqliteVariablesForDate =
        Iterable<String>.generate(date.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.query(
        'SELECT *, IFNULL(SUM(ml),0) as total FROM water_table WHERE date IN(' +
            _sqliteVariablesForDate +
            ')',
        mapper: (Map<String, Object?> row) => WaterData(
            id: row['id'] as int?,
            ml: row['ml'] as int?,
            date: row['date'] as String?,
            time: row['time'] as String?,
            dateTime: row['date_time'] as String?,
            total: row['total'] as int?),
        arguments: [...date]);
  }

  @override
  Future<void> insertDrinkWater(WaterData waterData) async {
    await _waterDataInsertionAdapter.insert(
        waterData, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTodayDrinkWater(WaterData waterData) async {
    await _waterDataDeletionAdapter.delete(waterData);
  }
}
