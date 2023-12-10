import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilecurling/core/providers/user/user.dart';
import 'package:mobilecurling/core/shared_classes/user/user.dart';
import 'package:mobilecurling/features/server_listing/page_server_listing.dart';
import 'package:mobilecurling/main.dart';

class CardAuthentication extends ConsumerStatefulWidget {
  const CardAuthentication({
    super.key,
  });

  @override
  ConsumerState<CardAuthentication> createState() => _CardAuthenticationState();
}

class _CardAuthenticationState extends ConsumerState<CardAuthentication> {
  final TextEditingController _username = TextEditingController(text: '');
  final TextEditingController _password = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
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
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        final response = await dio.post('$authServerUrl/register',
                            data: jsonEncode([
                              {'username': _username.text, 'password': _password.text}
                            ]));
                        if (response.statusCode == 200 && context.mounted) {
                          ref.read(userManagerProvider.notifier).update(User(username: _username.text, password: _password.text));
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const PageServerListing(),
                            ),
                          );
                        }
                      },
                      child: const Text('Register')),
                  ElevatedButton(
                      onPressed: () async {
                        final response = await dio.post('$authServerUrl/login',
                            data: jsonEncode([
                              {'username': _username.text, 'password': _password.text}
                            ]));
                        if (response.statusCode == 200 && context.mounted) {
                          ref.read(userManagerProvider.notifier).update(User(username: _username.text, password: _password.text));
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const PageServerListing(),
                            ),
                          );
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
