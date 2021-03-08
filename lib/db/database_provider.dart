import 'package:CWCFlutter/model/link.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProvider {
  static const String TABLE_LINK = "link";
  static const String COLUMN_ID = "id";
  static const String COLUMN_TITLE = "title";
  static const String COLUMN_URL = "url";
  static const String COLUMN_IMP = "date";

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    print("database getter called");

    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'linkDB.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creating link table");

        await database.execute(
          "CREATE TABLE $TABLE_LINK ("
          "$COLUMN_ID INTEGER PRIMARY KEY,"
          "$COLUMN_TITLE TEXT,"
          "$COLUMN_URL TEXT,"
          "$COLUMN_IMP INTEGER"
          ")",
        );
      },
    );
  }

  Future<List<Link>> getLinks() async {
    final db = await database;

    var links = await db.query(TABLE_LINK,
        columns: [COLUMN_ID, COLUMN_TITLE, COLUMN_URL, COLUMN_IMP]);

    List<Link> linkList = List<Link>();

    links.forEach((currentLink) {
      Link link = Link.fromMap(currentLink);

      linkList.add(link);
    });

    return linkList;
  }

  Future<Link> insert(Link link) async {
    final db = await database;
    link.id = await db.insert(TABLE_LINK, link.toMap());
    return link;
  }

  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(
      TABLE_LINK,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(Link link) async {
    final db = await database;

    return await db.update(
      TABLE_LINK,
      link.toMap(),
      where: "id = ?",
      whereArgs: [link.id],
    );
  }
}
