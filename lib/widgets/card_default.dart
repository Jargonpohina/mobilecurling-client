import 'package:flutter/material.dart';

class CardDefault extends StatelessWidget {
  const CardDefault({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Card(
          elevation: 10,
          child: child,
        ));
  }
}
