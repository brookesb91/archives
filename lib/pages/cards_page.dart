import 'package:archives/models/wow_card_list.dart';
import 'package:flutter/material.dart';

import '../database.dart';
import '../models/wow_card.dart';
import '../models/wow_set.dart';
import '../pages/card_page.dart';
import '../widgets/card_grid_item.dart';
import '../widgets/card_list_item.dart';
import '../widgets/card_filters.dart';

enum CardViewType { grid, list }

class CardsPage extends StatefulWidget {
  final WoWDatabase database;

  const CardsPage({super.key, required this.database});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  List<WoWCard> _cards = [];
  List<WoWSet> _sets = [];
  String? _order = 'name';
  String? _where;
  String? _set;
  CardViewType _view = CardViewType.grid;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    widget.database.sets().then((value) {
      setState(() => _sets = value);
      _query();
    });
  }

  void _query() {
    widget.database
        .cards(
          orderBy: _order,
          where: (_set != null || _where != null)
              ? [
                  ...(_set != null
                      ? ['upper(setcode) = "${_set?.toUpperCase()}"']
                      : []),
                  ...(_set != null && _where != null ? ['AND'] : []),
                  ...(_where != null ? ['$_where'] : []),
                ].join(' ')
              : null,
        )
        .then((value) => setState(() => _cards = value));
  }

  void _navigate(BuildContext context, WoWCard card) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CardPage(card: card)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            centerTitle: false,
            title: Image.asset('icons/icon.png', width: 32, height: 32),
            actions: [
              if (_where != null || _set != null || _order != 'name')
                IconButton(
                  onPressed: () {
                    setState(() {
                      _order = 'name';
                      _where = null;
                      _set = null;
                      _query();
                    });
                  },
                  icon: Icon(Icons.clear),
                ),
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: Icon(Icons.filter_list),
                    selectedIcon: Icon(
                      Icons.filter_list,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    isSelected: _where != null,
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      builder: (context) => CardFilters(
                        onApply: (order, where) {
                          setState(() {
                            _order = order;
                            _where = where?.isNotEmpty == true ? where : null;
                            _query();
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                onPressed: () => setState(
                  () => _view = _view == CardViewType.grid
                      ? CardViewType.list
                      : CardViewType.grid,
                ),
                icon: Icon(
                  _view == CardViewType.list ? Icons.grid_view : Icons.list,
                ),
              ),
            ],
            // Add set chips to the `bottom` of the app bar
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(56),
              child: SizedBox(
                height: 56,
                child: CustomScrollView(
                  scrollDirection: Axis.horizontal,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      sliver: SliverList.builder(
                        itemCount: _sets.length,
                        itemBuilder: (context, index) {
                          final set = _sets[index];

                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(
                                '${set.name} (${set.id.toUpperCase()}) [${set.block}]',
                              ),
                              onSelected: (selected) {
                                setState(() {
                                  _set = selected ? set.id : null;
                                  _query();
                                });
                              },
                              selected: _set == set.id,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          switch (_view) {
            CardViewType.grid => SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  crossAxisCount: 3,
                  childAspectRatio: 250 / 350,
                ),
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  final card = _cards[index];
                  return CardGridItem(
                    card: card,
                    onTap: () => _navigate(context, card),
                    onLongPress: () => _showListBottomSheet(context, card),
                  );
                },
              ),
            ),
            CardViewType.list => SliverList.builder(
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                final card = _cards[index];
                return CardListItem(
                  card: card,
                  onTap: () => _navigate(context, card),
                  onLongPress: () => _showListBottomSheet(context, card),
                );
              },
            ),
          },
        ],
      ),
    );
  }

  Future<void> _showListBottomSheet(BuildContext context, WoWCard card) {
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => FutureBuilder<List<WoWCardList>>(
        future: widget.database.lists(),
        builder: (context, snapshot) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(title: Text('Add to List')),
              if (snapshot.hasData)
                SliverList.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final list = snapshot.data![index];
                    return ListTile(
                      title: Text(
                        list.name,
                        style: TextStyle(fontFamily: 'Belwe-Bold'),
                      ),
                      trailing: Icon(Icons.add),
                      onTap: () => widget.database
                          .addToList(list.id, card.id)
                          .then((value) {
                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Card added to ${list.name}'),
                                ),
                              );
                            }
                          }),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
