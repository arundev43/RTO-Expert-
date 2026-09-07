import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/app_settings_provider.dart';
import '../../../providers/practice_provider.dart';
import '../../../widgets/option_tile.dart';

class PracticeScreen extends StatelessWidget {
  final String topic;
  const PracticeScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) {
        final settings = ctx.read<AppSettingsProvider>();
        final provider = PracticeProvider();
        provider.load(
          stateCode: settings.stateCode!,
          languageCode: settings.languageCode!,
          topic: topic,
        );
        return provider;
      },
      child: const _PracticeBody(),
    );
  }
}

class _PracticeBody extends StatelessWidget {
  const _PracticeBody();

  @override
  Widget build(BuildContext context) {
    final practice = context.watch<PracticeProvider>();
    final q = practice.currentQuestion;

    return Scaffold(
      appBar: AppBar(
        title: Text('Practice ${practice.totalCount == 0 ? '' : '${practice.questionNumber}/${practice.totalCount}'}'),
        actions: [
          if (q != null)
            IconButton(
              icon: Icon(practice.isBookmarked ? Icons.bookmark : Icons.bookmark_border),
              onPressed: () => context.read<PracticeProvider>().toggleBookmark(),
            ),
        ],
      ),
      body: q == null
          ? const Center(child: Text('No questions in this topic yet.'))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('Q. ${q.question}', style: Theme.of(context).textTheme.titleMedium),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(
                    q.options.length,
                    (i) => OptionTile(
                      index: i,
                      text: q.options[i],
                      selectedIndex: practice.selectedOptionIndex,
                      correctIndex: q.correctIndex,
                      onTap: () => context.read<PracticeProvider>().selectOption(i),
                    ),
                  ),
                  if (practice.selectedOptionIndex != null && q.explanation != null)
                    Card(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.06),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Text(q.explanation!, style: Theme.of(context).textTheme.bodyMedium),
                      ),
                    ),
                  const Spacer(),
                  if (practice.selectedOptionIndex != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.read<PracticeProvider>().next(),
                        child: const Text('Next'),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
