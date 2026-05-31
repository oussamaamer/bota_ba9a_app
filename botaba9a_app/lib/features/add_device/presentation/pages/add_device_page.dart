import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/entities/bottle_profile.dart';
import '../bloc/add_device_bloc.dart';
import '../bloc/add_device_event.dart';
import '../bloc/add_device_state.dart';

class AddDevicePage extends StatefulWidget {
  const AddDevicePage({super.key});

  @override
  State<AddDevicePage> createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _esp32IdController = TextEditingController();
  final _locationController = TextEditingController();
  final _emptyWeightController = TextEditingController();
  final _fullWeightController = TextEditingController();
  final _thresholdController = TextEditingController(text: '15');

  BottleProfile? _selectedProfile;
  bool _useCustomProfile = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();

    context.read<AddDeviceBloc>().add(const AddDeviceLoadProfiles());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _esp32IdController.dispose();
    _locationController.dispose();
    _emptyWeightController.dispose();
    _fullWeightController.dispose();
    _thresholdController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onSelectProfile(BottleProfile? profile) {
    setState(() {
      _selectedProfile = profile;
      if (profile != null) {
        _useCustomProfile = false;
        _emptyWeightController.text = profile.emptyWeightGrams.toString();
        _fullWeightController.text = profile.fullWeightGrams.toString();
        _thresholdController.text = profile.alertThresholdPct.toString();
      }
    });
  }

  void _onToggleCustom(bool value) {
    setState(() {
      _useCustomProfile = value;
      if (value) {
        _selectedProfile = null;
        _emptyWeightController.clear();
        _fullWeightController.clear();
        _thresholdController.text = '15';
      }
    });
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AddDeviceBloc>().add(AddDeviceSubmitted(
          name: _nameController.text.trim(),
          esp32Id: _esp32IdController.text.trim(),
          location: _locationController.text.trim().isNotEmpty
              ? _locationController.text.trim()
              : null,
          bottleProfileId: _selectedProfile?.id,
          emptyWeightGrams: _emptyWeightController.text.isNotEmpty
              ? int.tryParse(_emptyWeightController.text)
              : null,
          fullWeightGrams: _fullWeightController.text.isNotEmpty
              ? int.tryParse(_fullWeightController.text)
              : null,
          alertThresholdPct:
              int.tryParse(_thresholdController.text) ?? 15,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddDeviceBloc, AddDeviceState>(
      listener: (context, state) {
        if (state is AddDeviceSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Appareil ajouté avec succès !',
                      style: GoogleFonts.inter(color: Colors.white),
                    ),
                  ),
                ],
              ),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
          context.go('/dashboard');
        } else if (state is AddDeviceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message, style: GoogleFonts.inter()),
              backgroundColor: AppColors.danger,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: AppColors.primaryNavy,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => context.go('/dashboard'),
          ),
          title: Text(
            'Ajouter un appareil',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: BlocBuilder<AddDeviceBloc, AddDeviceState>(
            builder: (context, state) {
              if (state is AddDeviceProfilesLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.accentOrange),
                  ),
                );
              }

