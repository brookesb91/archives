import 'package:flutter/material.dart';

import 'database.dart';
import 'theme.dart';
import 'pages/home_page.dart';

class App extends StatelessWidget {
  final WoWDatabase database;

  const App({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Archives',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      routes: {'/': (context) => HomePage(database: database)},
    );
  }
}
