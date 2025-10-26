import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

import 'models/wow_set.dart';
import 'models/wow_card.dart';

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
      instant BOOLEAN,
      subtype TEXT,
      block INTEGER,
      image TEXT,
      version TEXT,
      artist TEXT,
      flavour TEXT
    )""");

    await seed(db);
  }

  static Future<void> seed(Database db) async {
    final sets = jsonDecode(await rootBundle.loadString('data/setlist.json'));
    for (final set in sets.entries) {
      debugPrint('Seeding set ${set.value['setname']}');
      await db.insert('wow_sets', {
        'id': set.key,
        'name': set.value['setname'],
        'block': set.value['block'],
      });

      final cards = jsonDecode(
        await rootBundle.loadString('data/cards/${set.key}.json'),
      );

      for (final card in cards) {
        debugPrint('Seeding card ${card['name']}');
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
          'instant': card.containsKey('instant'),
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
}
