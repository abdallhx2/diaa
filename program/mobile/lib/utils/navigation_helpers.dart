import 'package:flutter/material.dart';
import 'package:edu_smart_assistant/config/routes.dart';

void finishToDashboard(BuildContext context, {VoidCallback? cleanup}) {
  cleanup?.call();
  Navigator.popUntil(context, ModalRoute.withName(AppRoutes.studentDashboard));
}
