import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/parent_provider.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/config/constants.dart';
import 'package:edu_smart_assistant/widgets/custom_text_field.dart';
import 'package:edu_smart_assistant/widgets/custom_button.dart';
import 'package:edu_smart_assistant/widgets/diyaa_inner_nav.dart';

class AddChildScreen extends StatefulWidget {
  const AddChildScreen({super.key});

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String? _selectedGrade;
  String? _selectedLevel;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final placeholderUid =
        'child-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(0x7fffffff)}';

    final data = {
      'child_firebase_uid': placeholderUid,
      'child_name': _nameController.text.trim(),
      'age': int.tryParse(_ageController.text.trim()) ?? 6,
      'grade': _selectedGrade,
      'learning_level': _selectedLevel,
    };

    final success = await context.read<ParentProvider>().addChild(data);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '\u062a\u0645\u062a \u0625\u0636\u0627\u0641\u0629 \u0627\u0644\u0637\u0641\u0644 \u0628\u0646\u062c\u0627\u062d',
            textDirection: TextDirection.rtl,
            style: GoogleFonts.tajawal(),
          ),
          backgroundColor: AppTheme.successColor,
        ),
      );
      Navigator.pop(context);
    } else {
      final error =
          context.read<ParentProvider>().errorMessage ?? '\u0641\u0634\u0644 \u0641\u064a \u0625\u0636\u0627\u0641\u0629 \u0627\u0644\u0637\u0641\u0644';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error,
            textDirection: TextDirection.rtl,
            style: GoogleFonts.tajawal(),
          ),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg100,
      body: SafeArea(
        child: Column(
          children: [
            const DiyaaInnerNav(title: '\u0625\u0636\u0627\u0641\u0629 \u0637\u0641\u0644'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header icon
                      Center(
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppTheme.primary100,
                                AppTheme.primary200,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '\uD83D\uDC76',
                            style: TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Title
                      Center(
                        child: Text(
                          '\u0625\u0636\u0627\u0641\u0629 \u0637\u0641\u0644 \u062c\u062f\u064a\u062f',
                          style: GoogleFonts.tajawal(
                            color: AppTheme.text100,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Subtitle
                      Center(
                        child: Text(
                          '\u0623\u062f\u062e\u0644 \u0628\u064a\u0627\u0646\u0627\u062a \u0637\u0641\u0644\u0643',
                          style: GoogleFonts.tajawal(
                            color: AppTheme.text200,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Name field
                      CustomTextField(
                        label: '\u0627\u0633\u0645 \u0627\u0644\u0637\u0641\u0644',
                        hint: '\u0623\u062f\u062e\u0644 \u0627\u0633\u0645 \u0627\u0644\u0637\u0641\u0644',
                        controller: _nameController,
                        prefixIcon: Icons.person,
                        validator: (v) =>
                            v == null || v.isEmpty ? '\u0627\u0644\u0627\u0633\u0645 \u0645\u0637\u0644\u0648\u0628' : null,
                      ),
                      const SizedBox(height: 16),

                      // Age field
                      CustomTextField(
                        label: '\u0627\u0644\u0639\u0645\u0631',
                        hint: '\u0623\u062f\u062e\u0644 \u0639\u0645\u0631 \u0627\u0644\u0637\u0641\u0644',
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.cake,
                        validator: (v) {
                          if (v == null || v.isEmpty) return '\u0627\u0644\u0639\u0645\u0631 \u0645\u0637\u0644\u0648\u0628';
                          final age = int.tryParse(v);
                          if (age == null || age < 6 || age > 12) {
                            return '\u0627\u0644\u0639\u0645\u0631 \u064a\u062c\u0628 \u0623\u0646 \u064a\u0643\u0648\u0646 \u0628\u064a\u0646 6 \u0648 12';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Grade dropdown
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: '\u0627\u0644\u0635\u0641 \u0627\u0644\u062f\u0631\u0627\u0633\u064a',
                          labelStyle: GoogleFonts.tajawal(
                            color: AppTheme.text200,
                          ),
                          prefixIcon: const Icon(Icons.school,
                              color: AppTheme.text200, size: 20),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusSm),
                            borderSide: const BorderSide(
                                color: AppTheme.bg200, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusSm),
                            borderSide: const BorderSide(
                                color: AppTheme.bg200, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusSm),
                            borderSide: const BorderSide(
                                color: AppTheme.primary100, width: 2),
                          ),
                          filled: true,
                          fillColor: AppTheme.bg100,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 14),
                        ),
                        style: GoogleFonts.tajawal(
                          color: AppTheme.text100,
                          fontSize: 16,
                        ),
                        items: AppConstants.supportedGrades
                            .map((g) => DropdownMenuItem(
                                  value: g,
                                  child: Text(g),
                                ))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _selectedGrade = v),
                        validator: (v) =>
                            v == null ? '\u0627\u062e\u062a\u0631 \u0627\u0644\u0635\u0641 \u0627\u0644\u062f\u0631\u0627\u0633\u064a' : null,
                      ),
                      const SizedBox(height: 16),

                      // Level dropdown
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: '\u0627\u0644\u0645\u0633\u062a\u0648\u0649 \u0627\u0644\u062a\u0639\u0644\u064a\u0645\u064a',
                          labelStyle: GoogleFonts.tajawal(
                            color: AppTheme.text200,
                          ),
                          prefixIcon: const Icon(Icons.bar_chart,
                              color: AppTheme.text200, size: 20),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusSm),
                            borderSide: const BorderSide(
                                color: AppTheme.bg200, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusSm),
                            borderSide: const BorderSide(
                                color: AppTheme.bg200, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusSm),
                            borderSide: const BorderSide(
                                color: AppTheme.primary100, width: 2),
                          ),
                          filled: true,
                          fillColor: AppTheme.bg100,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 14),
                        ),
                        style: GoogleFonts.tajawal(
                          color: AppTheme.text100,
                          fontSize: 16,
                        ),
                        items: ['\u0645\u0628\u062a\u062f\u0626', '\u0645\u062a\u0648\u0633\u0637', '\u0645\u062a\u0642\u062f\u0645']
                            .map((l) => DropdownMenuItem(
                                  value: l,
                                  child: Text(l),
                                ))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _selectedLevel = v),
                        validator: (v) =>
                            v == null ? '\u0627\u062e\u062a\u0631 \u0627\u0644\u0645\u0633\u062a\u0648\u0649' : null,
                      ),
                      const SizedBox(height: 32),

                      // Submit button
                      CustomButton(
                        text: '\u0625\u0636\u0627\u0641\u0629',
                        isLoading: _isLoading,
                        onPressed: _submitForm,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
