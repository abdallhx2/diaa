import 'package:flutter/material.dart';
import 'package:edu_smart_assistant/config/routes.dart';

class ParentLoginScreen extends StatelessWidget {
  const ParentLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Redirect to combined login
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, AppRoutes.roleSelection);
    });
    return const Scaffold();
  }
}
