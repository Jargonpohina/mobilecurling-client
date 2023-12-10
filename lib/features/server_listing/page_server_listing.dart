import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilecurling/core/providers/lobby/lobby.dart';
import 'package:mobilecurling/core/providers/user/user.dart';
import 'package:mobilecurling/core/shared_classes/lobby/lobby.dart';
import 'package:mobilecurling/core/theme/theme.dart';
import 'package:mobilecurling/features/game/page_game.dart';
import 'package:mobilecurling/main.dart';
import 'package:mobilecurling/widgets/card_default.dart';
import 'package:mobilecurling/widgets/logo.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class PageServerListing extends ConsumerStatefulWidget {
  const PageServerListing({
    super.key,
  });

  @override
  ConsumerState<PageServerListing> createState() => _PageServerListingState();
}

class _PageServerListingState extends ConsumerState<PageServerListing> {
  final List<Lobby> lobbies = [];
  String? errorText;
  String key = '';

  @override
  void initState() {
    super.initState();
    loadLobbies();
    key = const Uuid().v4();
  }

  Future<void> joinLobby(Lobby lobby) async {
    try {
      final response = await dio.post('$lobbyServerUrl/lobby/join', data: lobby.toJson(), options: Options(headers: {'Access-Control-Allow-Origin': '*'}));
      final responseLobby = Lobby.fromJson(jsonDecode(response.data));
      ref.read(lobbyManagerProvider.notifier).update(responseLobby);
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const PageGame(),
          ),
        );
      }
    } catch (e) {
      print(e);
      setState(() {
        errorText = 'Failed to join lobby. Please refresh the list.';
      });
    }
  }

  Future<void> createLobby() async {
    final lobby = Lobby(id: const Uuid().v4(), playerOne: ref.read(userManagerProvider), playerTwo: null, createdAt: DateTime.now());
    final response = await dio.post('$lobbyServerUrl/lobby', data: lobby.toJson(), options: Options(headers: {'Access-Control-Allow-Origin': '*'}));
    ref.read(lobbyManagerProvider.notifier).update(lobby);
    if (response.statusCode == 200 && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const PageGame(),
        ),
      );
    }
  }

  Future<void> loadLobbies() async {
    lobbies.clear();
    final response = await dio.get('$lobbyServerUrl/lobby', options: Options(headers: {'Access-Control-Allow-Origin': '*'}));
    if (response.statusCode == 200) {
      if (response.data is String) {
        if ((response.data as String).isNotEmpty) {
          final map = jsonDecode(response.data) as Map;
          for (final lobby in map.entries) {
            final lobbyObj = Lobby.fromJson(lobby.value as Map<String, Object?>);
            lobbies.add(lobbyObj);
          }
        }
      }
    }
    setState(() {
      key = const Uuid().v4();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userManagerProvider);
    return Scaffold(
        body: Stack(
      children: [
        SingleChildScrollView(
          key: Key(key),
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            children: [
              const Logo(),
              CardDefault(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Welcome, ${user.username}',
                            style: ThemeDataCurling().darkTheme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Your Score: ',
                            style: ThemeDataCurling().darkTheme.textTheme.bodyMedium!.copyWith(color: Color.fromARGB(255, 245, 186, 255), fontSize: 16),
                          ),
                          const Icon(
                            Icons.star,
                            color: Color.fromARGB(255, 245, 186, 255),
                            size: 16,
                          ),
                          Text(
                            ' ${user.score}'.toUpperCase(),
                            style: ThemeDataCurling().darkTheme.textTheme.bodyMedium!.copyWith(color: Color.fromARGB(255, 245, 186, 255), fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              CardDefault(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            await loadLobbies();
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.refresh),
                              Text('Refresh'),
                            ],
                          )),
                      ElevatedButton(
                          onPressed: () async {
                            await createLobby();
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add),
                              Text('Create game'),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Lobbies (${lobbies.length})'.toUpperCase(),
                      style: ThemeDataCurling().darkTheme.textTheme.displayMedium,
                    ),
                  ],
                ),
              ),
              lobbies.isNotEmpty
                  ? Column(
                      children: [
                        for (var i = 0; i < lobbies.length; i++)
                          CardDefault(
                              key: UniqueKey(),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text('Server ID: ${lobbies[i].id}'),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text('Created at:  '),
                                        Text(DateFormat('HH:mm d.M.y').format(lobbies[i].createdAt),
                                            style: ThemeDataCurling().darkTheme.textTheme.bodyMedium!.copyWith(color: Color.fromARGB(255, 214, 112, 214), fontSize: 14)),
                                      ],
                                    ),
                                    Text('Creator: ${lobbies[i].playerOne.username}',
                                        style: ThemeDataCurling().darkTheme.textTheme.bodyMedium!.copyWith(color: Color.fromARGB(255, 226, 183, 226), fontSize: 16)),
                                    lobbies[i].playerTwo == null
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SimpleShadow(
                                              offset: Offset.zero,
                                              opacity: 0.6,
                                              child: Text(
                                                'OPEN',
                                                style: ThemeDataCurling()
                                                    .darkTheme
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(color: Colors.green[300], fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 2),
                                              ),
                                            ),
                                          )
                                        : Text('Against: ${lobbies[i].playerTwo!.username}',
                                            style: ThemeDataCurling().darkTheme.textTheme.bodyMedium!.copyWith(color: Color.fromARGB(255, 226, 183, 226), fontSize: 16)),
                                    lobbies[i].playerTwo == null
                                        ? ElevatedButton(
                                            onPressed: () async {
                                              await joinLobby(lobbies[i].copyWith(playerTwo: ref.read(userManagerProvider)));
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.arrow_forward,
                                                  color: Colors.green[300],
                                                ),
                                                Text(
                                                  'Join',
                                                  style: ThemeDataCurling().darkTheme.textTheme.bodyMedium!.copyWith(color: Colors.green[300]),
                                                ),
                                              ],
                                            ))
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                              )).animate(delay: 200.ms * i).slideX(duration: 400.ms, begin: -0.2, end: 0.0, curve: Curves.easeOutCirc).fadeIn(duration: 400.ms),
                      ],
                    )
                  : const Padding(
                      padding: EdgeInsets.only(top: 32.0),
                      child: Text('No lobbies found. Refresh or create a lobby'),
                    ),
            ],
          ),
        ),
        errorText != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: CardDefault(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Text(
                        errorText!,
                        textAlign: TextAlign.center,
                        style: ThemeDataCurling().darkTheme.textTheme.bodyMedium!.copyWith(color: Colors.red[300]),
                      )),
                    )),
                  )
                ],
              )
            : const SizedBox.shrink(),
      ],
    ));
  }
}
