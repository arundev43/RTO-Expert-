import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/state_model.dart';
import '../../../providers/app_settings_provider.dart';
import '../../home/screens/home_screen.dart';

/// Exactly two steps: pick a state, pick a language for that state.
/// No tutorial slides, no permission prompts, no account creation.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  StateModel? _selectedState;
  final _searchController = TextEditingController();
  String _query = '';

  List<StateModel> get _filteredStates => kIndianStates
      .where((s) => s.name.toLowerCase().contains(_query.toLowerCase()))
      .toList();

  void _pickState(StateModel state) {
    setState(() => _selectedState = state);
  }

  Future<void> _pickLanguage(String languageCode) async {
    await context
        .read<AppSettingsProvider>()
        .completeOnboarding(_selectedState!.code, languageCode);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child:
              _selectedState == null ? _buildStateStep() : _buildLanguageStep(),
        ),
      ),
    );
  }

  Widget _buildStateStep() {
    return Column(
      key: const ValueKey('state-step'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
          child: Text('Select your State',
              style: Theme.of(context).textTheme.titleLarge),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _query = v),
            decoration: const InputDecoration(
              hintText: 'Search state',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _filteredStates.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final s = _filteredStates[i];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(s.name),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _pickState(s),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageStep() {
    return Column(
      key: const ValueKey('lang-step'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 24, 20, 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _selectedState = null),
              ),
              Text('Select Language',
                  style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Available for ${_selectedState!.name}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: _selectedState!.languages
                .map((lang) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: OutlinedButton(
                        onPressed: () => _pickLanguage(lang.code),
                        child: Text(lang.label),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
