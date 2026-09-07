import 'package:flutter/material.dart';
import '../../../data/models/driving_school_model.dart';
import '../../../widgets/status_badge.dart';

class MyContributionsScreen extends StatelessWidget {
  const MyContributionsScreen({super.key});

  // Demo data — replace with SchoolProvider.loadMyContributions(userId).
  static final _demo = [
    DrivingSchoolModel(
      id: 'c1',
      name: 'New Horizon Driving School',
      address: 'T Nagar, Chennai',
      latitude: 0,
      longitude: 0,
      phone: '',
      contributorId: 'me',
      contributorName: 'You',
      status: SchoolStatus.pending,
    ),
    DrivingSchoolModel(
      id: 'c2',
      name: 'Speedway Motor School',
      address: 'Velachery, Chennai',
      latitude: 0,
      longitude: 0,
      phone: '',
      contributorId: 'me',
      contributorName: 'You',
      status: SchoolStatus.approved,
      viewCount: 58,
    ),
    DrivingSchoolModel(
      id: 'c3',
      name: 'ABC School (dup)',
      address: 'Adyar, Chennai',
      latitude: 0,
      longitude: 0,
      phone: '',
      contributorId: 'me',
      contributorName: 'You',
      status: SchoolStatus.rejected,
      rejectionReason: 'Duplicate of an existing listing',
      wasPaidSubmission: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Contributions')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _demo.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final s = _demo[i];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(s.name,
                              style: Theme.of(context).textTheme.titleMedium)),
                      StatusBadge(status: s.status),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(s.address,
                      style: Theme.of(context).textTheme.bodyMedium),
                  if (s.status == SchoolStatus.approved) ...[
                    const SizedBox(height: 6),
                    Text('${s.viewCount} views',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                  if (s.status == SchoolStatus.rejected &&
                      s.rejectionReason != null) ...[
                    const SizedBox(height: 6),
                    Text('Reason: ${s.rejectionReason}',
                        style: Theme.of(context).textTheme.bodyMedium),
                    if (s.wasPaidSubmission)
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          'Paid submission — refund/free retry issued automatically.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
