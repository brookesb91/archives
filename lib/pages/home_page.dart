import 'package:flutter/material.dart';

import '../database.dart';
import 'cards_page.dart';
import 'lists_page.dart';

class HomePage extends StatefulWidget {
  final WoWDatabase database;

  const HomePage({super.key, required this.database});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Cards',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Lists'),
        ],
        currentIndex: _index,
        onTap: (index) => setState(() => _index = index),
      ),
      body: IndexedStack(
        index: _index,
        children: [
          CardsPage(database: widget.database),
          ListsPage(database: widget.database),
        ],
      ),
    );
  }
}
