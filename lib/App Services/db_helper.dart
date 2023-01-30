// import 'dart:html';

// import 'package:image_picker/image_picker.dart';
// import '../data_classes/constant.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

class DbHelper {
  static Database? _db;
  static int itemsInCart = 0;
  static double subtotalCart =0.0;

  static String tbc =
      "CREATE TABLE IF NOT EXISTS CartItems(id INTEGER PRIMARY KEY AUTOINCREMENT, docid TEXT, name TEXT, desc TEXT, quantity INTEGER, price TEXT, total TEXT)";

  static Future<Database?> dbConnection() async {
    _db = await openDatabase(
        join(
          await getDatabasesPath(),
          "cart.db",
        ), onCreate: ((db, version) async {
      // String tbc =
      //     "CREATE TABLE IF NOT EXISTS CartItems(id INTEGER PRIMARY KEY AUTOINCREMENT, docid TEXT, name TEXT, desc TEXT, quantity INTEGER, price TEXT, total TEXT)";
      return await db.execute(tbc);
    }), version: 1);

    return _db;
  }

  static Future<void> insertCart(Map<String, Object> data) async {
    Database db = await DbHelper.dbConnection() as Database;
    // String tbc =
    //     "CREATE TABLE IF NOT EXISTS CartItems(id INTEGER PRIMARY KEY AUTOINCREMENT, docid TEXT, name TEXT, desc TEXT, quantity INTEGER, price TEXT, total TEXT)";
    await db.execute(tbc);
    await db
        .insert('CartItems', data)
        .whenComplete(() => print("sql insert completed."));
  }

  static Future<List<Map<String, Object?>>> getCart() async {
    Database db = await DbHelper.dbConnection() as Database;
    return await db.query("CartItems");
  }

  static Future<bool> deleteTable() async {
    bool com = false;
    Database db = await DbHelper.dbConnection() as Database;
    await db
        .execute("DROP TABLE IF EXISTS CartItems")
        .whenComplete(() => com = true);
    print("Table Deleted");
    await db.execute(tbc);
    print("Table created");
    return com;
  }

  static Future<bool> incrimentItemPrice(
      String id, int quantity, String total) async {
    String query =
        "UPDATE CartItems SET quantity=$quantity , total=$total WHERE id=$id";
    bool isDone = false;
    Database db = await DbHelper.dbConnection() as Database;
    await db.rawUpdate(query).whenComplete(() {
      isDone = true;
    });
    return isDone;
  }

  static Future<bool> deleteRow(String id) async {
    String query = "DELETE FROM CartItems WHERE id=$id";
    bool isDone = false;
    Database db = await DbHelper.dbConnection() as Database;
    await db.rawDelete(query).whenComplete(() {
      isDone = true;
    });
    return isDone;
  }

  static Future<bool> decrementItemPrice(
      String id, int quantity, String total) async {
    String query =
        "UPDATE CartItems SET quantity=$quantity , total=$total WHERE id=$id";
    bool isDone = false;
    Database db = await DbHelper.dbConnection() as Database;
    await db.rawUpdate(query).whenComplete(() {
      isDone = true;
    });
    return isDone;
  }

  static Future<int> countItemsInCart() async {
    String query = "SELECT COUNT (*) from CartItems";
    int cnt;
    try {
      Database db = await DbHelper.dbConnection() as Database;
      var x = await db.rawQuery(query);
      int? count = Sqflite.firstIntValue(x);
      itemsInCart = count!;
      await DbHelper.calculateSubtotal();
    } catch (e) {
      itemsInCart = 0;
    }
    return itemsInCart;
  }

  static Future<double> calculateSubtotal() async {
    String query = "SELECT SUM(total) as SUBTOTAL FROM CartItems";
    Database db = await DbHelper.dbConnection() as Database;
    var x = await db.rawQuery(query);
    try {
      subtotalCart = double.parse(x[0]["SUBTOTAL"].toString());
    } catch (e) {
      subtotalCart = 0;
    }
    return subtotalCart;
  }

  static Future<int> getQtyItemCarted(String docId) async {
    String query = "SELECT quantity FROM CartItems WHERE docid=$docId";
    int qty;
    Database db = await DbHelper.dbConnection() as Database;
    var x = await db.rawQuery(query);
    try {
      qty = int.parse(x[0]["quantity"].toString());
    } catch (e) {
      qty = 0;
    }
    return qty;
  }
}
