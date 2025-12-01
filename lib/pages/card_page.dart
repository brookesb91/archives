import 'package:flutter/material.dart';

import '../database.dart';
import '../models/wow_card.dart';

class CardPage extends StatelessWidget {
  final WoWCard card;
  final WoWDatabase database;

  const CardPage({super.key, required this.card, required this.database});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(card.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              margin: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              clipBehavior: Clip.hardEdge,
              child: AspectRatio(
                aspectRatio: 250 / 350,
                child: Image.network(
                  'https://wow.tcgbrowser.com/images/cards/vhd/${card.image}.png',
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      decoration: BoxDecoration(color: Colors.grey[800]),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    decoration: BoxDecoration(color: Colors.grey[800]),
                    child: Center(child: Icon(Icons.error)),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            _SimilarCards(
              database: database,
              query:
                  'subtype = "${card.subtype}" AND id != ${card.id} AND block = ${card.block} AND faction = "${card.faction}"',
              title: 'More ${card.subtype} Cards',
            ),
            _SimilarCards(
              database: database,
              query:
                  'type = "${card.type}" AND id != ${card.id} AND block = ${card.block} AND faction = "${card.faction}"',
              title: 'More ${card.type} Cards',
            ),
            _SimilarCards(
              database: database,
              query:
                  'setcode = "${card.setcode}" AND id != ${card.id} AND no > ${card.no}',
              title: 'More from ${card.setname}',
            ),
          ],
        ),
      ),
    );
  }
}

class _SimilarCards extends StatelessWidget {
  final WoWDatabase database;
  final String title;
  final String query;

  const _SimilarCards({
    required this.database,
    required this.query,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: database.cards(where: query, limit: 20),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final cards = snapshot.data as List<WoWCard>;
          if (cards.isEmpty) {
            return SizedBox.shrink();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CardPage(card: card, database: database),
                            ),
                          );
                        },
                        child: AspectRatio(
                          aspectRatio: 100 / 140,
                          child: Image.network(
                            'https://wow.tcgbrowser.com/images/cards/vhd/${card.image}.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
