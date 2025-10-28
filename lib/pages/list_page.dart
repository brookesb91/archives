import 'package:archives/models/wow_card.dart';
import 'package:archives/widgets/card_list_item.dart';
import 'package:flutter/material.dart';

import '../models/wow_card_list.dart';
import '../pages/card_page.dart';
import '../database.dart';

class ListPage extends StatefulWidget {
  final WoWCardList list;
  final WoWDatabase database;

  const ListPage({super.key, required this.list, required this.database});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<WoWCard> _cards = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    widget.database.list(widget.list.id).then((value) {
      if (context.mounted) {
        setState(() => _cards = value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.list.name)),
      body: CustomScrollView(
        slivers: [
          SliverList.list(
            children: [
              for (final card in _cards)
                CardListItem(
                  card: card,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CardPage(card: card),
                      ),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
