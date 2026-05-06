import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/auth_provider.dart';
import 'package:edu_smart_assistant/config/routes.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/widgets/custom_text_field.dart';
import 'package:edu_smart_assistant/widgets/custom_button.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String _selectedRole = 'student';
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await context.read<AuthProvider>().login(
          _emailController.text.trim(),
          _passwordController.text,
          role: _selectedRole,
        );

    if (!mounted) return;

    if (success) {
      if (_selectedRole == 'student') {
        Navigator.pushReplacementNamed(context, AppRoutes.studentDashboard);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.parentDashboard);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              // Logo area
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.primary200, AppTheme.primary100],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          '\uD83D\uDCDA',
                          style: TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '\u0623\u0647\u0644\u0627\u064B \u0628\u0643 \u0641\u064A \u0636\u064A\u0627\u0621',
                      style: GoogleFonts.tajawal(
                        color: AppTheme.text100,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\u0633\u062C\u0644 \u062F\u062E\u0648\u0644\u0643 \u0644\u0644\u0645\u062A\u0627\u0628\u0639\u0629',
                      style: GoogleFonts.tajawal(
                        color: AppTheme.text200,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Role tabs
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.bg200,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    _buildTab(
                      label: '\uD83C\uDF93 \u0637\u0627\u0644\u0628',
                      role: 'student',
                    ),
                    _buildTab(
                      label:
                          '\uD83D\uDC68\u200D\uD83D\uDC67 \u0648\u0644\u064A \u0623\u0645\u0631',
                      role: 'parent',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      label:
                          '\u0627\u0644\u0628\u0631\u064A\u062F \u0627\u0644\u0625\u0644\u0643\u062A\u0631\u0648\u0646\u064A',
                      hint: 'example@email.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => !v!.contains('@')
                          ? '\u0628\u0631\u064A\u062F \u0625\u0644\u0643\u062A\u0631\u0648\u0646\u064A \u063A\u064A\u0631 \u0635\u0627\u0644\u062D'
                          : null,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      label:
                          '\u0643\u0644\u0645\u0629 \u0627\u0644\u0645\u0631\u0648\u0631',
                      hint: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
                      controller: _passwordController,
                      obscureText: true,
                      validator: (v) => v!.length < 6
                          ? '\u064A\u062C\u0628 6 \u0623\u062D\u0631\u0641 \u0639\u0644\u0649 \u0627\u0644\u0623\u0642\u0644'
                          : null,
                    ),
                    const SizedBox(height: 8),
                    // Error display
                    Consumer<AuthProvider>(
                      builder: (_, auth, __) {
                        if (auth.errorMessage == null ||
                            auth.errorMessage!.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.errorColor.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusSm),
                            border: Border.all(
                              color: AppTheme.errorColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              const Icon(Icons.error_outline,
                                  color: AppTheme.errorColor, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  auth.errorMessage!,
                                  style: GoogleFonts.tajawal(
                                    color: AppTheme.errorColor,
                                    fontSize: 13,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    // Login button
                    Consumer<AuthProvider>(
                      builder: (_, auth, __) => CustomButton(
                        text:
                            '\u062A\u0633\u062C\u064A\u0644 \u0627\u0644\u062F\u062E\u0648\u0644',
                        isLoading: auth.isLoading,
                        onPressed: _login,
                      ),
                    ),
                    // Register button for parent
                    if (_selectedRole == 'parent') ...[
                      const SizedBox(height: 12),
                      CustomButton(
                        text: '\u062A\u0633\u062C\u064A\u0644',
                        variant: ButtonVariant.outline,
                        onPressed: () => Navigator.pushNamed(
                            context, AppRoutes.parentRegister),
                      ),
                    ],
                    const SizedBox(height: 8),
                    // Forgot password
                    Center(
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          '\u0646\u0633\u064A\u062A \u0643\u0644\u0645\u0629 \u0627\u0644\u0645\u0631\u0648\u0631\u061F',
                          style: GoogleFonts.tajawal(
                            color: AppTheme.primary100,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab({required String label, required String role}) {
    final isActive = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = role),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primary100 : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: isActive
                ? const [
                    BoxShadow(
                      color: Color(0x598B5FBF),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.tajawal(
                color: isActive ? Colors.white : AppTheme.text200,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
