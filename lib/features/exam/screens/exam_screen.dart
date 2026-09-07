import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/app_settings_provider.dart';
import '../../../providers/exam_provider.dart';
import '../../../widgets/option_tile.dart';
import 'exam_result_screen.dart';

class ExamScreen extends StatelessWidget {
  const ExamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) {
        final settings = ctx.read<AppSettingsProvider>();
        final provider = ExamProvider();
        provider.startExam(stateCode: settings.stateCode!, languageCode: settings.languageCode!);
        return provider;
      },
      child: const _ExamBody(),
    );
  }
}

class _ExamBody extends StatelessWidget {
  const _ExamBody();

  @override
  Widget build(BuildContext context) {
    final exam = context.watch<ExamProvider>();

    if (exam.status == ExamStatus.notStarted) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (exam.status == ExamStatus.finished) {
      // Defer navigation until after this build completes.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ExamResultScreen()),
        );
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final q = exam.currentQuestion;
    final timerProgress = exam.secondsLeft / ExamProvider.secondsPerQuestion;

    return Scaffold(
      appBar: AppBar(
        title: Text('${exam.questionNumber}/${exam.totalCount}'),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      value: timerProgress,
                      strokeWidth: 3,
                      color: timerProgress < 0.3 ? Colors.red : Theme.of(context).colorScheme.primary,
                      backgroundColor: Theme.of(context).dividerColor,
                    ),
                  ),
                  Text('${exam.secondsLeft}', style: const TextStyle(fontSize: 11)),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
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
                selectedIndex: exam.selectedOptionIndex,
                correctIndex: q.correctIndex,
                onTap: () => context.read<ExamProvider>().selectOption(i),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Text('✓ ${exam.correctCount}', style: const TextStyle(color: Colors.green)),
                const SizedBox(width: 16),
                Text('✕ ${exam.wrongCount}', style: const TextStyle(color: Colors.red)),
                const Spacer(),
                ElevatedButton(
                  onPressed: exam.selectedOptionIndex == null
                      ? null
                      : () => context.read<ExamProvider>().nextQuestion(),
                  child: Text(exam.hasNext ? 'Next Question' : 'Finish'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
