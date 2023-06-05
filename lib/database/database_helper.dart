import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'product.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    //Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = 'database.db';
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<List<Product>> getProducts() async {
    Database db = await instance.database;

    var products = await db.query('PRODUCTS',orderBy: 'NAME');
    
    List<Product> productList = products.isNotEmpty ?
    products.map((x) => Product.fromMap(x)).toList() : [];

    return productList;
  }

  Future<int> addProduct(Product product) async {
    Database db = await instance.database;
    return await db.insert('products', product.toMap());
  }

  Future _onCreate(Database db, int version) async {
    await db.execute("""
  CREATE TABLE "PRODUCTS" (
	"EAN"	TEXT NOT NULL UNIQUE,
	"NAME"	TEXT NOT NULL,
	"INGREDIENTS"	TEXT NOT NULL,
	PRIMARY KEY("EAN")
  );""");
    await db.execute("""
  CREATE TABLE HARMFUL_INGREDIENTS (
	ID INTEGER PRIMARY KEY AUTOINCREMENT,
	NAME TEXT,
	DESCRIPTION TEXT
  );""");
    await db.execute("""
  CREATE TABLE SETTINGS (
	ID INTEGER PRIMARY KEY AUTOINCREMENT,
	NAME TEXT,
	VALUE INTEGER
);""");
  }
}
