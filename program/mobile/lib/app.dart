import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/config/routes.dart';
 
class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MaterialApp(
        title:                    'المساعد التعليمي الذكي',
        debugShowCheckedModeBanner: false,
        theme:                    AppTheme.lightTheme,
        locale:                   const Locale('ar', 'SA'),
        supportedLocales:         const [Locale('ar', 'SA')],
        localizationsDelegates:   const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        initialRoute:    AppRoutes.splash,
        routes:          AppRoutes.routes,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}