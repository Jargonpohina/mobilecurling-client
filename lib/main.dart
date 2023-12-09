import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilecurling/core/theme/theme.dart';
import 'package:dio/dio.dart';
import 'package:mobilecurling/features/authentication/page_authentication.dart';

void main() {
  runApp(const MainApp());
}

final dio = Dio();
const authServerUrl = 'https://auth-ic4hp354na-ew.a.run.app';
const lobbyServerUrl = 'http://localhost:8080';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        theme: ThemeDataCurling().darkTheme,
        themeMode: ThemeMode.dark,
        home: const PageAuthentication(),
      ),
    );
  }
}