              final profiles = _extractProfiles(state);
              final isSubmitting = state is AddDeviceSubmitting;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Section: Device Info ──────────────────
                      _SectionHeader(
                        icon: Icons.router_outlined,
                        title: 'Informations de l\'appareil',
                      ),
                      const SizedBox(height: 12),
                      _buildCard(
                        children: [
                          AppTextField(
                            controller: _nameController,
                            label: 'Nom de la bouteille',
                            hint: 'Ex: Cuisine principale',
                            prefixIcon: Icons.label_outline,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Le nom est requis';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            controller: _esp32IdController,
                            label: 'Identifiant ESP32',
                            hint: 'Ex: esp32_abc123',
                            prefixIcon: Icons.developer_board_outlined,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'L\'identifiant ESP32 est requis';
                              }
                              if (v.trim().length < 3) {
                                return 'Minimum 3 caractères';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            controller: _locationController,
                            label: 'Emplacement (optionnel)',
                            hint: 'Ex: Restaurant - Casablanca',
                            prefixIcon: Icons.location_on_outlined,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ── Section: Bottle Profile ───────────────
                      _SectionHeader(
                        icon: Icons.propane_tank_outlined,
                        title: 'Profil de bouteille',
                      ),
                      const SizedBox(height: 12),
                      _buildCard(
                        children: [
                          // Standard profiles dropdown
                          if (profiles.isNotEmpty && !_useCustomProfile) ...[
                            Text(
                              'Choisir un profil standard',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildProfileSelector(profiles),
                            const SizedBox(height: 16),
                          ],

                          // Toggle for custom profile
                          _buildCustomToggle(),

                          // Custom weight fields (shown when custom OR when a profile is selected)
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  controller: _emptyWeightController,
                                  label: 'Poids vide (g)',
                                  hint: '7200',
                                  keyboardType: TextInputType.number,
                                  prefixIcon: Icons.arrow_downward,
                                  validator: (v) {
                                    if (!_useCustomProfile &&
                                        _selectedProfile != null) {
                                      return null; // Auto-filled from profile
                                    }
                                    if (_useCustomProfile) {
                                      if (v == null || v.isEmpty) {
                                        return 'Requis';
                                      }
                                      if (int.tryParse(v) == null ||
                                          int.parse(v) <= 0) {
                                        return 'Invalide';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: AppTextField(
                                  controller: _fullWeightController,
                                  label: 'Poids plein (g)',
                                  hint: '13200',
                                  keyboardType: TextInputType.number,
                                  prefixIcon: Icons.arrow_upward,
                                  validator: (v) {
                                    if (!_useCustomProfile &&
                                        _selectedProfile != null) {
                                      return null;
                                    }
                                    if (_useCustomProfile) {
                                      if (v == null || v.isEmpty) {
                                        return 'Requis';
                                      }
                                      final full = int.tryParse(v);
                                      if (full == null || full <= 0) {
                                        return 'Invalide';
                                      }
                                      final empty =
                                          int.tryParse(_emptyWeightController.text);
                                      if (empty != null && full <= empty) {
                                        return '> poids vide';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            controller: _thresholdController,
                            label: 'Seuil d\'alerte (%)',
                            hint: '15',
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.warning_amber_outlined,
                            validator: (v) {
                              if (v != null && v.isNotEmpty) {
                                final val = int.tryParse(v);
                                if (val == null || val < 1 || val > 50) {
                                  return 'Entre 1 et 50';
                                }
                              }
                              return null;
                            },
                          ),

                          // Capacity preview
                          if (_emptyWeightController.text.isNotEmpty &&
                              _fullWeightController.text.isNotEmpty)
                            _buildCapacityPreview(),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // ── Submit Button ─────────────────────────
                      BlocBuilder<AddDeviceBloc, AddDeviceState>(
                        builder: (context, state) {
                          return AppButton(
                            text: 'Enregistrer l\'appareil',
                            icon: Icons.save_outlined,
                            isLoading: state is AddDeviceSubmitting,
                            onPressed: _onSubmit,
                          );
                        },
                      ),

                      const SizedBox(height: 16),
                      AppButton(
                        text: 'Annuler',
                        isOutlined: true,
                        onPressed: () => context.go('/dashboard'),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<BottleProfile> _extractProfiles(AddDeviceState state) {
    if (state is AddDeviceReady) return state.profiles;
    if (state is AddDeviceSubmitting) return state.profiles;
    if (state is AddDeviceError) return state.profiles;
    return [];
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  Widget _buildProfileSelector(List<BottleProfile> profiles) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: DropdownButtonFormField<BottleProfile>(
        value: _selectedProfile,
        isExpanded: true,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
        hint: Text(
          'Sélectionner un profil...',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textTertiary,
          ),
        ),
        icon: const Icon(Icons.keyboard_arrow_down,
            color: AppColors.textSecondary),
        items: profiles.map((profile) {
          return DropdownMenuItem<BottleProfile>(
            value: profile,
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.accentOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.propane_tank,
                      size: 16, color: AppColors.accentOrange),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        profile.name,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Capacité: ${profile.capacityLabel}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: _onSelectProfile,
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildCustomToggle() {
    return GestureDetector(
      onTap: () => _onToggleCustom(!_useCustomProfile),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: _useCustomProfile
              ? AppColors.primaryNavy.withOpacity(0.06)
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _useCustomProfile
                ? AppColors.primaryNavy
                : AppColors.divider,
            width: _useCustomProfile ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              _useCustomProfile
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              size: 20,
              color: _useCustomProfile
                  ? AppColors.primaryNavy
                  : AppColors.textTertiary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profil personnalisé',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _useCustomProfile
                          ? AppColors.primaryNavy
                          : AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    'Saisir manuellement les poids vide et plein',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCapacityPreview() {
    final empty = int.tryParse(_emptyWeightController.text);
    final full = int.tryParse(_fullWeightController.text);

    if (empty == null || full == null || full <= empty) {
      return const SizedBox.shrink();
    }

    final capacity = full - empty;
    final capacityKg = (capacity / 1000).toStringAsFixed(1);

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.success.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline,
                size: 16, color: AppColors.success),
            const SizedBox(width: 8),
            Text(
              'Capacité de gaz: $capacityKg kg ($capacity g)',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.success,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryNavy.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: AppColors.primaryNavy),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
