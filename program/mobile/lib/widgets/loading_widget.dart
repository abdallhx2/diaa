import 'package:flutter/material.dart';
import '../config/theme.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;

  const LoadingWidget({this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppTheme.primaryBlue),
            strokeWidth: 3,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ],
      ),
    );
  }
}
