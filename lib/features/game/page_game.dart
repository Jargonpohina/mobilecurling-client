import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilecurling/core/providers/dragging_stone/dragging_stone.dart';
import 'package:mobilecurling/core/providers/game_state/game_state.dart';
import 'package:mobilecurling/core/providers/lobby/lobby.dart';
import 'package:mobilecurling/core/providers/orientation/orientation.dart';
import 'package:mobilecurling/core/providers/user/user.dart';
import 'package:mobilecurling/core/shared_classes/game_state/game_state.dart'
    as gs;
import 'package:mobilecurling/core/shared_classes/message/message.dart';
import 'package:mobilecurling/core/shared_classes/slide/slide.dart';
import 'package:mobilecurling/core/shared_classes/user/user.dart';
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
  GlobalKey dragButtonKey = GlobalKey();
  bool isPortrait = false;
  @override
  void initState() {
    super.initState();
    final id = const Uuid().v4();
    final uri = Uri.parse('wss://$gameServerUrl/game/$id');
    channel = WebSocketChannel.connect(uri);
    Future.delayed(const Duration(milliseconds: 500), () {
      channel!.sink.add(jsonEncode(
        Message(
                type: MessageType.join,
                user: ref.read(userManagerProvider),
                lobby: ref.read(lobbyManagerProvider))
            .toJson(),
      ));
      channel!.stream.listen((message) {
        final map = jsonDecode(message);
        ref
            .read(gameManagerProvider.notifier)
            .update(gs.GameState.fromJson(map));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(gameManagerProvider);
    return Scaffold(
        body: Column(
      children: [
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          game.playerOneScore ==
                                                  game.playerTwoScore
                                              ? Text(
                                                  'Game is tied',
                                                  style: ThemeDataCurling()
                                                      .darkTheme
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          color: const Color
                                                              .fromARGB(255,
                                                              247, 236, 136)),
                                                )
                                              : game.playerOneScore >
                                                      game.playerTwoScore
                                                  ? Text(
                                                      '${game.playerOne!.username} is winning!',
                                                      style: ThemeDataCurling()
                                                          .darkTheme
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color: Colors
                                                                  .green[300]),
                                                    )
                                                  : Text(
                                                      '${game.playerTwo!.username} is winning!',
                                                      style: ThemeDataCurling()
                                                          .darkTheme
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color: Colors
                                                                  .green[300]),
                                                    ),
                                          Row(
                                            children: [
                                              Text(
                                                  'Player one: ${game.playerOne!.username} '),
                                              const Icon(
                                                Icons.star,
                                                size: 16,
                                                color: Color.fromARGB(
                                                    255, 248, 150, 245),
                                              ),
                                              Text(
                                                ' ${game.playerOne!.score}',
                                                style: ThemeDataCurling()
                                                    .darkTheme
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              248,
                                                              150,
                                                              245),
                                                    ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                  'Player two: ${game.playerTwo!.username} '),
                                              const Icon(
                                                Icons.star,
                                                size: 16,
                                                color: Color.fromARGB(
                                                    255, 248, 150, 245),
                                              ),
                                              Text(
                                                ' ${game.playerTwo!.score}',
                                                style: ThemeDataCurling()
                                                    .darkTheme
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              248,
                                                              150,
                                                              245),
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          ref
                                              .read(portraitManagerProvider
                                                  .notifier)
                                              .toggle();
                                        },
                                        style: ElevatedButton.styleFrom(),
                                        icon: const Icon(
                                          Icons.rotate_90_degrees_ccw,
                                          size: 32,
                                        ),
                                      )
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          game.playerInTurn ==
                                                  ref.read(userManagerProvider)
                                              ? game.canSlide
                                                  ? StoneDragControl(
                                                      dragButtonKey:
                                                          dragButtonKey,
                                                      channel: channel,
                                                      game: game)
                                                  : const Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text(
                                                          'Wait until stones have stopped.'),
                                                    )
                                              : const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                      'Wait for your turn.'),
                                                ),
                                        ],
                                      )
                                    : game.gameState == gs.State.ended
                                        ? const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                                'The winner is determined when the stones stops.'),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                game.playerOneScore ==
                                                        game.playerTwoScore
                                                    ? Text('The game was tied.',
                                                        style: ThemeDataCurling()
                                                            .darkTheme
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                                color:
                                                                    const Color.fromARGB(
                                                                        255,
                                                                        247,
                                                                        236,
                                                                        136)))
                                                    : Text(
                                                        'The winner is ${game.playerOneScore > game.playerTwoScore ? game.playerOne!.username : game.playerTwo!.username}! Congratulations.',
                                                        style: ThemeDataCurling()
                                                            .darkTheme
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                                color: Colors
                                                                    .green[300])),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ElevatedButton(
                                                      onPressed: () async {
                                                        try {
                                                          final response =
                                                              await dio.post(
                                                            '$authServerUrl/login',
                                                            data: jsonEncode(User(
                                                                    username: ref
                                                                        .read(
                                                                            userManagerProvider)
                                                                        .username,
                                                                    password: ref
                                                                        .read(
                                                                            userManagerProvider)
                                                                        .password)
                                                                .toJson()),
                                                          );
                                                          if (response.statusCode ==
                                                                  200 &&
                                                              context.mounted) {
                                                            ref
                                                                .read(userManagerProvider
                                                                    .notifier)
                                                                .update(User.fromJson(
                                                                    jsonDecode(
                                                                        response
                                                                            .data)));
                                                          }
                                                        } catch (e) {
                                                          // Do nothing.
                                                        }
                                                        if (context.mounted) {
                                                          Navigator.of(context)
                                                              .pop();
                                                        }
                                                      },
                                                      child: const Row(
                                                        children: [
                                                          Icon(Icons
                                                              .exit_to_app),
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

class StoneDragControl extends ConsumerStatefulWidget {
  const StoneDragControl({
    super.key,
    required this.dragButtonKey,
    required this.channel,
    required this.game,
  });

  final GlobalKey<State<StatefulWidget>> dragButtonKey;
  final WebSocketChannel? channel;
  final gs.GameState? game;

  @override
  ConsumerState<StoneDragControl> createState() => _StoneDragControlState();
}

class _StoneDragControlState extends ConsumerState<StoneDragControl> {
  bool allowed = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: Column(
        children: [
          Draggable(
            key: widget.dragButtonKey,
            onDragUpdate: (details) {
              RenderBox box = widget.dragButtonKey.currentContext!
                  .findRenderObject() as RenderBox;
              Offset pos = box.localToGlobal(Offset.zero);
              final from = pos.toVector2();
              final to = details.globalPosition.toVector2();
              double direction =
                  ((details.globalPosition - pos).direction) * (180 / pi) + 90;
              if (direction < 0) {
                direction = 360 + direction;
              }
              final distance = from.distanceTo(to);
              final speed = distance;
              // print('$direction $distance');
              if ((direction < 90 || direction > 270) &&
                  speed > 60 &&
                  speed < 300) {
                if (!allowed) {
                  setState(() {
                    allowed = true;
                  });
                }
              } else {
                if (allowed) {
                  setState(() {
                    allowed = false;
                  });
                }
              }
              ref.read(draggingStoneProvider.notifier).update(
                  DraggingStoneDetails(
                      allowed: allowed, speed: speed, direction: direction));
            },
            onDragEnd: (details) {
              if (allowed) {
                if (widget.channel != null) {
                  widget.channel!.sink.add(jsonEncode(
                    Message(
                            type: MessageType.slide,
                            user: ref.read(userManagerProvider),
                            lobby: ref.read(lobbyManagerProvider),
                            slide: Slide(
                                angle:
                                    ref.read(draggingStoneProvider)!.direction,
                                speed: ref.read(draggingStoneProvider)!.speed,
                                user: ref.read(userManagerProvider)))
                        .toJson(),
                  ));
                }
              }
            },
            childWhenDragging: Opacity(
              opacity: 0.3,
              child: Image.asset(
                widget.game!.playerOne == ref.read(userManagerProvider)
                    ? 'assets/stone_one.png'
                    : 'assets/stone_two.png',
                width: 64,
                height: 64,
                filterQuality: FilterQuality.none,
                scale: 0.01,
                color: allowed ? null : Colors.red.withOpacity(0.5),
              ),
            ),
            feedback: DraggingStone(
              game: widget.game!,
              data: MediaQueryData.fromView(View.of(context)),
            ),
            child: Image.asset(
              widget.game!.playerOne == ref.read(userManagerProvider)
                  ? 'assets/stone_one.png'
                  : 'assets/stone_two.png',
              width: 64,
              height: 64,
              filterQuality: FilterQuality.none,
              scale: 0.01,
            ),
          ),
          const Card(
              child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Towards goal is 0° or 360°'),
          )),
        ],
      ),
    );
  }
}

class DraggingStone extends ConsumerWidget {
  const DraggingStone({
    super.key,
    required this.game,
    required this.data,
  });

  final gs.GameState game;
  final MediaQueryData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(draggingStoneProvider);
    return details != null
        ? Transform.translate(
            offset: const Offset(-16, -8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  game.playerOne == ref.read(userManagerProvider)
                      ? 'assets/stone_one.png'
                      : 'assets/stone_two.png',
                  width: 64,
                  height: 64,
                  filterQuality: FilterQuality.none,
                  scale: 0.01,
                  color: details.allowed ? null : Colors.red.withOpacity(0.5),
                ),
                Text(
                  'Speed: ${(details.speed).toStringAsFixed(2)} cm/s',
                  style: ThemeDataCurling()
                      .darkTheme
                      .textTheme
                      .bodyMedium!
                      .copyWith(
                          color: details.allowed ? null : Colors.red[300]),
                ),
                Text(
                  'Direction: ${(details.direction).toStringAsFixed(0)}°',
                  style: ThemeDataCurling()
                      .darkTheme
                      .textTheme
                      .bodyMedium!
                      .copyWith(
                          color: details.allowed ? null : Colors.red[300]),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
