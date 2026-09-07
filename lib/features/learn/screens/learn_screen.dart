import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/app_settings_provider.dart';
import '../../../data/models/question_model.dart';
import '../../../data/repositories/question_repository.dart';
import '../../../widgets/state_language_bar.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  String _topic = 'All';
  String _query = '';
  List<QuestionModel> _all = [];
  bool _loading = true;

  static const _topics = ['All', 'Signs', 'Fines', 'Signals', 'Scenarios', 'Rules'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load();
  }

  Future<void> _load() async {
    final settings = context.read<AppSettingsProvider>();
    if (settings.stateCode == null) return;
    final list = await QuestionRepository.instance.loadQuestions(
      stateCode: settings.stateCode!,
      languageCode: settings.languageCode!,
    );
    if (!mounted) return;
    setState(() {
      _all = list;
      _loading = false;
    });
  }

  List<QuestionModel> get _filtered => _all.where((q) {
        final matchesTopic = _topic == 'All' || q.topic == _topic;
        final matchesQuery =
            _query.isEmpty || q.question.toLowerCase().contains(_query.toLowerCase());
        return matchesTopic && matchesQuery;
      }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StateLanguageBar(title: 'Learn'),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: TextField(
                    onChanged: (v) => setState(() => _query = v),
                    decoration: const InputDecoration(
                      hintText: 'Search questions',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _topics.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final t = _topics[i];
                      return ChoiceChip(
                        label: Text(t),
                        selected: _topic == t,
                        onSelected: (_) => setState(() => _topic = t),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final q = _filtered[i];
                      return Card(
                        child: ExpansionTile(
                          title: Text(q.question, style: Theme.of(context).textTheme.bodyLarge),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(q.topic, style: Theme.of(context).textTheme.bodyMedium),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Answer: ${q.options[q.correctIndex]}',
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  if (q.explanation != null) ...[
                                    const SizedBox(height: 6),
                                    Text(q.explanation!, style: Theme.of(context).textTheme.bodyMedium),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
