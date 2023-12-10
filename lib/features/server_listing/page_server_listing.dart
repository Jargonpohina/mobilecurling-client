import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilecurling/core/providers/lobby/lobby.dart';
import 'package:mobilecurling/core/providers/user/user.dart';
import 'package:mobilecurling/core/shared_classes/lobby/lobby.dart';
import 'package:mobilecurling/core/theme/theme.dart';
import 'package:mobilecurling/features/game/page_game.dart';
import 'package:mobilecurling/main.dart';
import 'package:uuid/uuid.dart';

class PageServerListing extends ConsumerStatefulWidget {
  const PageServerListing({
    super.key,
  });

  @override
  ConsumerState<PageServerListing> createState() => _PageServerListingState();
}

class _PageServerListingState extends ConsumerState<PageServerListing> {
  final List<Lobby> lobbies = [];

  @override
  void initState() {
    super.initState();
    loadLobbies();
  }

  Future<void> createLobby() async {
    final lobby = Lobby(id: const Uuid().v4(), playerOne: ref.read(userManagerProvider).username, playerTwo: null);
    final response = await dio.post('$lobbyServerUrl/lobby', data: lobby.toJson());
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
    final response = await dio.get('$lobbyServerUrl/lobby');
    if (response.statusCode == 200) {
      if (response.data != null) {
        final map = jsonDecode(response.data) as Map;
        for (final lobby in map.entries) {
          final lobbyObj = Lobby.fromJson(lobby.value as Map<String, Object?>);
          lobbies.add(lobbyObj);
        }
      }
    }
    setState(() {
      // Force refresh
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'MOBILE CURLING',
                  style: ThemeDataCurling().darkTheme.textTheme.titleLarge,
                ),
              ],
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
          Row(
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
                      Text('Create lobby'),
                    ],
                  )),
            ],
          ),
          Column(
            children: [
              for (final lobby in lobbies)
                Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text('Server ID: ${lobby.id}'),
                          Text('Creator: ${lobby.playerOne}'),
                          lobby.playerTwo == null
                              ? Text(
                                  'OPEN',
                                  style: ThemeDataCurling().darkTheme.textTheme.bodyMedium!.copyWith(color: Colors.green),
                                )
                              : Text('Against: ${lobby.playerTwo}'),
                          lobby.playerTwo == null
                              ? ElevatedButton(
                                  onPressed: () {
                                    ref.read(lobbyManagerProvider.notifier).update(lobby);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const PageGame(),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.arrow_forward,
                                        color: Colors.green,
                                      ),
                                      Text(
                                        'Join',
                                        style: ThemeDataCurling().darkTheme.textTheme.bodyMedium!.copyWith(color: Colors.green),
                                      ),
                                    ],
                                  ))
                              : const SizedBox.shrink(),
                        ],
                      ),
                    )),
            ],
          ),
        ],
      ),
    ));
  }
}
