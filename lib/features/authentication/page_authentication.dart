import 'package:flutter/material.dart';
import 'package:mobilecurling/core/theme/theme.dart';
import 'package:mobilecurling/features/authentication/card_authentication.dart';
import 'package:mobilecurling/widgets/logo.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse('https://walkscape.app');

class PageAuthentication extends StatelessWidget {
  const PageAuthentication({
    super.key,
  });

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          const Logo(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Want to check my actually cool game? Check WalkScape, a mobile RPG where you walk in real life to progress.',
              textAlign: TextAlign.center,
              style: ThemeDataCurling().darkTheme.textTheme.bodyMedium!.copyWith(color: const Color.fromARGB(255, 231, 172, 255)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton(onPressed: _launchUrl, child: const Text('Check out WalkScape')),
          ),
          const CardAuthentication(),
        ],
      ),
    ));
  }
}
