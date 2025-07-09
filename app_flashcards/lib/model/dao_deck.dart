import 'package:sqflite/sqflite.dart';
import 'deck.dart';

class DeckDao {
  static const String tableName = 'deck';

  static Future<int> insertDeck(Database db, Map<String, dynamic> deck) async {
    return await db.insert(tableName, deck);
  }

  static Future<int> updateDeck(Database db, Deck deck) async {
    return await db.update(
      tableName,
      deck.toMap(),
      where: 'id = ?',
      whereArgs: [deck.id],
    );
  }

  static Future<int> deleteDeck(Database db, int id) async {
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Deck>> getAllDecks(Database db, ) async {
    final maps = await db.query(tableName, orderBy: 'name ASC');
    return maps.map((map) => Deck.fromMap(map)).toList();
  }

  static Future<Deck?> getDeckById(Database db, int id) async {
    final maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Deck.fromMap(maps.first);
    }
    return null;
  }

  static Future<List<Deck>> getAllDecksByEmail(Database db, String userEmail) async {
    final maps = await db.query(
      tableName,
      where: 'userEmail = ?',
      whereArgs: [userEmail],
      orderBy: 'name ASC',
    );
    return maps.map((map) => Deck.fromMap(map)).toList();
  }
}