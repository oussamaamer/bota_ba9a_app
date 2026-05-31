import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/device_card.dart';
import '../widgets/manual_reading_dialog.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(const DashboardLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primaryNavy,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.accentOrange, AppColors.accentOrangeDark],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.local_fire_department_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'BOTABA9A',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white70),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is DashboardReadingSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text('Mesure enregistrée avec succès',
                        style: GoogleFonts.inter()),
                  ],
                ),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is DashboardLoading) {
            return _buildLoading();
          }

          if (state is DashboardError) {
            return _buildError(state.message);
          }

          if (state is DashboardLoaded) {
            if (state.devices.isEmpty) {
              return _buildEmpty();
            }
            return _buildDeviceList(state);
          }

          return _buildLoading();
        },
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentOrange),
          ),
          SizedBox(height: 16),
          Text('Chargement du tableau de bord...'),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.danger.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline,
                  size: 48, color: AppColors.danger),
            ),
            const SizedBox(height: 20),
            Text(
              'Oops !',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              text: 'Réessayer',
              icon: Icons.refresh,
              onPressed: () {
                context.read<DashboardBloc>().add(const DashboardLoadRequested());
              },
              width: 200,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.accentOrange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.propane_tank_outlined,
                size: 56,
                color: AppColors.accentOrange,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Aucune bouteille',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ajoutez votre première bouteille de gaz\npour commencer la surveillance',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            AppButton(
              text: 'Ajouter une bouteille',
              icon: Icons.add,
              onPressed: () {
                context.go('/add-device');
              },
              width: 250,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceList(DashboardLoaded state) {
    return RefreshIndicator(
      color: AppColors.accentOrange,
      onRefresh: () async {
        context.read<DashboardBloc>().add(const DashboardRefreshRequested());
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: state.devices.length + 1, // +1 for header
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mes bouteilles',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${state.devices.length} appareil${state.devices.length > 1 ? 's' : ''} connecté${state.devices.length > 1 ? 's' : ''}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline,
                        color: AppColors.accentOrange, size: 28),
                    onPressed: () => context.go('/add-device'),
                  ),
                ],
              ),
            );
          }

          final device = state.devices[index - 1];
          return DeviceCard(
            device: device,
            onTap: () {
              // Phase 2: Navigate to device detail
            },
            onAddReading: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => ManualReadingDialog(
                  deviceName: device.name,
                  onSubmit: (weightGrams) {
                    context.read<DashboardBloc>().add(
                          DashboardReadingSubmitted(
                            deviceId: device.id,
                            weightGrams: weightGrams,
                          ),
                        );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
