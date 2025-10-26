import 'package:flutter/material.dart';
import 'database.dart';
import 'pages/cards_page.dart';

class App extends StatelessWidget {
  final WoWDatabase database;

  const App({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Trade-Gothic',
        colorScheme: ColorScheme.light(
          primary: const Color(0xFFFFBA50),
          secondary: const Color(0xFF6E8581),
          surface: const Color(0xFFFEFEFE),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFFFFFFF),
          surfaceTintColor: Color(0xFFFFFFFF),
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: 'Trade-Gothic',
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFFFBA50),
          secondary: const Color(0xFF6E8581),
          surface: const Color(0xFF242424),
        ),
        appBarTheme: AppBarTheme(backgroundColor: Color(0xFF030303)),
      ),
      routes: {'/': (context) => CardsPage(database: database)},
    );
  }
}
