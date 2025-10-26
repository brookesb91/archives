import 'package:flutter/material.dart';

class CardFilters extends StatefulWidget {
  final Function(String? orderBy, String? where) onApply;

  const CardFilters({super.key, required this.onApply});

  @override
  State<CardFilters> createState() => _CardFiltersState();
}

class _CardFiltersState extends State<CardFilters> {
  String _order = 'name';
  String? _faction;
  String? _type;
  String? _rarity;

  final List<(String key, String label)> _orderings = [
    ('name', 'Name'),
    ('setname', 'Set'),
    ('rarity', 'Rarity'),
    ('type', 'Type'),
    ('faction', 'Faction'),
    ('subtype', 'Subtype'),
    ('block', 'Block'),
  ];

  final List<(String key, String label)> _factions = [
    ('Alliance', 'Alliance'),
    ('Horde', 'Horde'),
    ('Neutral', 'Neutral'),
  ];

  final List<(String key, String label)> _types = [
    ('Ally', 'Ally'),
    ('Ability', 'Ability'),
    ('Equipment', 'Equipment'),
    ('Quest', 'Quest'),
    ('Location', 'Location'),
    ('Hero', 'Hero'),
  ];

  final List<(String key, String label)> _rarities = [
    ('c', 'Common'),
    ('u', 'Uncommon'),
    ('r', 'Rare'),
    ('e', 'Epic'),
    ('p', 'Promo'),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order', style: TextStyle(fontFamily: 'Belwe-Bold')),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _orderings
                          .map(
                            (option) => ChoiceChip(
                              selected: _order == option.$1,
                              label: Text(option.$2),
                              onSelected: (selected) {
                                setState(() {
                                  _order = option.$1;
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Faction', style: TextStyle(fontFamily: 'Belwe-Bold')),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _factions
                          .map(
                            (option) => ChoiceChip(
                              selected: _faction == option.$1,
                              label: Text(option.$2),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _faction = option.$1;
                                  } else {
                                    _faction = null;
                                  }
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Type', style: TextStyle(fontFamily: 'Belwe-Bold')),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _types
                          .map(
                            (option) => ChoiceChip(
                              selected: _type == option.$1,
                              label: Text(option.$2),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _type = option.$1;
                                  } else {
                                    _type = null;
                                  }
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rarity', style: TextStyle(fontFamily: 'Belwe-Bold')),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _rarities
                          .map(
                            (option) => ChoiceChip(
                              selected: _rarity == option.$1,
                              label: Text(option.$2),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _rarity = option.$1;
                                  } else {
                                    _rarity = null;
                                  }
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onApply(
                      _order,
                      [
                        ..._faction != null ? ['faction = "$_faction"'] : [],
                        ..._type != null ? ['type = "$_type"'] : [],
                        ..._rarity != null ? ['rarity = "$_rarity"'] : [],
                      ].join(' AND '),
                    );
                  },
                  child: Text(
                    'Apply',
                    style: TextStyle(fontFamily: 'Belwe-Bold'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
