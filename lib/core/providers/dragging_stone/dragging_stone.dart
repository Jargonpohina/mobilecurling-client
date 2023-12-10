import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dragging_stone.g.dart';

class DraggingStoneDetails {
  DraggingStoneDetails({required this.allowed, required this.speed, required this.direction});
  final bool allowed;
  final double speed;
  final double direction;
}

@Riverpod(keepAlive: true)
class DraggingStone extends _$DraggingStone {
  @override
  DraggingStoneDetails? build() {
    return null;
  }

  void update(DraggingStoneDetails details) {
    state = details;
  }
}
