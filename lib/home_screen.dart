import 'dart:developer';

import 'package:flutter/material.dart';
import 'notification/notification_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({this.payload, Key? key}) : super(key: key);

  final String? payload;

  final ksnackBar = const SnackBar(
    content: Text(
      'OOps you are setting an alarm for a past date',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.italic,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FloatingActionButton(
          child: const Icon(
            Icons.add,
            size: 33,
          ),
          onPressed: () async {
            TimeOfDay? newTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (newTime != null) {
              if (TimeOfDay.now().compareTo(newTime) == -1) {
                var data = aFunction(newTime);
                log(data.toString());
                NotificationService().scheduleNotifications(time: data);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(ksnackBar);
              }
            }
          },
        ),
      ),
    );
  }

  aFunction(TimeOfDay sometime) {
    var date = DateTime.now();
    return DateTime(
      date.year,
      date.month,
      date.day,
      sometime.hour,
      sometime.minute,
    );
  }
}

extension TimeOfDayExtension on TimeOfDay {
  int compareTo(TimeOfDay other) {
    if (hour < other.hour) return -1;
    if (hour > other.hour) return 1;
    if (minute < other.minute) return -1;
    if (minute > other.minute) return 1;
    return 0;
  }
}
