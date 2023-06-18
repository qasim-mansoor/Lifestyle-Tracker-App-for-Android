import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/expense_summary.dart';
import 'package:flutter_application_1/data/expense_data.dart';
import 'package:flutter_application_1/models/expense_item.dart';
import 'package:provider/provider.dart';

import '../components/expense_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newExpenseNameController = TextEditingController();
  final newExpenseRupeeController = TextEditingController();
  final newExpenseDecimalController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newExpenseNameController,
              decoration: const InputDecoration(
                hintText: "Expense Name",
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: newExpenseRupeeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Rupees",
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: newExpenseDecimalController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Pesos",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: save,
            child: Text('Save'),
          ),
          MaterialButton(
            onPressed: cancel,
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteNewExpense(expense);
  }

  //Save entry
  void save() {
    //Create expense item
    if (newExpenseNameController.text.isNotEmpty &&
        newExpenseRupeeController.text.isNotEmpty &&
        newExpenseDecimalController.text.isNotEmpty) {
      String amount =
          '${newExpenseRupeeController.text}.${newExpenseDecimalController.text}';
      ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameController.text,
        amount: amount,
        dateTime: DateTime.now(),
      );

      //Add expense
      Provider.of<ExpenseData>(context, listen: false)
          .addNewExpense(newExpense);
    }

    Navigator.pop(context);
    clear();
  }

  //Cancel entry
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  //Clear Controller
  void clear() {
    newExpenseNameController.clear();
    newExpenseRupeeController.clear();
    newExpenseDecimalController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
          backgroundColor: Colors.grey[300],
          floatingActionButton: FloatingActionButton(
            onPressed: addNewExpense,
            backgroundColor: Colors.black,
            child: const Icon(Icons.add),
          ),
          body: ListView(children: [
            ExpenseSummary(startOfWeek: value.startOfWeekDate()),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.getAllExpenseList().length,
              itemBuilder: (context, index) => ExpenseTile(
                name: value.getAllExpenseList()[index].name,
                amount: value.getAllExpenseList()[index].amount,
                dateTime: value.getAllExpenseList()[index].dateTime,
                deleteTapped: (p0) =>
                    deleteExpense(value.getAllExpenseList()[index]),
              ),
            ),
          ])),
    );
  }
}
