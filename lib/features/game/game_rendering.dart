import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilecurling/core/providers/orientation/orientation.dart';
import 'package:mobilecurling/features/game/flame/game_world.dart';
import 'package:flame/game.dart';

class GameRendering extends ConsumerWidget {
  const GameRendering({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(portraitManagerProvider);
    return GameWidget(
      autofocus: false,
      game: GameWorld(width: 4572, height: 500, isPortrait: mode.isPortrait, ref: ref),
      backgroundBuilder: (context) {
        return const SizedBox.shrink();
      },
    );
  }
}
