import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/expense_data.dart';
import 'package:flutter_application_1/pages/fitness_page.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/pages/test_page.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_application_1/pages/login_page.dart';

void main() async {
  // Initialize DB (HIVE)
  await Hive.initFlutter();

  // Open a HIVE box
  await Hive.openBox("expense_database");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExpenseData(),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    FitnessPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: GNav(
        selectedIndex: _currentIndex,
        onTabChange: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Color.fromARGB(255, 51, 50, 50),
        color: Colors.white,
        activeColor: Colors.white,
        gap: 12,
        hoverColor: const Color.fromARGB(255, 71, 68, 68),
        tabs: const [
          GButton(
            icon: Icons.bar_chart_rounded,
            text: 'Expenses',
          ),
          GButton(
            icon: Icons.checklist_sharp,
            text: 'Habits',
          ),
        ],
      ),
    );
  }
}
