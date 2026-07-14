import 'package:flutter/material.dart';

/// Wraps a banner/notice so it slides+fades in when [visible] becomes
/// true and slides+fades out when it becomes false.
///
/// Intended for body-level notice banners (cached form, submit error,
/// network warning). Avoid using inside an appBar slot whose
/// preferredSize is computed from the same condition — the size jump
/// would race the animation.
class AnimatedNotice extends StatelessWidget {
  final bool visible;
  final Widget child;
  final Duration duration;

  const AnimatedNotice({
    required this.visible,
    required this.child,
    this.duration = const Duration(milliseconds: 220),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return SizeTransition(
          sizeFactor: animation,
          axisAlignment: -1,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: visible
          ? KeyedSubtree(
              key: const ValueKey('notice-visible'),
              child: child,
            )
          : const SizedBox.shrink(key: ValueKey('notice-hidden')),
    );
  }
}

/// One-shot mount animation for empty-state illustrations. Fades and
/// scales up gently when the widget first appears, then stays put.
class EmptyStateAppear extends StatelessWidget {
  final Widget child;
  final Duration duration;

  const EmptyStateAppear({
    required this.child,
    this.duration = const Duration(milliseconds: 360),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, t, child) {
        return Opacity(
          opacity: t,
          child: Transform.scale(
            scale: 0.94 + 0.06 * t,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
