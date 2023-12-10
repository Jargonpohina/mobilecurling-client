import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilecurling/features/game/flame/game_world.dart';
import 'package:flame/game.dart';

class GameRendering extends ConsumerWidget {
  const GameRendering({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GameWidget(
      autofocus: false,
      game: GameWorld(width: 4572, height: 500, ref: ref),
      backgroundBuilder: (context) {
        return const SizedBox.shrink();
      },
    );
    /*
    return ClipRect(
      child: LayoutBuilder(builder: (context, constraints) {
        bool isPortrait = true;
        final field = PlayingField(
          originalWidth: 500,
          originalHeight: 4572,
          screenWidth: constraints.maxWidth,
          screenHeight: constraints.maxHeight,
          portraitOrientation: isPortrait,
          stoneSize: 64,
        );
        final stoneSize = field.getStoneSize;
        // 3657.6
        // säde 182.88
        return Stack(
          children: [
            Container(
              width: field.getSize.width,
              height: field.getSize.height,
              color: Colors.white,
            ),
            /*
            Transform.translate(
              offset: Offset((constraints.maxWidth / 2 + (constraints.maxWidth * (182.88 / width))) * (182.88 / width), (constraints.maxHeight) * (1 - (3657.6 / height))),
              child: Container(
                width: (constraints.maxWidth) * (182.88 / width),
                height: (constraints.maxWidth) * (182.88 / width),
                decoration: BoxDecoration(color: Colors.red.withOpacity(0.3), borderRadius: BorderRadius.circular(10000)),
              ),
            ),
            */
            for (final stone in game!.stones)
              SimpleShadow(
                opacity: 0.3,
                child: Transform.translate(
                  offset: Offset((field.getSize.width - stoneSize) * ((isPortrait ? stone.y : stone.x) / field.originalWidth),
                      (field.getSize.height - stoneSize) * (1.0 - ((isPortrait ? stone.x : stone.y) / field.originalHeight))),
                  child: Image.asset(
                    game!.playerOne == stone.user ? 'assets/stone_one.png' : 'assets/stone_two.png',
                    width: stoneSize,
                    height: stoneSize,
                    filterQuality: FilterQuality.none,
                    scale: 1,
                  ),
                ),
              ),
          ],
        );
      }),
    );
    */
  }
}
