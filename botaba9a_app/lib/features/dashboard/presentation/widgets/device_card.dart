import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/gas_calculator.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../domain/entities/device_summary.dart';
import 'gas_gauge_widget.dart';

/// Device card for the dashboard list — shows mini gauge, key stats, and status.
class DeviceCard extends StatelessWidget {
  final DeviceSummary device;
  final VoidCallback? onTap;
  final VoidCallback? onAddReading;

  const DeviceCard({
    super.key,
    required this.device,
    this.onTap,
    this.onAddReading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        device.name,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (device.location != null) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                size: 14, color: AppColors.textTertiary),
                            const SizedBox(width: 4),
                            Text(
                              device.location!,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                StatusBadge(status: device.status),
              ],
            ),
            const SizedBox(height: 16),

            // Gauge + Stats row
            Row(
              children: [
                // Mini gauge
                GasGaugeWidget(
                  percentage: device.gasLevelPct,
                  status: device.status,
                  size: 100,
                  gasWeightGrams: device.gasWeightGrams,
                ),
                const SizedBox(width: 20),

                // Stats
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _StatRow(
                        icon: Icons.local_fire_department,
                        label: 'Consommation',
                        value:
                            '${(device.consumptionRateGPerDay / 1000).toStringAsFixed(1)} kg/j',
                        color: AppColors.accentOrange,
                      ),
                      const SizedBox(height: 10),
                      _StatRow(
                        icon: Icons.schedule,
                        label: 'Durée estimée',
                        value: GasCalculator.formatDuration(device.estimatedHoursLeft),
                        color: AppColors.primaryNavy,
                      ),
                      const SizedBox(height: 10),
                      _StatRow(
                        icon: Icons.straighten,
                        label: 'Profil',
                        value: device.bottleProfileName ?? 'Non configuré',
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Footer — last update + add reading button
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: AppColors.textTertiary),
                const SizedBox(width: 4),
                Text(
                  device.lastReadingAt != null
                      ? _formatTime(device.lastReadingAt!)
                      : 'Aucune lecture',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onAddReading,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accentOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add, size: 14, color: AppColors.accentOrange),
                        const SizedBox(width: 4),
                        Text(
                          'Mesurer',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accentOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'À l\'instant';
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours} h';
    return 'Il y a ${diff.inDays} j';
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: AppColors.textTertiary,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
