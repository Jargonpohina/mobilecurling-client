import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilecurling/core/classes/message/message.dart';
import 'package:mobilecurling/core/providers/lobby/lobby.dart';
import 'package:mobilecurling/core/providers/user/user.dart';
import 'package:mobilecurling/main.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PageGame extends ConsumerStatefulWidget {
  const PageGame({
    super.key,
  });

  @override
  ConsumerState<PageGame> createState() => _PageGameState();
}

class _PageGameState extends ConsumerState<PageGame> {
  List<String> messages = [];
  @override
  void initState() {
    super.initState();
    final id = ref.read(lobbyManagerProvider)!.id;
    final uri = Uri.parse('ws://$gameServerUrl/game/$id');
    final channel = WebSocketChannel.connect(uri);
    Future.delayed(Duration.zero, () {
      channel.sink.add(jsonEncode(Message(type: MessageType.join, user: ref.read(userManagerProvider)).toJson()));
      channel.stream.listen((message) {
        setState(() {
          messages.add(message.toString());
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        for (final message in messages)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(message),
              ],
            ),
          ),
      ],
    ));
  }
}
