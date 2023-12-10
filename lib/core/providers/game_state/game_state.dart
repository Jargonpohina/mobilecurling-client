import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilecurling/core/shared_classes/game_state/game_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_state.g.dart';

@Riverpod(keepAlive: true)
class GameManager extends _$GameManager {
  @override
  GameState? build() {
    return null;
  }

  void update(GameState game) {
    state = game;
  }
}
