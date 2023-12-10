import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'orientation.g.dart';

class PortraitMode {
  PortraitMode({required this.isPortrait});
  final bool isPortrait;
}

@Riverpod(keepAlive: true)
class PortraitManager extends _$PortraitManager {
  @override
  PortraitMode build() {
    return PortraitMode(isPortrait: false);
  }

  void toggle() {
    state = PortraitMode(isPortrait: !state.isPortrait);
  }
}
