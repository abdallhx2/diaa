import 'package:flutter/material.dart';
import 'package:edu_smart_assistant/config/routes.dart';

class StudentLoginScreen extends StatelessWidget {
  const StudentLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Redirect to combined login
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, AppRoutes.roleSelection);
    });
    return const Scaffold();
  }
}
