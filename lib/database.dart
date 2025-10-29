import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:path/path.dart';

import 'models/wow_set.dart';
import 'models/wow_card.dart';
import 'models/wow_card_list.dart';

class WoWDatabase {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE wow_sets (id TEXT PRIMARY KEY, name TEXT, block INTEGER)',
    );

    await db.execute("""CREATE TABLE wow_cards (
      id INTEGER PRIMARY KEY,
      name TEXT, type TEXT,
      faction TEXT,
      setcode TEXT,
      setname TEXT,
      no INTEGER,
      rules TEXT,
      rarity TEXT,
      cost INTEGER,
      instant INTEGER,
      subtype TEXT,
      block INTEGER,
      image TEXT,
      version TEXT,
      artist TEXT,
      flavour TEXT
    )""");

    await db.execute("""CREATE TABLE wow_card_lists (
      id INTEGER PRIMARY KEY,
      name TEXT
    )""");

    await db.execute("""CREATE TABLE wow_card_lists_cards (
      id INTEGER PRIMARY KEY,
      list_id INTEGER,
      card_id INTEGER,
      FOREIGN KEY (list_id) REFERENCES wow_card_lists(id),
      FOREIGN KEY (card_id) REFERENCES wow_cards(id)
    )""");

    await seed(db);
  }

  static Future<void> seed(Database db) async {
    final sets = jsonDecode(await rootBundle.loadString('data/setlist.json'));
    for (final set in sets.entries) {
      await db.insert('wow_sets', {
        'id': set.key,
        'name': set.value['setname'],
        'block': set.value['block'],
      });

      final cards = jsonDecode(
        await rootBundle.loadString('data/cards/${set.key}.json'),
      );

      for (final card in cards) {
        await db.insert('wow_cards', {
          'id': card['cardid'],
          'name': card['name'],
          'type': card['type'],
          'faction': card['faction'],
          'setcode': card['setcode'],
          'setname': card['setname'],
          'no': card['no'],
          'rules': card['rules'],
          'rarity': card['rarity'],
          'cost': card['cost'],
          'instant': card.containsKey('instant') ? 1 : 0,
          'subtype': card['subtype'],
          'block': card['block'],
          'image': card['image'],
          'version': card['version'],
          'artist': card['artist'],
          'flavour': card['flavour'],
        });
      }
    }
  }

  static Future<WoWDatabase> open() async {
    return WoWDatabase._(
      db: await openDatabase(
        join(await getDatabasesPath(), 'wow_tcg.db'),
        onCreate: WoWDatabase.onCreate,
        version: 1,
      ),
    );
  }

  final Database db;

  WoWDatabase._({required this.db});

  Future<List<WoWSet>> sets() {
    return db
        .query('wow_sets', orderBy: 'block ASC, name ASC')
        .then((value) => value.map((e) => WoWSet.fromDb(e)).toList());
  }

  Future<List<WoWCard>> cards({
    String? where,
    List<String>? whereArgs,
    String? orderBy,
  }) {
    return db
        .query(
          'wow_cards',
          where: where,
          whereArgs: whereArgs,
          orderBy: orderBy,
        )
        .then((value) => value.map((e) => WoWCard.fromDb(e)).toList());
  }

  Future<List<WoWCardList>> lists() {
    return db
        .query('wow_card_lists', orderBy: 'name ASC')
        .then((value) => value.map((e) => WoWCardList.fromDb(e)).toList());
  }

  Future<List<WoWCard>> list(int id) {
    return db
        .rawQuery(
          'SELECT * FROM wow_cards WHERE id IN (SELECT card_id FROM wow_card_lists_cards WHERE list_id = ?)',
          [id],
        )
        .then((value) => value.map((e) => WoWCard.fromDb(e)).toList());
  }

  Future<void> addToList(int listId, int cardId) {
    return db.transaction((txn) async {
      await txn.insert('wow_card_lists_cards', {
        'list_id': listId,
        'card_id': cardId,
      });
    });
  }

  Future<void> removeFromList(int listId, int cardId) {
    return db.delete(
      'wow_card_lists_cards',
      where: 'list_id = ? AND card_id = ?',
      whereArgs: [listId, cardId],
    );
  }

  Future<int> addList(String name) {
    return db.insert('wow_card_lists', {'name': name});
  }

  Future<void> deleteList(int id) {
    return db.transaction((txn) async {
      await txn.delete(
        'wow_card_lists_cards',
        where: 'list_id = ?',
        whereArgs: [id],
      );
      await txn.delete('wow_card_lists', where: 'id = ?', whereArgs: [id]);
    });
  }
}
