import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilecurling/core/classes/lobby/lobby.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lobby.g.dart';

@Riverpod(keepAlive: true)
class LobbyManager extends _$LobbyManager {
  @override
  Lobby? build() {
    return null;
  }

  void update(Lobby lobby) {
    state = lobby;
  }
}
