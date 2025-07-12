import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;
  static const String dbName = 'mindflash.db';

  static Future<Database> getInstance() async {
    if (_database != null) return _database!;
    String databasesPath = await getDatabasesPath();
    var path = databasesPath + dbName;
    _database = await openDatabase(path, onCreate: _onCreate, version: 1, onOpen: _onOpen, onUpgrade: _onUpgrade, onDowngrade: _onDowngrade);
    return _database!;
  }

  static void _onCreate(Database db, int version) async {
    debugPrint('Criando tabelas do banco de dados...');
    await db.execute('''
      CREATE TABLE deck (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        userEmail TEXT DEFAULT '',
        totalCards INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE card (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        deckId INTEGER NOT NULL,
        question TEXT NOT NULL,
        answer TEXT NOT NULL,
        consecutiveHits INTEGER DEFAULT 0,
        hidden INTEGER DEFAULT 0,
        FOREIGN KEY (deckId) REFERENCES decks(id) ON DELETE CASCADE
      )
    ''');
  }

  static void _onOpen(Database db) async {
    debugPrint('Banco de dados aberto.');
  }

  static void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint('Atualizando banco de dados de $oldVersion para $newVersion...');
  }

  static void _onDowngrade(Database db, int oldVersion, int newVersion) async {
    debugPrint('Fazendo downgrade da versão $oldVersion para $newVersion...');
  }

  



}