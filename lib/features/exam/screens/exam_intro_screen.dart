import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/app_settings_provider.dart';
import '../../../services/ads_service.dart';
import '../../../widgets/state_language_bar.dart';
import 'exam_screen.dart';

/// Ads run here, before the timer starts — never mid-question. Premium
/// users skip the ad entirely (handled inside AdsService).
class ExamIntroScreen extends StatefulWidget {
  const ExamIntroScreen({super.key});

  @override
  State<ExamIntroScreen> createState() => _ExamIntroScreenState();
}

class _ExamIntroScreenState extends State<ExamIntroScreen> {
  bool _starting = false;

  Future<void> _startExam() async {
    setState(() => _starting = true);
    await AdsService.instance.showBeforeExamAd();
    if (!mounted) return;
    setState(() => _starting = false);
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const ExamScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsProvider>();
    return Scaffold(
      appBar: const StateLanguageBar(title: 'Exam'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mock RTO Exam',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _rule(context, Icons.format_list_numbered,
                '10 questions per attempt'),
            _rule(context, Icons.timer_outlined, '30 seconds per question'),
            _rule(context, Icons.emoji_events_outlined,
                'Score 7/10 or higher to pass'),
            _rule(context, Icons.language,
                'For ${settings.selectedState?.name ?? 'your state'}'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _starting ? null : _startExam,
                icon: _starting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.play_arrow),
                label: Text(_starting ? 'Loading…' : 'Start Exam'),
              ),
            ),
            if (!settings.isPremium)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'A short ad plays before each exam. Remove ads anytime from More > Settings.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _rule(BuildContext context, IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 10),
            Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      );
}
