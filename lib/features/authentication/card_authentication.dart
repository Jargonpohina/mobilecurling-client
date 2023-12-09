import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobilecurling/features/server_listing/page_server_listing.dart';
import 'package:mobilecurling/main.dart';

class CardAuthentication extends StatefulWidget {
  const CardAuthentication({
    super.key,
  });

  @override
  State<CardAuthentication> createState() => _CardAuthenticationState();
}

class _CardAuthenticationState extends State<CardAuthentication> {
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
                        final response = await dio.post('$serverUrl/register',
                            data: jsonEncode([
                              {'username': _username.text, 'password': _password.text}
                            ]));
                        if (response.statusCode == 200 && context.mounted) {
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
                        final response = await dio.post('$serverUrl/login',
                            data: jsonEncode([
                              {'username': _username.text, 'password': _password.text}
                            ]));
                        if (response.statusCode == 200 && context.mounted) {
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
