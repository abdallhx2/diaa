import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/auth_provider.dart';
import 'package:edu_smart_assistant/config/routes.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/widgets/custom_text_field.dart';
import 'package:edu_smart_assistant/widgets/custom_button.dart';

class ParentRegisterScreen extends StatefulWidget {
  const ParentRegisterScreen({super.key});

  @override
  State<ParentRegisterScreen> createState() => _ParentRegisterScreenState();
}

class _ParentRegisterScreenState extends State<ParentRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'password': _passwordController.text,
      'phone': _phoneController.text.trim(),
    };

    final success = await context.read<AuthProvider>().registerParent(data);

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, AppRoutes.parentDashboard);
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
              const SizedBox(height: 16),
              // Icon
              Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0x268B5FBF), Color(0x3361398F)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0x338B5FBF),
                      width: 2,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '\uD83D\uDC68\u200D\uD83D\uDC69\u200D\uD83D\uDC67',
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                '\u062A\u0633\u062C\u064A\u0644 \u0648\u0644\u064A\u0651 \u0627\u0644\u0623\u0645\u0631',
                textAlign: TextAlign.center,
                style: GoogleFonts.tajawal(
                  color: AppTheme.text100,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '\u0623\u0646\u0634\u0626 \u062D\u0633\u0627\u0628\u0643 \u0644\u0644\u0645\u062A\u0627\u0628\u0639\u0629 \u0645\u0639 \u0623\u0628\u0646\u0627\u0626\u0643',
                textAlign: TextAlign.center,
                style: GoogleFonts.tajawal(
                  color: AppTheme.text200,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),
              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      label:
                          '\u0627\u0644\u0627\u0633\u0645 \u0627\u0644\u0643\u0627\u0645\u0644',
                      hint:
                          '\u0623\u062F\u062E\u0644 \u0627\u0633\u0645\u0643 \u0627\u0644\u0643\u0627\u0645\u0644',
                      controller: _nameController,
                      validator: (v) => v!.isEmpty
                          ? '\u0627\u0644\u0627\u0633\u0645 \u0645\u0637\u0644\u0648\u0628'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      label:
                          '\u0631\u0642\u0645 \u0627\u0644\u0647\u0627\u062A\u0641',
                      hint: '05XXXXXXXX',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (v) => v!.length < 10
                          ? '\u0631\u0642\u0645 \u0647\u0627\u062A\u0641 \u063A\u064A\u0631 \u0635\u0627\u0644\u062D'
                          : null,
                    ),
                    const SizedBox(height: 12),
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
                    const SizedBox(height: 12),
                    CustomTextField(
                      label:
                          '\u0643\u0644\u0645\u0629 \u0627\u0644\u0645\u0631\u0648\u0631',
                      hint:
                          '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
                      controller: _passwordController,
                      obscureText: true,
                      validator: (v) => v!.length < 6
                          ? '\u064A\u062C\u0628 6 \u0623\u062D\u0631\u0641 \u0639\u0644\u0649 \u0627\u0644\u0623\u0642\u0644'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      label:
                          '\u062A\u0623\u0643\u064A\u062F \u0643\u0644\u0645\u0629 \u0627\u0644\u0645\u0631\u0648\u0631',
                      hint:
                          '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
                      controller: _confirmPasswordController,
                      obscureText: true,
                      validator: (v) => v != _passwordController.text
                          ? '\u0643\u0644\u0645\u0627\u062A \u0627\u0644\u0645\u0631\u0648\u0631 \u063A\u064A\u0631 \u0645\u062A\u0637\u0627\u0628\u0642\u0629'
                          : null,
                    ),
                    const SizedBox(height: 12),
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
                          margin: const EdgeInsets.only(bottom: 12),
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
                    const SizedBox(height: 14),
                    Consumer<AuthProvider>(
                      builder: (_, auth, __) => CustomButton(
                        text: '\u062A\u0633\u062C\u064A\u0644',
                        isLoading: auth.isLoading,
                        onPressed: _register,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '\u0644\u062F\u064A\u0643 \u062D\u0633\u0627\u0628\u061F',
                          style: GoogleFonts.tajawal(
                            fontSize: 13,
                            color: AppTheme.text200,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            '\u062A\u0633\u062C\u064A\u0644 \u062F\u062E\u0648\u0644',
                            style: GoogleFonts.tajawal(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primary100,
                            ),
                          ),
                        ),
                      ],
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
}
