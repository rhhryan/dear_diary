import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'model/diary_entry_model.dart';
import 'view/diary_entry_view.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DayEntryAdapter());
  await Hive.openBox('diary_box');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.orange[100],
        textTheme: GoogleFonts.emilysCandyTextTheme(),
      ),
      home: DiaryView(),
    );
  }
}
