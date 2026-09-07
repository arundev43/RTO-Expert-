import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/app_settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          if (!settings.isPremium)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.block),
                  label: const Text('Remove Ads — ₹69'),
                  onPressed: () => _showPurchaseSheet(context, settings),
                ),
              ),
            ),
          const Divider(),
          ListTile(
            title: const Text('Dark Mode'),
            trailing: DropdownButton<ThemeMode>(
              value: settings.themeMode,
              underline: const SizedBox.shrink(),
              items: const [
                DropdownMenuItem(value: ThemeMode.system, child: Text('Auto')),
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              ],
              onChanged: (mode) {
                if (mode != null) settings.setThemeMode(mode);
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Change State'),
            subtitle: Text(settings.selectedState?.name ?? '—'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {}, // reuse StateLanguageBar's bottom sheet logic
          ),
          const Divider(),
          const ListTile(title: Text('Contact Us')),
          const ListTile(title: Text('Disclaimer')),
          const ListTile(title: Text('Privacy Policy')),
        ],
      ),
    );
  }

  /// One-time purchase flow. Login happens ONLY here — right before
  /// payment — never anywhere else in the app.
  void _showPurchaseSheet(BuildContext context, AppSettingsProvider settings) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Remove Ads Forever', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text('₹69 one-time · No ads anywhere in the app, ever.'),
            const SizedBox(height: 8),
            const Text('Sign in to link your purchase — restores automatically on reinstall or a new device.'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // TODO: replace with real OTP/phone login + in-app purchase SDK.
                  await settings.markLoggedInAndPremium('current_user');
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                child: const Text('Sign in & Pay ₹69'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
