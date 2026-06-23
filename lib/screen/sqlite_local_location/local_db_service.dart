import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'model.dart';

class LocalDbService {
  LocalDbService._();

  static final LocalDbService instance = LocalDbService._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();

    return openDatabase(
      join(dbPath, 'app_database.db'),
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
      CREATE TABLE location_logs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        booking_id TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        date_time TEXT NOT NULL,
        distance_from_prev REAL DEFAULT 0,
        cumulative_distance REAL DEFAULT 0
      )
    ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE location_logs ADD COLUMN distance_from_prev REAL DEFAULT 0',
          );

          await db.execute(
            'ALTER TABLE location_logs ADD COLUMN cumulative_distance REAL DEFAULT 0',
          );
        }
      },
    );
  }

  /// Save Location
  Future<int> saveLocation({
    required String bookingId,
    required double latitude,
    required double longitude,
    required DateTime dateTime,
  }) async {
    final db = await database;

    double distanceFromPrev = 0;
    double cumulativeDistance = 0;

    final lastLocation = await getLatestLocationByBookingId(bookingId);

    if (lastLocation != null) {
      distanceFromPrev = Geolocator.distanceBetween(
        lastLocation.latitude,
        lastLocation.longitude,
        latitude,
        longitude,
      );

      // Ignore GPS spikes
      if (distanceFromPrev < 5) {
        distanceFromPrev = 0;
      }

      if (distanceFromPrev > 1000) {
        distanceFromPrev = 0;
      }

      cumulativeDistance = lastLocation.cumulativeDistance + distanceFromPrev;
    }

    return db.insert('location_logs', {
      'booking_id': bookingId,
      'latitude': latitude,
      'longitude': longitude,
      'date_time': dateTime.toIso8601String(),
      'distance_from_prev': distanceFromPrev,
      'cumulative_distance': cumulativeDistance,
    });
  }

  Future<List<LocationLog>> getLocationsByBookingId(String bookingId) async {
    final db = await database;

    final result = await db.query(
      'location_logs',
      where: 'booking_id = ?',
      whereArgs: [bookingId],
      orderBy: 'id ASC',
    );

    return result.map(LocationLog.fromMap).toList();
  }

  Future<LocationLog?> getLatestLocationByBookingId(String bookingId) async {
    final db = await database;

    final result = await db.query(
      'location_logs',
      where: 'booking_id = ?',
      whereArgs: [bookingId],
      orderBy: 'id ASC',
    );

    if (result.isEmpty) return null;

    return LocationLog.fromMap(result.first);
  }

  Future<double> getTotalDistance(String bookingId) async {
    final last = await getLatestLocationByBookingId(bookingId);

    return last?.cumulativeDistance ?? 0;
  }

  /// Get All Locations
  Future<List<LocationLog>> getAllLocations() async {
    final db = await database;

    final result = await db.query('location_logs', orderBy: 'id DESC');

    return result.map(LocationLog.fromMap).toList();
  }

  /// Get Latest Location
  Future<LocationLog?> getLatestLocation() async {
    final db = await database;

    final result = await db.query(
      'location_logs',
      orderBy: 'id DESC',
      limit: 1,
    );

    if (result.isEmpty) return null;

    return LocationLog.fromMap(result.first);
  }

  /// Clear All Records
  Future<void> clearLocations() async {
    final db = await database;
    await db.delete('location_logs');
  }

  Future<void> deleteLocationsByIds(List<int> ids) async {
    if (ids.isEmpty) return;

    final db = await database;

    final placeholders = List.filled(ids.length, '?').join(',');

    await db.delete(
      'location_logs',
      where: 'id IN ($placeholders)',
      whereArgs: ids,
    );
  }

  /// Delete Database Completely
  Future<void> clearDatabase() async {
    final dbPath = await getDatabasesPath();

    await deleteDatabase(join(dbPath, 'app_database.db'));

    _database = null;
  }
}
