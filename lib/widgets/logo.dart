import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobilecurling/core/theme/theme.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Logo extends StatelessWidget {
  const Logo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Image.asset(
            'assets/logo.png',
            width: min(MediaQuery.sizeOf(context).width / 2, 200),
          )
              .animate(onPlay: (controller) => controller.repeat(), delay: 2000.ms)
              .rotate(duration: 2000.ms, curve: Curves.easeInOutCubic)
              .then(delay: 2000.ms)
              .shimmer(duration: 1000.ms),
          SimpleShadow(
            offset: Offset.zero,
            color: const Color.fromARGB(255, 237, 206, 255),
            child: AutoSizeText(
              'MOBILE CURLING',
              style: ThemeDataCurling().darkTheme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600, color: const Color.fromARGB(255, 237, 206, 255)),
              maxLines: 1,
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .scale(duration: 2000.ms, begin: const Offset(1, 1), end: const Offset(1.1, 1.1), curve: Curves.easeInOutCirc)
              .then()
              .scale(duration: 2000.ms, begin: const Offset(1, 1), end: const Offset(0.9, 0.9), curve: Curves.easeInOutCirc),
          Text(
            'Created by Schamppu and Tikibeni',
            style: ThemeDataCurling().darkTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
