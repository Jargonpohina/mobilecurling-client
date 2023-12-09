import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilecurling/core/classes/game_state/game_state.dart';
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
  GameState? game;
  @override
  void initState() {
    super.initState();
    final id = ref.read(lobbyManagerProvider)!.id;
    final uri = Uri.parse('ws://$gameServerUrl/game/$id');
    final channel = WebSocketChannel.connect(uri);
    Future.delayed(Duration.zero, () {
      channel.sink.add(jsonEncode(
        Message(type: MessageType.join, user: ref.read(userManagerProvider), lobby: ref.read(lobbyManagerProvider)).toJson(),
      ));
      channel.stream.listen((message) {
        final map = jsonDecode(message);
        setState(() {
          game = GameState.fromJson(map);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: game == null
            ? const Center(
                child: Text('Initializing the game...'),
              )
            : game!.playerTwo == null
                ? const Center(child: Text('Waiting for player to join...'))
                : Stack(
                    children: [
                      Column(
                        children: [
                          Card(
                            elevation: 10,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text('Player one: ${game!.playerOne!.username}'),
                                  Text('Player two: ${game!.playerTwo!.username}'),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ));
  }
}
