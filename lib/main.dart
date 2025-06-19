import 'package:flutter/material.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive init
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(UserModelAdapter()); // to be created

  await Hive.openBox('authBox');

  // Setup DI
  await setupLocator(); // you will define this in service_locator

  runApp(const App());
}
