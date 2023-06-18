import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/habit_tile.dart';

class FitnessPage extends StatefulWidget {
  const FitnessPage({super.key});

  @override
  State<FitnessPage> createState() => _FitnessPageState();
}

class _FitnessPageState extends State<FitnessPage> {
  //List of habits and summary
  final newHabitNameController = TextEditingController();
  final newHabitGoalController = TextEditingController();

  List habitList = [
    ['Exercise', false, 0, 10],
    ['Read', false, 0, 1],
    ['Walk', false, 0, 20],
    ['Code', false, 0, 40],
  ];

  void habitStarted(int index) {
    var startTime = DateTime.now();

    //include time already elapsed
    int elapsedTime = habitList[index][2];

    setState(() {
      habitList[index][1] = !habitList[index][1];
    });

    if (habitList[index][1]) {
      Timer.periodic(Duration(seconds: 1), (timer) {
        //check when user has stopped timer
        setState(() {
          if (!habitList[index][1]) {
            timer.cancel();
          }

          var currentTime = DateTime.now();
          habitList[index][2] = elapsedTime +
              currentTime.second -
              startTime.second +
              60 * (currentTime.minute - startTime.minute) +
              60 * 60 * (currentTime.hour - startTime.hour);
        });
      });
    }
  }

  void settingsOpened(int index) {
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(title: Text('Settings for ' + habitList[index][0]));
    //   },
    // );
    setState(() {
      if (habitList[index][1]) {
        habitList[index][1] = !habitList[index][1];
      }
      habitList[index][2] = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        // appBar: AppBar(
        //     backgroundColor: Colors.grey[900],
        //     title: Text('Track your Habits')),
        body: ListView.builder(
          itemCount: habitList.length,
          itemBuilder: (context, index) {
            return HabitTile(
                habitName: habitList[index][0],
                onTap: () {
                  habitStarted(index);
                },
                settingsTapped: () {
                  settingsOpened(index);
                },
                habitStarted: habitList[index][1],
                timeSpent: habitList[index][2],
                timeGoal: habitList[index][3]);
          },
        ));
  }
}
