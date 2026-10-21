import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Renders the shared itsbits-flow logo (`assets/logo.svg` package asset of
/// `itsbits_shared` — the file lives once in the shared package and is picked
/// up by every instance app).
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 64, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    'packages/itsbits_shared/assets/logo.svg',
    width: size,
    height: size,
    colorFilter: color == null
        ? null
        : ColorFilter.mode(color!, BlendMode.srcIn),
  );
}
