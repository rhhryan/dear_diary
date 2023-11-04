import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/diary_entry_model.dart';
import 'package:intl/intl.dart';

class DiaryController {
  var box = Hive.box('diary_box');
/** 
  void addEntry(DayEntry day) {
    box.add(day);
  }
*/

  Future<void> addEntry(DayEntry entry) async {
    final existingEntry = box.values.firstWhere(
      (e) =>
          DateFormat('yyyy-MM-dd').format(e.date) ==
          DateFormat('yyyy-MM-dd').format(entry.date),
      orElse: () => null,
    );

    if (existingEntry != null) {
      throw Exception("Entry already exists for this date.");
    } else {
      await box.add(entry);
    }
  }

  void deleteEntry(int index) {
    box.deleteAt(index);
  }

/** 
  Future<void> deleteEntry(int index) async {
    if (!box.containsKey(index)) {
      throw Exception("Entry does not exist.");
    }
    await box.deleteAt(index);
  }
*/
  List<DayEntry> getAllEntry() {
    return box.values.cast<DayEntry>().toList();
  }

/** 
  Future<void> addEntry(DayEntry entry) async {
    final existingEntry = _box.values.firstWhere(
      (e) => e.date.isAtSameMomentAs(entry.date),
      orElse: () => null,
    );
    if (existingEntry != null) {
      throw Exception("An entry for this date already exists.");
    }
    await _box.add(entry);
  }

  Future<void> removeEntry(int entryKey) async {
    if (!_box.containsKey(entryKey)) {
      throw Exception("Entry does not exist.");
    }
    await _box.delete(entryKey);
  }

  List<DayEntry> getAllEntries() {
    return _box.values.toList();
  }
*/
}
