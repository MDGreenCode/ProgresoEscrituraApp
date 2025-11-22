import 'package:flutter/material.dart';

class DailyProgressWidget extends StatefulWidget {
  final Function(int) onWordsAdded;

  const DailyProgressWidget({super.key, required this.onWordsAdded});

  @override
  State<DailyProgressWidget> createState() => _DailyProgressWidgetState();
}

class _DailyProgressWidgetState extends State<DailyProgressWidget> {
  final TextEditingController _wordsController = TextEditingController();
  int _todayWords = 0;

  void _addWords() {
    final words = int.tryParse(_wordsController.text) ?? 0;
    if (words > 0) {
      setState(() {
        _todayWords += words;
      });
      widget.onWordsAdded(words);
      _wordsController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('¡$words palabras añadidas!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progreso de Hoy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Palabras escritas hoy: $_todayWords',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _wordsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Nuevas palabras',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: _addWords,
                    child: const Text('Añadir'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}