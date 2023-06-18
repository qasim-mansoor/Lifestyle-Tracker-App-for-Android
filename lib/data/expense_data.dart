import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/hive_database.dart';
import 'package:flutter_application_1/datetime/date_time_helper.dart';
import 'package:flutter_application_1/models/expense_item.dart';

class ExpenseData extends ChangeNotifier {
  // List of all expenses
  List<ExpenseItem> overallExpenseList = [];

  // Method to get expenses
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  final db = HiveDatabase();

  void prepareData() {
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }
  }

  // Method to add new expense
  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);

    notifyListeners();
    db.saveData(overallExpenseList);
  }

  // Method to delete expense
  void deleteNewExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);

    notifyListeners();
    db.saveData(overallExpenseList);
  }

  // Method to get weekday
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tues';
      case 3:
        return 'Wed';
      case 4:
        return 'Thur';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  // Method to get date for this week's sunday
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

    DateTime today = DateTime.now();

    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }

    return startOfWeek!;
  }
  /*
      Convert list of expenses into a daily summary

      eg.

      overallExpenseList = [[ food, 2023/01/30, $10],.....]

      convert into a summary

      eg:

      dailtExpenseSummary = [[a date: total expenses on that date]]


  */

  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {};

    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }
    return dailyExpenseSummary;
  }
}
