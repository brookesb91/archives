import 'package:flutter/material.dart';

import '../../database.dart';
import '../../models/wow_card_list.dart';
import 'list_page.dart';

class ListsPage extends StatefulWidget {
  final WoWDatabase database;

  const ListsPage({super.key, required this.database});

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final formKey = GlobalKey<FormState>();

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Add List'),
              content: Form(
                key: formKey,
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty) {
                      widget.database.addList(value).then((id) {
                        if (context.mounted) {
                          setState(() {});
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('List added.')),
                          );
                        }
                      });
                    }
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() == true) {
                      formKey.currentState?.save();
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<WoWCardList>>(
        future: widget.database.lists(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final lists = snapshot.data!;
            return CustomScrollView(
              slivers: [
                SliverAppBar(title: Text('Lists')),
                if (lists.isNotEmpty)
                  SliverList.list(
                    children: [
                      for (final list in lists)
                        ListTile(
                          title: Text(
                            list.name,
                            style: TextStyle(fontFamily: 'Belwe-Bold'),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Delete List'),
                                  content: Text(
                                    'Are you sure you want to delete this list?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        widget.database
                                            .deleteList(list.id)
                                            .then((value) {
                                              if (context.mounted) {
                                                setState(() {});
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'List deleted.',
                                                    ),
                                                  ),
                                                );
                                              }
                                            });
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: Icon(Icons.delete),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListPage(
                                  list: list,
                                  database: widget.database,
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  )
                else
                  SliverFillRemaining(
                    child: Center(
                      child: Text('You haven\'t created any lists yet.'),
                    ),
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
