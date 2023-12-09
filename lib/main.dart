import 'package:flutter/material.dart';
import 'package:mobilecurling/core/theme/theme.dart';
import 'package:dio/dio.dart';
import 'package:mobilecurling/features/authentication/page_authentication.dart';

void main() {
  runApp(const MainApp());
}

final dio = Dio();
const serverUrl = 'http://localhost:8080';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeDataCurling().darkTheme,
      themeMode: ThemeMode.dark,
      home: const PageAuthentication(),
    );
  }
}
