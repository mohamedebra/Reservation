
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Sqldb {
  static Database? _db;
  static const String tableName = 'notes';
  static const String columnId = 'id';
  static const String columnTitleData = 'title';
  static const String columnNoteData = 'note';
  static const String columnImageData = 'image';
  List notes = [];
  bool inLoading = true;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDB();
      return _db;
    } else {
      return _db;
    }
  }

  intialDB() async {
    String sqlpath = await getDatabasesPath();
    String path = join(sqlpath, "sql.db");
    Database dp = await openDatabase(path,
        onCreate: _createDatabase, version: 2, onUpgrade: _onUpgrad,onOpen: (db){

        });
    return dp;
  }

  _onUpgrad(Database db, int oldversion, int newVersion) async {

    print('onUpgrad =======================');
    // await db.execute("ALTER TABLE notes ADD COLUMN color TEXT");
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        dateNow TEXT,
        nextDate TEXT,
        image TEXT

      )
      ''');
  }

  read(String table) async {
    Database? myDb = await db;
    List<Map> response = await myDb!.query(table);
    return response;
  }

  insert(String table, Map<String, Object?> values) async {
    Database? myDb = await db;
    int response = await myDb!.insert(table, values);
    return response;
  }

  Future<int?> insertNoteWithImage(
      {
        required String title,
      required String dateNow,
      required String nextDate,
      String? imageBytes = '/data/user/0/com.example.gem/cache/d009ba98-a222-434b-b26f-a9ac6bff29095900857166907679909.jpg',
      }) async {
    final myDb = await db;
    return await myDb?.insert(
      'notes',
      {
        'title': title,
        'dateNow': dateNow,
        'nextDate' : nextDate ,
        'image': imageBytes ,
      },
    );
  }

  Future readDate() async {

    List<Map> response = await read("notes");

    notes.addAll(response);
    inLoading = false;

    return response;
  }

  update(

  {required String table,
    required String title,
    required String dateNow,
    required String nextDate,
    String? imageBytes = '/data/user/0/com.example.gem/cache/d009ba98-a222-434b-b26f-a9ac6bff29095900857166907679909.jpg'
  ,
  where
}) async {
    Database? myDb = await db;
    int response = await myDb!.update(table, {
      'title': title,
      'dateNow': dateNow,
      'nextDate' : nextDate ,
      'image': imageBytes    },
        where: where);
    return response;
  }

  delete(String table, String? where) async {
    Database? myDb = await db;
    int response = await myDb!.delete(table, where: where);
    return response;
  }

  Future<List<Map<String, dynamic>>> searchNotes(String searchTerm) async {
    final Mydb = await db;
    final List<Map<String, dynamic>> results = await Mydb!.rawQuery('''
    SELECT * FROM notes WHERE title LIKE '%$searchTerm%'
  ''');

    return results;
  }
  Future<List<Map<String, dynamic>>> search(String query) async {
    final Mydb = await db;
    return Mydb!.query('notes', where: 'title LIKE ?', whereArgs: ['%$query%']);
  }
  Future close() async {
    var dbClient = await db;
    dbClient!.close();
  }

}
