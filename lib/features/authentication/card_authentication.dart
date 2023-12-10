import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilecurling/core/providers/user/user.dart';
import 'package:mobilecurling/core/shared_classes/user/user.dart';
import 'package:mobilecurling/core/theme/theme.dart';
import 'package:mobilecurling/features/server_listing/page_server_listing.dart';
import 'package:mobilecurling/main.dart';
import 'package:mobilecurling/widgets/card_default.dart';

class CardAuthentication extends ConsumerStatefulWidget {
  const CardAuthentication({
    super.key,
  });

  @override
  ConsumerState<CardAuthentication> createState() => _CardAuthenticationState();
}

class _CardAuthenticationState extends ConsumerState<CardAuthentication> {
  String? errorText;
  final TextEditingController _username = TextEditingController(text: '');
  final TextEditingController _password = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    return CardDefault(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _username,
              decoration: const InputDecoration(label: Text('Username')),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(label: Text('Password')),
            ),
            errorText != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      errorText!,
                      style: ThemeDataCurling().darkTheme.textTheme.bodyMedium!.copyWith(color: Colors.red[300]),
                    ),
                  )
                : const SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        final user = User(username: _username.text, password: _password.text);
                        final response = await dio.post('$authServerUrl/register', data: jsonEncode(user.toJson()));
                        if (response.statusCode == 200 && context.mounted) {
                          ref.read(userManagerProvider.notifier).update(user);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const PageServerListing(),
                            ),
                          );
                        } else {
                          print('yeehaw');
                        }
                      },
                      child: const Text('Register')),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          final response = await dio.post('$authServerUrl/login', data: jsonEncode(User(username: _username.text, password: _password.text).toJson()));
                          if (response.statusCode == 200 && context.mounted) {
                            ref.read(userManagerProvider.notifier).update(User.fromJson(jsonDecode(response.data)));
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const PageServerListing(),
                              ),
                            );
                          }
                        } catch (e) {
                          setState(() {
                            errorText = 'Failed to log in.';
                          });
                        }
                      },
                      child: const Text('Login')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
