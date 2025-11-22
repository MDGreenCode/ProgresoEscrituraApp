import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/writing_goal.dart';
import '../services/goal_service.dart';
import '../widgets/progress_chart.dart';
import '../widgets/daily_progress_widget.dart';

class GoalDetailPage extends StatelessWidget {
  final WritingGoal goal;

  const GoalDetailPage({
    super.key,
    required this.goal,
  });

  void _addWords(BuildContext context, int words) {
    final goalService = Provider.of<GoalService>(context, listen: false);
    goalService.addWordsToGoal(goal.id, words);
  }

  void _deleteGoal(BuildContext context) {
    final goalService = Provider.of<GoalService>(context, listen: false);
    goalService.deleteGoal(goal.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(goal.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Eliminar Meta'),
                  content: const Text('¿Estás seguro de que quieres eliminar esta meta?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        _deleteGoal(context);
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      child: const Text('Eliminar'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Consumer<GoalService>(
          builder: (context, goalService, child) {
            // Obtener la versión actualizada de la meta
            final updatedGoal = goalService.getGoal(goal.id) ?? goal;

            return Column(
              children: [
                ProgressChart(goal: updatedGoal),
                const SizedBox(height: 16),
                DailyProgressWidget(
                  onWordsAdded: (words) => _addWords(context, words),
                ),
                const SizedBox(height: 16),
                if (updatedGoal.dailyProgress.isNotEmpty) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Historial Diario',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...updatedGoal.dailyProgress.entries.map((entry) {
                            return ListTile(
                              title: Text(
                                '${entry.key.day}/${entry.key.month}/${entry.key.year}',
                              ),
                              trailing: Text('${entry.value} palabras'),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
