import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';

/// Bottom sheet dialog for manual weight input.
class ManualReadingDialog extends StatefulWidget {
  final String deviceName;
  final Function(int weightGrams) onSubmit;

  const ManualReadingDialog({
    super.key,
    required this.deviceName,
    required this.onSubmit,
  });

  @override
  State<ManualReadingDialog> createState() => _ManualReadingDialogState();
}

class _ManualReadingDialogState extends State<ManualReadingDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              'Saisie manuelle',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.deviceName,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Weight input
            Text(
              'Poids total (grammes)',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: '8450',
                hintStyle: GoogleFonts.jetBrainsMono(
                  fontSize: 24,
                  color: AppColors.textTertiary,
                ),
                suffixText: 'g',
                suffixStyle: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
                filled: true,
                fillColor: AppColors.surfaceLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.primaryNavy, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Entrez le poids';
                }
                final weight = int.tryParse(value);
                if (weight == null || weight < 0) {
                  return 'Valeur invalide';
                }
                if (weight > 50000) {
                  return 'Le poids ne peut pas dépasser 50 kg';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),

            // Helper text
            Row(
              children: [
                Icon(Icons.info_outline, size: 14, color: AppColors.textTertiary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Pesez la bouteille avec la balance connectée ou une balance manuelle',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Submit button
            AppButton(
              text: 'Enregistrer la mesure',
              icon: Icons.scale,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final weight = int.parse(_controller.text);
                  widget.onSubmit(weight);
                  Navigator.of(context).pop();
                }
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
