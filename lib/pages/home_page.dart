import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/writing_goal.dart';
import '../services/goal_service.dart';
import '../widgets/goal_card.dart';
import 'new_goal_page.dart';
import 'goal_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestor de Metas de Escritura'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<GoalService>(
        builder: (context, goalService, child) {
          if (goalService.goals.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No tienes metas de escritura',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '¡Crea tu primera meta para comenzar!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: goalService.goals.length,
            itemBuilder: (context, index) {
              final goal = goalService.goals[index];
              return GoalCard(
                goal: goal,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GoalDetailPage(goal: goal),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewGoalPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}