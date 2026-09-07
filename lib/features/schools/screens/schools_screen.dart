import 'package:flutter/material.dart';
import '../../../data/models/driving_school_model.dart';
import 'add_school_screen.dart';
import 'my_contributions_screen.dart';

class SchoolsScreen extends StatelessWidget {
  const SchoolsScreen({super.key});

  // Demo data — replace with SchoolProvider.loadNearby() wired to real GPS/API.
  static final _demoSchools = [
    DrivingSchoolModel(
      id: 's1',
      name: 'Sri Velan Motor Driving School',
      address: 'Anna Nagar, Chennai',
      latitude: 13.0850,
      longitude: 80.2101,
      phone: '+91 98765 43210',
      fees: '₹4,500',
      timing: '7 AM - 8 PM',
      contributorId: 'u1',
      contributorName: 'Ram K.',
      status: SchoolStatus.approved,
      viewCount: 124,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driving Schools'),
        actions: [
          IconButton(
            icon: const Icon(Icons.assignment_outlined),
            tooltip: 'My Contributions',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyContributionsScreen()),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _demoSchools.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final s = _demoSchools[i];
          return Card(
            child: ListTile(
              title: Text(s.name),
              subtitle:
                  Text('${s.address}\n${s.fees ?? ''} · ${s.timing ?? ''}'),
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(Icons.call_outlined),
                onPressed: () {}, // launch dialer with s.phone
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddSchoolScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add School'),
      ),
    );
  }
}
