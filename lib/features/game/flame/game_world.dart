import 'dart:math';

import 'package:flame/cache.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilecurling/core/providers/game_state/game_state.dart';
import 'package:mobilecurling/core/providers/user/user.dart';
import 'package:mobilecurling/core/shared_classes/stone/stone.dart';

class GameWorld extends FlameGame {
  GameWorld({required this.width, required this.height, this.isPortrait = false, required this.ref});
  final double width;
  final double height;
  final bool isPortrait;
  final WidgetRef ref;

  @override
  material.Color backgroundColor() => material.Colors.transparent;

  @override
  Future<void> onLoad() async {
    final List<StoneObj> objects = [];
    if (isPortrait) {
      camera = CameraComponent.withFixedResolution(width: height, height: width);
      camera.moveTo(Vector2(height / 2, width / 2));
      final stones = ref.read(gameManagerProvider)!.stones;
      world.add(Sheet(width: height, height: width, isPortrait: isPortrait, ref: ref));
      for (final stone in stones) {
        objects.add(StoneObj(width: height, height: width, stone: stone, isPortrait: isPortrait, ref: ref));
      }
      for (final stone in objects) {
        world.add(stone);
      }
    } else {
      camera = CameraComponent.withFixedResolution(width: width, height: height);
      camera.moveTo(Vector2(width / 2, height / 2));
      final stones = ref.read(gameManagerProvider)!.stones;
      world.add(Sheet(width: width, height: height, isPortrait: isPortrait, ref: ref));
      for (final stone in stones) {
        print('added stone');
        objects.add(StoneObj(width: width, height: height, stone: stone, isPortrait: isPortrait, ref: ref));
      }
      for (final stone in objects) {
        world.add(stone);
      }
    }
  }
}

class Sheet extends PositionComponent {
  Sheet({required this.width, required this.height, this.isPortrait = true, required this.ref});
  final double width;
  final double height;
  final bool isPortrait;
  final WidgetRef ref;

  @override
  void update(double dt) {}

  @override
  Future<void> onLoad() async {
    final paintIce = Paint()..color = material.Colors.white;
    final sheet = RectangleComponent.fromRect(Rect.fromLTRB(0, 0, width, height), paint: paintIce);
    final paintGoalRed = Paint()..color = material.Colors.red.withOpacity(0.2);
    final goalRed =
        CircleComponent(radius: 182.22, paint: paintGoalRed, position: isPortrait ? Vector2(250, height - 3657.6) : Vector2(3657.6, 250), anchor: Anchor.center);
    final paintGoalWhiteOuter = Paint()..color = material.Colors.white;
    final goalWhiteOuter =
        CircleComponent(radius: 130, paint: paintGoalWhiteOuter, position: isPortrait ? Vector2(250, height - 3657.6) : Vector2(3657.6, 250), anchor: Anchor.center);
    final paintGoalBlue = Paint()..color = material.Colors.blue.withOpacity(0.2);
    final goalBlue =
        CircleComponent(radius: 80, paint: paintGoalBlue, position: isPortrait ? Vector2(250, height - 3657.6) : Vector2(3657.6, 250), anchor: Anchor.center);
    final paintGoalWhiteInner = Paint()..color = material.Colors.white;
    final goalWhiteInner =
        CircleComponent(radius: 30, paint: paintGoalWhiteInner, position: isPortrait ? Vector2(250, height - 3657.6) : Vector2(3657.6, 250), anchor: Anchor.center);
    add(sheet);
    add(goalRed);
    add(goalWhiteOuter);
    add(goalBlue);
    add(goalWhiteInner);
  }
}

class StoneObj extends PositionComponent {
  StoneObj({required this.width, required this.height, required this.stone, this.isPortrait = true, required this.ref});
  final double width;
  final double height;
  final StoneAPI stone;
  final bool isPortrait;
  final WidgetRef ref;
  late Vector2 lastPosition;

  @override
  void update(double dt) {
    final thisStone = ref.read(gameManagerProvider)!.stones.firstWhere((element) => element.id == stone.id);
    if (isPortrait) {
      position = Vector2(thisStone.y, height - thisStone.x);
    } else {
      position = Vector2(thisStone.x, thisStone.y);
    }
    if (thisStone.x == 548.64 && thisStone.y == 250) {
      if (thisStone.user != ref.read(userManagerProvider)) {
        position = Vector2(-1000, -1000);
      }
      if (isPortrait) {
        angle = 90 * (pi / 180);
      } else {
        angle = 180 * (pi / 180);
      }
    }
    angle += min(position.distanceTo(lastPosition) * 0.005, 0.1);
    lastPosition = Vector2(position.x, position.y);
  }

  @override
  Future<void> onLoad() async {
    lastPosition = Vector2(stone.x, stone.y);
    final images = Images(prefix: 'assets/');
    if (stone.user == ref.read(gameManagerProvider)!.playerOne) {
      final playerOneSprite = SpriteComponent.fromImage(
        await images.load('stone_one.png'),
        size: Vector2(64, 64),
        scale: Vector2(1, 1),
        anchor: Anchor.center,
      );
      add(playerOneSprite);
    }
    if (stone.user == ref.read(gameManagerProvider)!.playerTwo) {
      final playerTwoSprite = SpriteComponent.fromImage(
        await images.load('stone_two.png'),
        size: Vector2(64, 64),
        scale: Vector2(1, 1),
        anchor: Anchor.center,
      );
      add(playerTwoSprite);
    }
  }
}
