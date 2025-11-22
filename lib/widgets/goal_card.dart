import 'package:flutter/material.dart';
import '../models/writing_goal.dart';

class GoalCard extends StatelessWidget {
  final WritingGoal goal;
  final VoidCallback onTap;

  const GoalCard({
    super.key,
    required this.goal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        onTap: onTap,
        title: Text(
          goal.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: goal.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('${goal.currentWords} / ${goal.targetWords} palabras'),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: goal.progressPercentage,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                goal.isCompleted ? Colors.green : Colors.blue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${(goal.progressPercentage * 100).toStringAsFixed(1)}% completado',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: goal.isCompleted
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}