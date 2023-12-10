import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilecurling/core/providers/game_state/game_state.dart';
import 'package:mobilecurling/core/providers/lobby/lobby.dart';
import 'package:mobilecurling/core/providers/user/user.dart';
import 'package:mobilecurling/core/shared_classes/game_state/game_state.dart' as gs;
import 'package:mobilecurling/core/shared_classes/message/message.dart';
import 'package:mobilecurling/core/shared_classes/slide/slide.dart';
import 'package:mobilecurling/core/theme/theme.dart';
import 'package:mobilecurling/features/game/game_rendering.dart';
import 'package:mobilecurling/main.dart';
import 'package:mobilecurling/widgets/card_default.dart';
import 'package:uuid/uuid.dart';
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
  Offset drag = const Offset(0, 0);
  WebSocketChannel? channel;
  @override
  void initState() {
    super.initState();
    final id = const Uuid().v4();
    final uri = Uri.parse('wss://$gameServerUrl/game/$id');
    channel = WebSocketChannel.connect(uri);
    Future.delayed(const Duration(milliseconds: 500), () {
      channel!.sink.add(jsonEncode(
        Message(type: MessageType.join, user: ref.read(userManagerProvider), lobby: ref.read(lobbyManagerProvider)).toJson(),
      ));
      channel!.stream.listen((message) {
        final map = jsonDecode(message);
        ref.read(gameManagerProvider.notifier).update(gs.GameState.fromJson(map));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(gameManagerProvider);
    return Scaffold(
        body: Column(
      children: [
        //Text('Game: ${game != null ? game.lobby!.id : 'initializing ${ref.read(lobbyManagerProvider)!.id}'}'),
        game == null
            ? const Center(
                child: Column(
                  children: [
                    Text('Initializing the game...'),
                  ],
                ),
              )
            : (game.playerTwo == null && game.stones.isEmpty)
                ? const Center(child: Text('Waiting for player to join...'))
                : Expanded(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Center(
                              child: CardDefault(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      game.playerOneScore == game.playerTwoScore
                                          ? Text(
                                              'Game is tied',
                                              style: ThemeDataCurling().darkTheme.textTheme.bodyMedium!.copyWith(color: const Color.fromARGB(255, 247, 236, 136)),
                                            )
                                          : game.playerOneScore > game.playerTwoScore
                                              ? Text(
                                                  '${game.playerOne!.username} is winning!',
                                                  style: ThemeDataCurling().darkTheme.textTheme.bodyMedium!.copyWith(color: Colors.green[300]),
                                                )
                                              : Text(
                                                  '${game.playerTwo!.username} is winning!',
                                                  style: ThemeDataCurling().darkTheme.textTheme.bodyMedium!.copyWith(color: Colors.green[300]),
                                                ),
                                      Text('Player one: ${game.playerOne!.username}'),
                                      Text('Player two: ${game.playerTwo!.username}'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            game.stones.isNotEmpty
                                ? const Expanded(
                                    child: GameRendering(),
                                  )
                                : const SizedBox.shrink(),
                            CardDefault(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: (game.gameState == gs.State.started)
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          game.playerInTurn == ref.read(userManagerProvider)
                                              ? game.canSlide
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
                                                          game.playerOne == ref.read(userManagerProvider) ? 'assets/stone_one.png' : 'assets/stone_two.png',
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
                                    : game.gameState == gs.State.ended
                                        ? const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text('The winner is determined when the stones stops.'),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                game.playerOneScore == game.playerTwoScore
                                                    ? Text('The game was tied.',
                                                        style:
                                                            ThemeDataCurling().darkTheme.textTheme.bodyMedium!.copyWith(color: const Color.fromARGB(255, 247, 236, 136)))
                                                    : Text(
                                                        'The winner is ${game.playerOneScore > game.playerTwoScore ? game.playerOne!.username : game.playerTwo!.username}! Congratulations.',
                                                        style: ThemeDataCurling().darkTheme.textTheme.bodyMedium!.copyWith(color: Colors.green[300])),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: const Row(
                                                        children: [
                                                          Icon(Icons.exit_to_app),
                                                          Text('Exit the game'),
                                                        ],
                                                      )),
                                                )
                                              ],
                                            ),
                                          ),
                              ),
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
