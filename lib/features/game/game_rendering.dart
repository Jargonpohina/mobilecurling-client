import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilecurling/features/game/flame/game_world.dart';
import 'package:flame/game.dart';

class GameRendering extends ConsumerWidget {
  const GameRendering({
    super.key,
    this.isPortrait = false,
  });
  final bool isPortrait;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GameWidget(
      autofocus: false,
      game: GameWorld(width: 4572, height: 500, isPortrait: isPortrait, ref: ref),
      backgroundBuilder: (context) {
        return const SizedBox.shrink();
      },
    );
  }
}
