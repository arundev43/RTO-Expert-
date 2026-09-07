import 'package:flutter/material.dart';
import '../../../widgets/state_language_bar.dart';
import 'practice_screen.dart';

class PracticeHomeScreen extends StatelessWidget {
  const PracticeHomeScreen({super.key});

  static const _topics = [
    'All',
    'Signs',
    'Fines',
    'Signals',
    'Scenarios',
    'Rules'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StateLanguageBar(title: 'Practice'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'No timer. Instant feedback with explanations. Pick a topic to focus on your weak areas.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ..._topics.map(
            (t) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                title: Text(t),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PracticeScreen(topic: t)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
