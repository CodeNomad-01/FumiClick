import 'package:flutter/material.dart';

class SlotTile extends StatelessWidget {
  final DateTime slot;
  final bool selected;
  final VoidCallback onTap;

  const SlotTile({
    super.key,
    required this.slot,
    required this.selected,
    required this.onTap,
  });

  String _formatSlot(DateTime slot) {
    final day = slot.day.toString().padLeft(2, '0');
    final month = slot.month.toString().padLeft(2, '0');
    final hour = slot.hour.toString().padLeft(2, '0');
    return '$day/$month a las $hour:00';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? cs.primaryContainer : cs.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? cs.primary : cs.outline),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _formatSlot(slot),
                style: textTheme.bodyMedium?.copyWith(
                  color: selected ? cs.onPrimaryContainer : cs.onSurfaceVariant,
                ),
              ),
            ),
            if (selected)
              Icon(Icons.check_circle, color: cs.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
