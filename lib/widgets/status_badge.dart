import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../data/models/driving_school_model.dart';

class StatusBadge extends StatelessWidget {
  final SchoolStatus status;
  const StatusBadge({super.key, required this.status});

  ({Color color, String label, IconData icon}) get _meta => switch (status) {
        SchoolStatus.pending => (
            color: AppColors.warning,
            label: 'Pending Review',
            icon: Icons.hourglass_top,
          ),
        SchoolStatus.approved => (
            color: AppColors.success,
            label: 'Approved & Live',
            icon: Icons.check_circle,
          ),
        SchoolStatus.rejected => (
            color: AppColors.error,
            label: 'Rejected',
            icon: Icons.cancel,
          ),
        SchoolStatus.flagged => (
            color: Colors.blueAccent,
            label: 'Flagged — Re-review',
            icon: Icons.flag,
          ),
      };

  @override
  Widget build(BuildContext context) {
    final m = _meta;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: m.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(m.icon, size: 14, color: m.color),
          const SizedBox(width: 5),
          Text(m.label,
              style: TextStyle(
                  color: m.color, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
