import 'package:flutter/material.dart';

import 'database.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await WoWDatabase.open();

  runApp(App(database: database));
}
