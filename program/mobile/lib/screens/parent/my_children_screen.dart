import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/config/routes.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/providers/parent_provider.dart';
import 'package:edu_smart_assistant/models/student_model.dart';
import 'package:edu_smart_assistant/widgets/diyaa_inner_nav.dart';
import 'package:edu_smart_assistant/widgets/custom_button.dart';

class MyChildrenScreen extends StatelessWidget {
  const MyChildrenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg100,
      body: SafeArea(
        child: Column(
          children: [
            const DiyaaInnerNav(title: '\u0623\u0628\u0646\u0627\u0626\u064a'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Consumer<ParentProvider>(
                  builder: (_, parentProvider, __) {
                    final children = parentProvider.children;
                    final selectedChild = parentProvider.selectedChild;

                    return Column(
                      children: [
                        if (children.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Text(
                              '\u0644\u0627 \u064a\u0648\u062c\u062f \u0623\u0637\u0641\u0627\u0644 \u0645\u0636\u0627\u0641\u064a\u0646 \u0628\u0639\u062f',
                              style: GoogleFonts.tajawal(
                                color: AppTheme.text200,
                                fontSize: 16,
                              ),
                            ),
                          )
                        else
                          ...children.map((child) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _buildChildCard(
                                  context,
                                  child,
                                  selectedChild,
                                  parentProvider,
                                ),
                              )),
                        const SizedBox(height: 14),
                        CustomButton(
                          text: '\u2795 \u0625\u0636\u0627\u0641\u0629 \u0637\u0641\u0644',
                          onPressed: () => Navigator.pushNamed(
                              context, AppRoutes.addChild),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildCard(
    BuildContext context,
    StudentModel child,
    StudentModel? selectedChild,
    ParentProvider parentProvider,
  ) {
    final isSelected =
        selectedChild != null && selectedChild.id == child.id;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppTheme.primary100 : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppTheme.primary100, AppTheme.primary200],
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              child.name.isNotEmpty ? child.name[0] : '?',
              style: GoogleFonts.tajawal(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Name + grade
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  child.name,
                  style: GoogleFonts.tajawal(
                    color: AppTheme.text100,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\u0627\u0644\u0635\u0641 ${child.grade}',
                  style: GoogleFonts.tajawal(
                    color: AppTheme.text200,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Select button
          GestureDetector(
            onTap: () => parentProvider.selectChild(child),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 13, vertical: 7),
              decoration: BoxDecoration(
                color: AppTheme.bg200,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                isSelected
                    ? '\u0645\u062d\u062f\u062f \u2713'
                    : '\u0627\u062e\u062a\u064a\u0627\u0631',
                style: GoogleFonts.tajawal(
                  color: AppTheme.primary200,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          // Settings button
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: AppTheme.bg200,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Text(
              '\u2699\uFE0F',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
