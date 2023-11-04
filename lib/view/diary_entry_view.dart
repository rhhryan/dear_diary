import 'package:cars/view/diary_log_view.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../controller/diary_controller.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../model/diary_entry_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';

class DiaryView extends StatefulWidget {
  const DiaryView({super.key});

  @override
  State<DiaryView> createState() => _DiaryViewState();
}

class _DiaryViewState extends State<DiaryView> {
  final DiaryController diaryController = DiaryController();

  Future<void>? generatePDF(List<DayEntry> diaries) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: diaries.map((entry) {
              return pw.Container(
                margin: pw.EdgeInsets.only(bottom: 20),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Date: ${entry.date.toLocal().toString()}'),
                    pw.Text('Description: ${entry.description}'),
                    pw.Text('Rating: ${entry.rating}'),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
    final tempDir = await getTemporaryDirectory();
    final pdfFile = File('${tempDir.path}/diary_entries.pdf');
    await pdfFile.writeAsBytes(await pdf.save());
    await OpenFile.open(pdfFile.path);
  }

  @override
  Widget build(BuildContext context) {
    var diaries = diaryController.getAllEntry();
    diaries.sort((a, b) => b.date.compareTo(a.date));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dear Diaries'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => logDiary(
                          onDiaryAdded: () {
                            setState(() {});
                          },
                        )),
              );
            },
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            color: Colors.white,
            iconSize: 32.0,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: diaries.length,
        itemBuilder: (context, i) {
          DayEntry entry = diaries[i];
          if (i == 0 ||
              entry.date.month != diaries[i - 1].date.month ||
              entry.date.year != diaries[i - 1].date.year) {
            return Column(
              children: [
                ListTile(
                  title: Text('${DateFormat('MMMM yyyy').format(entry.date)}'),
                ),
                ListTile(
                  titleTextStyle: Theme.of(context).textTheme.headlineSmall,
                  subtitleTextStyle: Theme.of(context).textTheme.bodyLarge,
                  title: Row(
                    children: [
                      Text(
                          "${DateFormat('E, MMM dd').format(diaries[i].date)}"),
                      RatingBar.builder(
                          initialRating: diaries[i]
                              .rating, // Initial rating, you can set it as needed.
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 15.0,
                          itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                          onRatingUpdate: (rating) {}),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Text("${diaries[i].description}"),
                      //if (diaries[i].imagePath.isNotEmpty) {;},
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      var diaries_copy = diaryController.getAllEntry();
                      for (var x = 0; x < diaries_copy.length; x++)
                        if (diaries[i].date == diaries_copy[x].date)
                          diaryController.deleteEntry(x);
                      setState(() {
                        //diaries.removeAt(i);
                      });
                    },
                  ),
                )
              ],
            );
          }
          return ListTile(
            titleTextStyle: Theme.of(context).textTheme.headlineSmall,
            subtitleTextStyle: Theme.of(context).textTheme.bodyLarge,
            title: Row(
              children: [
                Text("${DateFormat('E, MMM dd').format(diaries[i].date)}"),
                RatingBar.builder(
                    initialRating: diaries[i]
                        .rating, // Initial rating, you can set it as needed.
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 15.0,
                    itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                    onRatingUpdate: (rating) {}),
              ],
            ),
            subtitle: Text("\ ${diaries[i].description}"),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                var diaries_copy = diaryController.getAllEntry();
                for (var x = 0; x < diaries_copy.length; x++)
                  if (diaries[i].date == diaries_copy[x].date)
                    diaryController.deleteEntry(x);
                setState(() {});
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          generatePDF(diaryController.getAllEntry());
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
