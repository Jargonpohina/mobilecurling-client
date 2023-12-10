import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilecurling/core/shared_classes/user/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user.g.dart';

@Riverpod(keepAlive: true)
class UserManager extends _$UserManager {
  @override
  User build() {
    return const User(username: '', password: '');
  }

  void update(User user) {
    state = user;
  }
}
