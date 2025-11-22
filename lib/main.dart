import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/goal_service.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const WritingGoalsApp());
}

class WritingGoalsApp extends StatelessWidget {
  const WritingGoalsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoalService(),
      child: MaterialApp(
        title: 'Gestor de Metas de Escritura',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}