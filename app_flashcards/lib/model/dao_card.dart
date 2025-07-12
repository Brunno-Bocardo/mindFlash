import 'package:app_flashcards/model/card.dart';
import 'package:sqflite/sqflite.dart';

class CardDao {
  static const String tableName = 'card';

  static Future<int> insertCard(Database db, Map<String, dynamic> card) async {
    return await db.insert(tableName, card);
  }

  static Future<int> updateCard(Database db, Flashcard card) async {
    return await db.update(
      tableName,
      card.toMap(),
      where: 'id = ?',
      whereArgs: [card.id],
    );
  }

  static Future<int> deleteCard(Database db, int id) async {
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Flashcard>> getAllCards(Database db) async {
    final maps = await db.query(tableName, orderBy: 'id ASC');
    return maps.map((map) => Flashcard.fromMap(map)).toList();
  }

  static Future<Flashcard?> getCardById(Database db, int id) async {
    final maps = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Flashcard.fromMap(maps.first);
    }
    return null;
  }

  static Future<List<Flashcard>> getAllCardsByDeckId(
    Database db,
    int deckId,
  ) async {
    final maps = await db.query(
      tableName,
      where: 'deckId = ?',
      whereArgs: [deckId],
      orderBy: 'id ASC',
    );
    return maps.map((map) => Flashcard.fromMap(map)).toList();
  }

  static Future<int> incrementConsecutiveHits(Database db, int cardId) async {
    return await db.rawUpdate(
      'UPDATE $tableName SET consecutiveHits = consecutiveHits + 1 WHERE id = ?',
      [cardId],
    );
  }

  static Future<int> resetConsecutiveHits(Database db, int cardId) async {
    return await db.rawUpdate(
      'UPDATE $tableName SET consecutiveHits = 0 WHERE id = ?',
      [cardId],
    );
  }

  static Future<int> resetConsecutiveHitsByDeckId(Database db, int deckId) async {
    return await db.rawUpdate(
      'UPDATE $tableName SET consecutiveHits = 0 WHERE deckId = ?',
      [deckId],
    );
  }

  static Future<int> hideCard(Database db, int cardId) async {
    return await db.rawUpdate(
      'UPDATE $tableName SET hidden = 1 WHERE id = ?',
      [cardId],
    );
  }

  static Future<int> showCard(Database db, int cardId) async {
    return await db.rawUpdate(
      'UPDATE $tableName SET hidden = 0 WHERE id = ?',
      [cardId],
    );
  }

  static Future<int> showAllCardsByDeckId(Database db, int deckId) async {
    return await db.rawUpdate(
      'UPDATE $tableName SET hidden = 0 WHERE deckId = ?',
      [deckId],
    );
  }

  static Future<List<Flashcard>> getVisibleCards(Database db, int deckId) async {
    final maps = await db.query(
      tableName,
      where: 'hidden = ? and deckId = ?',
      whereArgs: [0, deckId],
      orderBy: 'id ASC',
    );
    return maps.map((map) => Flashcard.fromMap(map)).toList();
  }
}
