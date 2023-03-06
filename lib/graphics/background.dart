import 'package:flutter/material.dart';

class MagvetoBackground extends StatelessWidget {
  final Widget? child;
  const MagvetoBackground({
    this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/other/texture.png'),
          repeat: ImageRepeat.repeat,
        ),
      ),
      child: Container(
        color: Colors.black.withOpacity(0.3),
        child: child,
      ),
    );
  }
}

class MagvetoScaffold extends StatelessWidget {
  final Widget child;
  const MagvetoScaffold({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: MagvetoBackground(
        child: SafeArea(
          child: child,
        ),
      ),
    );
  }
}
