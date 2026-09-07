import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/app_settings_provider.dart';
import '../../../providers/school_provider.dart';
import '../../../data/models/driving_school_model.dart';

class AddSchoolScreen extends StatefulWidget {
  const AddSchoolScreen({super.key});

  @override
  State<AddSchoolScreen> createState() => _AddSchoolScreenState();
}

class _AddSchoolScreenState extends State<AddSchoolScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _phone = TextEditingController();
  final _fees = TextEditingController();
  final _timing = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _phone.dispose();
    _fees.dispose();
    _timing.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    final schoolProvider = context.read<SchoolProvider>();
    final settings = context.read<AppSettingsProvider>();
    final requiresPayment = await schoolProvider.nextSubmissionRequiresPayment();

    if (requiresPayment) {
      final paid = await _showPaymentGate(settings);
      if (!paid) {
        setState(() => _submitting = false);
        return;
      }
    }

    await schoolProvider.submit(
      DrivingSchoolModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _name.text.trim(),
        address: _address.text.trim(),
        latitude: 0, // TODO: capture from map picker / geolocator
        longitude: 0,
        phone: _phone.text.trim(),
        fees: _fees.text.trim().isEmpty ? null : _fees.text.trim(),
        timing: _timing.text.trim().isEmpty ? null : _timing.text.trim(),
        contributorId: settings.isLoggedIn ? 'current_user' : 'anonymous',
        contributorName: 'You',
      ),
      paid: requiresPayment,
    );

    if (!mounted) return;
    setState(() => _submitting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Submitted for review — usually approved in 24–48 hrs.')),
    );
    Navigator.pop(context);
  }

  /// Second+ submission needs payment. Login happens HERE, only at the
  /// payment step — never forced during normal app use.
  Future<bool> _showPaymentGate(AppSettingsProvider settings) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20, right: 20, top: 8,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('One More Listing?', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text('Your first school listing was free. Additional listings are ₹20 each.'),
            const SizedBox(height: 16),
            const Text('Sign in to continue — this links your submission for status updates and refunds if rejected.'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // TODO: replace with real OTP/phone login + payment SDK call.
                  await settings.markLoggedInAndPremium('current_user');
                  if (ctx.mounted) Navigator.pop(ctx, true);
                },
                child: const Text('Sign in & Pay ₹20'),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Driving School')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'School Name'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _address,
              decoration: const InputDecoration(labelText: 'Address'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _fees,
              decoration: const InputDecoration(labelText: 'Fees (optional)'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _timing,
              decoration: const InputDecoration(labelText: 'Timing (optional)'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
