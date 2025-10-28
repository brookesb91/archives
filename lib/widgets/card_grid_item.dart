import 'package:flutter/material.dart';

import '../models/wow_card.dart';

class CardGridItem extends StatelessWidget {
  final WoWCard card;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const CardGridItem({
    super.key,
    required this.card,
    this.onTap,
    this.onLongPress,
  });

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

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(onTap: onTap, onLongPress: onLongPress, child: image),
    );
  }
}
