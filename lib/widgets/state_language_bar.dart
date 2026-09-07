import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_settings_provider.dart';
import '../data/models/state_model.dart';

/// A single, tappable pill for state+language shown at the top of the
/// main tabs — replaces the old header dropdown that took up half the row.
class StateLanguageBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const StateLanguageBar({super.key, required this.title, this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsProvider>();
    final state = settings.selectedState;
    final langLabel = state?.languages
        .firstWhere((l) => l.code == settings.languageCode,
            orElse: () => state.languages.first)
        .label;

    return AppBar(
      title: Text(title),
      actions: [
        if (state != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text('${state.code} · $langLabel'),
              onPressed: () => _showSwitcher(context, settings),
            ),
          ),
        ...?actions,
      ],
    );
  }

  void _showSwitcher(BuildContext context, AppSettingsProvider settings) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Change State',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            SizedBox(
              height: 320,
              child: ListView.builder(
                itemCount: kIndianStates.length,
                itemBuilder: (_, i) {
                  final s = kIndianStates[i];
                  return ListTile(
                    title: Text(s.name),
                    onTap: () {
                      Navigator.pop(ctx);
                      _pickLanguageFor(context, settings, s);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickLanguageFor(
      BuildContext context, AppSettingsProvider settings, StateModel s) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: s.languages
              .map((l) => ListTile(
                    title: Text(l.label),
                    onTap: () {
                      settings.completeOnboarding(s.code, l.code);
                      Navigator.pop(ctx);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}
