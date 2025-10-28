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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.list.name)),
      body: FutureBuilder<List<WoWCard>>(
        future: widget.database.list(widget.list.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final cards = snapshot.data!;
            return CustomScrollView(
              slivers: [
                SliverList.list(
                  children: [
                    for (final card in cards)
                      CardListItem(
                        card: card,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CardPage(card: card),
                            ),
                          );
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Remove from List'),
                              content: Text(
                                'Are you sure you want to remove this card from this list?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    widget.database
                                        .removeFromList(widget.list.id, card.id)
                                        .then((value) {
                                          if (context.mounted) {
                                            setState(() {});
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Card removed from list.',
                                                ),
                                              ),
                                            );
                                          }
                                        });
                                  },
                                  child: Text('Remove'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
