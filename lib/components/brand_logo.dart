import 'dart:ui';

import 'package:flutter/material.dart';

/// LAHIS crest in the "glass panel" treatment from design handoff.
///
/// Structure (login / onboarding sizes differ):
/// 1. Outer glass frame — translucent fill, hairline, blur, drop shadow
/// 2. Inner solid white tile — blends logo white bg so the shield reads cleanly
/// 3. Crest image — contain-fit inside the tile
///
/// Handoff note: with a true transparent-background mark, the inner white tile
/// can later be dropped so glass shows through around the shield path.
class BrandLogo extends StatelessWidget {
  /// Outer glass frame corner radius.
  final double outerRadius;

  /// Inner white tile corner radius.
  final double innerRadius;

  /// Solid white tile edge length (logo is 100% of this).
  final double tileSize;

  /// Padding between glass frame and white tile.
  final double framePadding;

  const BrandLogo({
    super.key,
    this.outerRadius = 34,
    this.innerRadius = 22,
    this.tileSize = 120,
    this.framePadding = 10,
  });

  /// Welcome / onboarding strip.
  const BrandLogo.compact({
    super.key,
    this.outerRadius = 24,
    this.innerRadius = 16,
    this.tileSize = 76,
    this.framePadding = 10,
  });

  @override
  Widget build(BuildContext context) {
    final outerSize = tileSize + framePadding * 2;
    final outerR = BorderRadius.circular(outerRadius);
    final innerR = BorderRadius.circular(innerRadius);

    return Container(
      width: outerSize,
      height: outerSize,
      decoration: BoxDecoration(
        borderRadius: outerR,
        // 0 16px 34px rgba(0,0,0,.3)
        boxShadow: const [
          BoxShadow(
            color: Color(0x4D000000),
            blurRadius: 34,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: outerR,
        child: BackdropFilter(
          // backdrop-filter: blur(6px)
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            width: outerSize,
            height: outerSize,
            padding: EdgeInsets.all(framePadding),
            decoration: BoxDecoration(
              borderRadius: outerR,
              // rgba(255,255,255,.10)
              color: const Color(0x1AFFFFFF),
              // 1px border rgba(255,255,255,.28)
              border: Border.all(
                color: const Color(0x47FFFFFF),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: innerR,
              child: ColoredBox(
                color: Colors.white,
                child: SizedBox(
                  width: tileSize,
                  height: tileSize,
                  child: Image.asset(
                    // Prefer transparent mark; white tile still covers residual bg.
                    'assets/images/logo_mark.png',
                    width: tileSize,
                    height: tileSize,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    isAntiAlias: true,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
