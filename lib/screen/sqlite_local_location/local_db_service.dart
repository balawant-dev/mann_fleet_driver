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
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE location_logs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            booking_id TEXT NOT NULL,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            date_time TEXT NOT NULL
          )
        ''');
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

    return db.insert('location_logs', {
      'booking_id': bookingId,
      'latitude': latitude,
      'longitude': longitude,
      'date_time': dateTime.toIso8601String(),
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

//
// Future<void> syncLocations(
//   String bookingId,
// ) async {
//   final locations =
//       await LocalDbService.instance
//           .getLocationsByBookingId(bookingId);
//
//   if (locations.isEmpty) return;
//
//   final payload = {
//     'booking_id': bookingId,
//     'locations': locations
//         .map((e) => e.toApiMap())
//         .toList(),
//   };
//
//   try {
//     final response = await dio.post(
//       '/location-sync',
//       data: payload,
//     );
//
//     if (response.statusCode == 200) {
//       await LocalDbService.instance.deleteLocationsByIds(
//         locations
//             .where((e) => e.id != null)
//             .map((e) => e.id!)
//             .toList(),
//       );
//     }
//   } catch (_) {}
// }
