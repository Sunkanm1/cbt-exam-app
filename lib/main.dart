import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() => runApp(const CbtApp());

class CbtApp extends StatelessWidget {
  const CbtApp({super.key});

  static const _seed = Color(0xFF1F3A8A);

  @override
  Widget build(BuildContext context) {
    ThemeData theme(Brightness brightness) => ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: brightness),
          useMaterial3: true,
        );

    return MaterialApp(
      title: 'CBT Exam Practice',
      debugShowCheckedModeBanner: false,
      theme: theme(Brightness.light),
      darkTheme: theme(Brightness.dark),
      home: const HomeScreen(),
    );
  }
}
