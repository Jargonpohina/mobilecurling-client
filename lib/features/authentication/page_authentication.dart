import 'package:flutter/material.dart';
import 'package:mobilecurling/core/theme/theme.dart';
import 'package:mobilecurling/features/authentication/card_authentication.dart';

class PageAuthentication extends StatelessWidget {
  const PageAuthentication({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'MOBILE CURLING',
                style: ThemeDataCurling().darkTheme.textTheme.titleLarge,
              ),
            ],
          ),
        ),
        const CardAuthentication(),
      ],
    ));
  }
}
