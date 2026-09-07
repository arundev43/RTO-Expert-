import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/app_settings_provider.dart';
import '../../schools/screens/schools_screen.dart';
import 'settings_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        children: [
          if (!settings.isPremium)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.08),
                child: ListTile(
                  leading: const Icon(Icons.block),
                  title: const Text('Remove Ads Forever'),
                  subtitle: const Text('One-time payment · ₹69'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  ),
                ),
              ),
            ),
          _tile(
              context,
              Icons.school_outlined,
              'Driving Schools & RTO Offices',
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SchoolsScreen()))),
          _tile(context, Icons.description_outlined, 'Forms', () {}),
          _tile(context, Icons.badge_outlined, 'Process of Driving Licence',
              () {}),
          _tile(
              context,
              Icons.settings_outlined,
              'Settings & Help',
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()))),
          _tile(context, Icons.share_outlined, 'Share App', () {}),
          _tile(context, Icons.star_outline, 'Rate App', () {}),
        ],
      ),
    );
  }

  Widget _tile(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
