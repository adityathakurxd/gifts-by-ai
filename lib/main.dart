import 'package:flutter/material.dart';
import 'package:giftsbyai/constants/styles.dart';
import 'package:giftsbyai/screens/landing_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gifts by AI',
      theme: ThemeData(colorSchemeSeed: primaryColor),
      home: const LandingScreen(),
    );
  }
}
