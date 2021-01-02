import 'package:flutter/material.dart';
import 'package:human_activity/screens/home_screen.dart';

void main() {
  runApp(HumanActivity());
}

class HumanActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.red,
        accentColor: Colors.green,
      ),
      home: HomeScreen(),
      routes: {
        HomeScreen.routeName: (_) => HomeScreen(),
      },
    );
  }
}
