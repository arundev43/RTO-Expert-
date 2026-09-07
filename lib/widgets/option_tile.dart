import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

/// A single answer option row. Shared by Practice and Exam so the answer
/// UI always looks/feels identical no matter where the user is.
class OptionTile extends StatelessWidget {
  final int index;
  final String text;
  final int? selectedIndex;
  final int correctIndex;
  final VoidCallback onTap;

  const OptionTile({
    super.key,
    required this.index,
    required this.text,
    required this.selectedIndex,
    required this.correctIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final answered = selectedIndex != null;
    final isSelected = selectedIndex == index;
    final isCorrectOption = index == correctIndex;

    Color? borderColor;
    Color? bgTint;
    if (answered) {
      if (isCorrectOption) {
        borderColor = AppColors.success;
        bgTint = AppColors.success.withValues(alpha: 0.08);
      } else if (isSelected) {
        borderColor = AppColors.error;
        bgTint = AppColors.error.withValues(alpha: 0.08);
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: answered ? null : onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: bgTint ?? Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor ?? Theme.of(context).dividerColor,
              width: borderColor != null ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: borderColor?.withValues(alpha: 0.15) ??
                    Theme.of(context).dividerColor,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                      fontSize: 13, color: borderColor ?? Colors.grey),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                  child:
                      Text(text, style: Theme.of(context).textTheme.bodyLarge)),
              if (answered && isCorrectOption)
                const Icon(Icons.check_circle,
                    color: AppColors.success, size: 20),
              if (answered && isSelected && !isCorrectOption)
                const Icon(Icons.cancel, color: AppColors.error, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
