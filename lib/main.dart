import 'package:flutter/material.dart';

import 'app/routes.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const NanemApp());
}

class NanemApp extends StatelessWidget {
  const NanemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NANEM',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: Routes.splash,
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}
