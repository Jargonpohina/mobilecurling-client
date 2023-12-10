import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilecurling/core/classes/game_state/game_state.dart';
import 'package:mobilecurling/core/classes/message/message.dart';
import 'package:mobilecurling/core/classes/slide/slide.dart';
import 'package:mobilecurling/core/providers/lobby/lobby.dart';
import 'package:mobilecurling/core/providers/user/user.dart';
import 'package:mobilecurling/main.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:simple_shadow/simple_shadow.dart';

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
  Offset drag = const Offset(0, 0);
  WebSocketChannel? channel;
  @override
  void initState() {
    super.initState();
    final id = const Uuid().v4();
    final uri = Uri.parse('ws://$gameServerUrl/game/$id');
    channel = WebSocketChannel.connect(uri);
    Future.delayed(Duration.zero, () {
      channel!.sink.add(jsonEncode(
        Message(type: MessageType.join, user: ref.read(userManagerProvider), lobby: ref.read(lobbyManagerProvider)).toJson(),
      ));
      channel!.stream.listen((message) {
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
        body: Column(
      children: [
        Text('Game: ${game != null ? game!.lobby!.id : 'initializing ${ref.read(lobbyManagerProvider)!.id}'}'),
        game == null
            ? const Center(
                child: Column(
                  children: [
                    Text('Initializing the game...'),
                  ],
                ),
              )
            : game!.playerTwo == null
                ? const Center(child: Text('Waiting for player to join...'))
                : Expanded(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Center(
                              child: Card(
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
                              ),
                            ),
                            Expanded(
                              child: LayoutBuilder(builder: (context, constraints) {
                                // 3657.6
                                // säde 182.88
                                const double height = 4572.0;
                                const double width = 500.0;
                                return Stack(
                                  children: [
                                    Container(
                                      width: constraints.maxWidth,
                                      height: constraints.maxHeight,
                                      color: Colors.white,
                                    ),
                                    Transform.translate(
                                      offset: Offset((constraints.maxWidth / 2 + (constraints.maxWidth * (182.88 / width))) * (182.88 / width),
                                          (constraints.maxHeight) * (1 - (3657.6 / height))),
                                      child: Container(
                                        width: (constraints.maxWidth) * (182.88 / width),
                                        height: (constraints.maxWidth) * (182.88 / width),
                                        decoration: BoxDecoration(color: Colors.red.withOpacity(0.3), borderRadius: BorderRadius.circular(10000)),
                                      ),
                                    ),
                                    for (final stone in game!.stones)
                                      SimpleShadow(
                                        opacity: 0.3,
                                        child: Transform.translate(
                                          offset: Offset((constraints.maxWidth - 32) * (stone.y / width), (constraints.maxHeight - 32) * (1.0 - (stone.x / height))),
                                          child: Image.asset(
                                            game!.playerOne == stone.user ? 'assets/stone_one.png' : 'assets/stone_two.png',
                                            width: 32,
                                            height: 32,
                                            filterQuality: FilterQuality.none,
                                            scale: 0.01,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              }),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                game!.playerInTurn == ref.read(userManagerProvider)
                                    ? game!.canSlide
                                        ? Padding(
                                            padding: const EdgeInsets.only(bottom: 32.0),
                                            child: GestureDetector(
                                              onPanStart: (details) {
                                                drag = const Offset(0, 0);
                                              },
                                              onPanUpdate: (details) {
                                                drag += details.delta;
                                              },
                                              onPanEnd: (details) {
                                                double direction = (drag.direction * (180 / pi) + 90);
                                                if (direction < 0) {
                                                  direction = 360 + direction;
                                                }
                                                double velocity = details.velocity.pixelsPerSecond.dx.abs() + details.velocity.pixelsPerSecond.dy.abs();
                                                velocity = velocity / 15;
                                                if (channel != null) {
                                                  channel!.sink.add(jsonEncode(
                                                    Message(
                                                            type: MessageType.slide,
                                                            user: ref.read(userManagerProvider),
                                                            lobby: ref.read(lobbyManagerProvider),
                                                            slide: Slide(angle: direction, speed: velocity, user: ref.read(userManagerProvider)))
                                                        .toJson(),
                                                  ));
                                                }
                                              },
                                              child: Image.asset(
                                                game!.playerOne == ref.read(userManagerProvider) ? 'assets/stone_one.png' : 'assets/stone_two.png',
                                                width: 64,
                                                height: 64,
                                                filterQuality: FilterQuality.none,
                                                scale: 0.01,
                                              ),
                                            ),
                                          )
                                        : const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text('Wait until stones have stopped.'),
                                          )
                                    : const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Wait for your turn.'),
                                      ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
      ],
    ));
  }
}
