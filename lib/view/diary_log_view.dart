import 'package:flutter/material.dart';
import '../controller/diary_controller.dart';
import '../model/diary_entry_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';

class logDiary extends StatefulWidget {
  final Function onDiaryAdded;

  const logDiary({super.key, required this.onDiaryAdded});

  @override
  State<logDiary> createState() => _logDiaryState();
}

class _logDiaryState extends State<logDiary> {
  //final dateController = DateTime.now();
  final descriptionController = TextEditingController();
  //final ratingController = TextEditingController();
  double _rating = 1.0;
  DateTime _dateTime = DateTime.now();
  String _imagePath = '';

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((value) {
      setState(() {
        _dateTime = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final DiaryController diaryController = DiaryController();
    return Scaffold(
      appBar: AppBar(title: const Text('Add diary entry')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                  controller: descriptionController,
                  maxLength: 140,
                  maxLines: 5,
                  decoration: InputDecoration(
                      labelText: 'Description',
                      helperText: 'Describe your day in 14 characters')),
              SizedBox(height: 10),
              /** 
            TextField(
                controller: ratingController,
                decoration: InputDecoration(labelText: 'rating(1-5)')),
            */

              Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        ImagePicker().pickImage(source: ImageSource.gallery);
                      },
                      child: Text('Pick an image')),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Rate your day: '),
                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 25,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Date: '),
                  ElevatedButton(
                      onPressed: () {
                        _showDatePicker();
                      },
                      child: Text(DateFormat('yyyy-MM-dd')
                          .format(_dateTime)
                          .toString())),
                  Icon(Icons.edit_calendar_outlined)
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    String des = descriptionController.text;
                    //String rat = ratingController.text;
                    if (des.length <= 140) {
                      var entry = DayEntry(
                        date: _dateTime,
                        description: descriptionController.text,
                        rating: _rating,
                        imagePath: _imagePath,
                      );
                      diaryController.addEntry(entry);
                      setState(() {
                        //dateController.clear();
                        descriptionController.clear();
                        _rating = 1.0;
                      });
                      widget.onDiaryAdded?.call();
                      Navigator.pop(context);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('Save Entry'),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
