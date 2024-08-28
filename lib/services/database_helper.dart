// Import the plugins Path provider and SQLite.
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:techassesment/data/Beneficiary.dart';
import 'package:techassesment/data/Recharge.dart';
import 'package:techassesment/data/UserInfoModel.dart';

// Import UserModel
class DatabaseHelper {
  // SQLite database instance
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  // Database name and version
  static const String databaseName = 'database.db';

  // Set the version. This executes the onCreate function and provides a
  // path to perform database upgrades and downgrades.
  static const int versionNumber = 1;

  // Table name
  static const String tableUserInfo = 'UserInfo';

  // Table name Beneficiary
  static const String tableBeneficiary = 'BeneficiaryTable';

  // Table name Beneficiary
  static const String tableRecharge = 'RechargeTable';

  // Table (UsersInfo) Columns
  static const String colId = 'id';
  static const String colName = 'name';
  static const String colNumber = 'number';
  static const String colStatus = 'status';
  static const String colCredit = 'credit';
  static const String colUserID = 'userid';

  static const String colBeneficiaryID = 'benid';

  static const String colRechargeAmount = 'amount';
  static const String colRechargeDate = 'date';

  // Define a getter to access the database asynchronously.
  Future<Database> get database async {
    // If the database instance is already initialized, return it.
    if (_database != null) {
      return _database!;
    }

    // If the database instance is not initialized, call the initialization method.
    _database = await _initDatabase();

    // Return the initialized database instance.
    return _database!;
  }

  _initDatabase() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();

    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    String path = join(documentsDirectory.path, databaseName);
    // When the database is first created, create a table to store Notes.
    var db =
        await openDatabase(path, version: versionNumber, onCreate: _onCreate);
    return db;
  }

  // Run the CREATE TABLE statement on the database.
  _onCreate(Database db, int intVersion) async {
    await db.execute("CREATE TABLE IF NOT EXISTS $tableUserInfo ("
        " $colId INTEGER PRIMARY KEY AUTOINCREMENT, "
        " $colName TEXT NOT NULL, "
        " $colCredit REAL NOT NULL default 0.0, "
        " $colStatus TEXT, "
        " $colNumber TEXT"
        ")");

    // Beneficiary Table
    await db.execute("CREATE TABLE IF NOT EXISTS $tableBeneficiary ("
        " $colId INTEGER PRIMARY KEY AUTOINCREMENT, "
        " $colName TEXT NOT NULL, "
        " $colUserID INTEGER , "
        " $colNumber TEXT"
        ")");

    // Recharge Table Table

    await db.execute("CREATE TABLE IF NOT EXISTS $tableRecharge ("
        " $colId INTEGER PRIMARY KEY AUTOINCREMENT, "
        " $colUserID INTEGER, "
        " $colBeneficiaryID INTEGER , "
        " $colCredit REAL NOT NULL default 0.0,"
        " $colRechargeDate TEXT"
        ")");
  }

  Future<List<UserInfoModel>> getAllUsers() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Notes. {SELECT * FROM Notes ORDER BY Id ASC}
    final result = await db.query(tableUserInfo, orderBy: '$colId ASC');

    // Convert the List<Map<String, dynamic> into a List<Note>.
    return result.map((json) => UserInfoModel.fromJson(json)).toList();
  }

  Future<List<Recharge>> getAllRecharge(int? userid) async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Notes. {SELECT * FROM Notes ORDER BY Id ASC}
    final result = await db.query(tableRecharge, orderBy: '$colId ASC');

    // Convert the List<Map<String, dynamic> into a List<Note>.
    return result.map((json) => Recharge.fromJson(json)).toList();
  }

  Future<List<Beneficiary>> getAllBeneficiary(int? userid) async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Notes. {SELECT * FROM Notes ORDER BY Id ASC}
    final result = await db.query(
      tableBeneficiary,
      where: '$colUserID = ?',
      whereArgs: [userid],
    );
    return result.map((json) => Beneficiary.fromJson(json)).toList();
  }

  // Serach note by Id
  Future<UserInfoModel> read(int id) async {
    final db = await database;
    final maps = await db.query(
      tableUserInfo,
      where: '$colId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return UserInfoModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  // Define a function that inserts Users into the database
  Future<void> insertUser(UserInfoModel note) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Note into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same Note is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(tableUserInfo, note.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Define a function that inserts Users into the database
  Future<void> insertRecharge(Recharge recharge) async {
    // Get a reference to the database.
    final db = await database;
    var res = await db.insert(tableRecharge, recharge.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Define a function that inserts notes into the database
  Future<void> insertBeneficiary(Beneficiary note) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Note into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same Note is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(tableBeneficiary, note.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Define a function to update a note
  Future<int> addMoneyToUser(UserInfoModel userinfo) async {
    final db = await database;

    // Update the given Note.
    var res = await db.update(tableUserInfo, userinfo.toJson(),
        // Ensure that the Note has a matching id.
        where: '$colId = ?',
        // Pass the Note's id as a whereArg to prevent SQL injection.
        whereArgs: [userinfo.id]);
    return res;
  }

  // Define a function to delete a note
  Future<void> delete(int id) async {
    // Get a reference to the database.
    final db = await database;
    try {
      // Remove the Note from the database.
      await db.delete(tableUserInfo,
          // Use a `where` clause to delete a specific Note.
          where: "$colId = ?",
          // Pass the Dog's id as a whereArg to prevent SQL injection.
          whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
