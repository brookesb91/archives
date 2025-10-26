import 'package:flutter/material.dart';

import '../models/wow_card.dart';

class CardListItem extends StatelessWidget {
  final WoWCard card;
  final VoidCallback onTap;

  const CardListItem({super.key, required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final image = Image.network(
      'https://wow.tcgbrowser.com/images/cards/hd/${card.image}.jpg',
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
    );

    final background = Theme.of(context).colorScheme.surface;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            switch (card.type) {
              'Ally' || 'Hero' || 'Master Hero' => switch (card.faction) {
                'Alliance' => Colors.blue,
                'Horde' => Colors.red,
                'Neutral' => Color(0xFFF6E700),
                _ => background,
              },
              'Ability' => Colors.purple,
              'Equipment' => Colors.grey,
              'Quest' => Color(0xFFCC9933),
              'Location' => Color(0xFF40BC40),
              _ => background,
            }.withValues(alpha: 0.01),
            background,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ListTile(
        title: Text(card.name, style: TextStyle(fontFamily: 'Belwe-Bold')),
        subtitle: Text(card.setname),
        leading: AspectRatio(aspectRatio: 250 / 350, child: image),
        onTap: onTap,
      ),
    );
  }
}
