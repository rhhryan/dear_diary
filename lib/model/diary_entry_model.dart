import 'package:hive/hive.dart';

part 'diary_entry_model.g.dart';

@HiveType(typeId: 0)
class DayEntry extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  String description;

  @HiveField(2)
  double rating;

  @HiveField(3)
  String imagePath;

  DayEntry(
      {required this.date,
      required this.description,
      required this.rating,
      required this.imagePath});
}
