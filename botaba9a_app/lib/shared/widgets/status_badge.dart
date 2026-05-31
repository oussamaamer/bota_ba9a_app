import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

/// Colored status badge for gas levels.
class StatusBadge extends StatelessWidget {
  final String status;
  final String? label;

  const StatusBadge({super.key, required this.status, this.label});

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: config.color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: config.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label ?? config.label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: config.color,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getConfig(String status) {
    switch (status) {
      case 'full':
        return _StatusConfig(AppColors.success, 'Plein');
      case 'good':
        return _StatusConfig(AppColors.successLight, 'Bon');
      case 'attention':
        return _StatusConfig(AppColors.warning, 'Attention');
      case 'low':
        return _StatusConfig(AppColors.accentOrange, 'Bas');
      case 'critical':
        return _StatusConfig(AppColors.danger, 'Critique');
      case 'empty':
        return _StatusConfig(AppColors.gaugeEmpty, 'Vide');
      case 'online':
        return _StatusConfig(AppColors.success, 'En ligne');
      case 'offline':
        return _StatusConfig(AppColors.textTertiary, 'Hors-ligne');
      case 'cached':
        return _StatusConfig(AppColors.warning, 'Données en cache');
      default:
        return _StatusConfig(AppColors.textTertiary, status);
    }
  }
}

class _StatusConfig {
  final Color color;
  final String label;

  const _StatusConfig(this.color, this.label);
}
