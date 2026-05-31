import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _businessController = TextEditingController();
  bool _obscurePassword = true;
  String _selectedRole = 'client';
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  final _roles = const [
    {'value': 'client', 'label': 'Particulier / Restaurant', 'icon': Icons.person_outline},
    {'value': 'vendor', 'label': 'Vendeur de gaz', 'icon': Icons.store_outlined},
    {'value': 'technician', 'label': 'Technicien', 'icon': Icons.build_outlined},
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _businessController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(AuthRegisterRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            fullName: _fullNameController.text.trim(),
            phone: _phoneController.text.trim().isNotEmpty
                ? _phoneController.text.trim()
                : null,
            role: _selectedRole,
            businessName: _businessController.text.trim().isNotEmpty
                ? _businessController.text.trim()
                : null,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go('/dashboard');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.danger,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryNavyDark,
                AppColors.primaryNavy,
                Color(0xFF1E4D7B),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 8),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                      onPressed: () => context.go('/login'),
                    ),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          // Title
                          Text(
                            'Créer un compte',
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Commencez à surveiller vos bouteilles',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.white60,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Form Card
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Full Name
                                  AppTextField(
                                    controller: _fullNameController,
                                    label: 'Nom complet',
                                    hint: 'Mohammed Alami',
                                    prefixIcon: Icons.person_outline,
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return 'Le nom est requis';
                                      if (v.length < 2) return 'Minimum 2 caractères';
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 14),

                                  // Email
                                  AppTextField(
                                    controller: _emailController,
                                    label: 'Email',
                                    hint: 'votre@email.com',
                                    keyboardType: TextInputType.emailAddress,
                                    prefixIcon: Icons.email_outlined,
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return 'L\'email est requis';
                                      if (!v.contains('@')) return 'Email invalide';
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 14),

                                  // Phone
                                  AppTextField(
                                    controller: _phoneController,
                                    label: 'Téléphone',
                                    hint: '+212 6XX XXX XXX',
                                    keyboardType: TextInputType.phone,
                                    prefixIcon: Icons.phone_outlined,
                                  ),
                                  const SizedBox(height: 14),

                                  // Password
                                  AppTextField(
                                    controller: _passwordController,
                                    label: 'Mot de passe',
                                    hint: '••••••••',
                                    obscureText: _obscurePassword,
                                    prefixIcon: Icons.lock_outlined,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: AppColors.textTertiary,
                                      ),
                                      onPressed: () {
                                        setState(() => _obscurePassword = !_obscurePassword);
                                      },
                                    ),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return 'Le mot de passe est requis';
                                      if (v.length < 8) return 'Minimum 8 caractères';
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),

                                  // Role Selection
                                  Text(
                                    'Type de compte',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _roles.map((role) {
                                      final isSelected = _selectedRole == role['value'];
                                      return GestureDetector(
                                        onTap: () => setState(() => _selectedRole = role['value'] as String),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? AppColors.primaryNavy.withOpacity(0.1)
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                              color: isSelected
                                                  ? AppColors.primaryNavy
                                                  : AppColors.divider,
                                              width: isSelected ? 2 : 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                role['icon'] as IconData,
                                                size: 18,
                                                color: isSelected
                                                    ? AppColors.primaryNavy
                                                    : AppColors.textTertiary,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                role['label'] as String,
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  fontWeight: isSelected
                                                      ? FontWeight.w600
                                                      : FontWeight.w400,
                                                  color: isSelected
                                                      ? AppColors.primaryNavy
                                                      : AppColors.textSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 14),

                                  // Business Name (conditional)
                                  if (_selectedRole == 'vendor' ||
                                      _selectedRole == 'client')
                                    AppTextField(
                                      controller: _businessController,
                                      label: 'Nom du commerce (optionnel)',
                                      hint: 'Café Central',
                                      prefixIcon: Icons.store_mall_directory_outlined,
                                    ),
                                  const SizedBox(height: 24),

                                  // Register Button
                                  BlocBuilder<AuthBloc, AuthState>(
                                    builder: (context, state) {
                                      return AppButton(
                                        text: 'Créer mon compte',
                                        onPressed: _onRegister,
                                        isLoading: state is AuthLoading,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Login link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Déjà un compte ? ',
                                style: GoogleFonts.inter(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.go('/login'),
                                child: Text(
                                  'Se connecter',
                                  style: GoogleFonts.inter(
                                    color: AppColors.accentOrange,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
