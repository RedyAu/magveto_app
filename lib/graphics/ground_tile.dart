import 'dart:math';

import 'package:flutter/material.dart';
import '../logic/index.dart';

class GroundTileWidget extends StatefulWidget {
  final GroundTile tile;

  const GroundTileWidget(this.tile, {Key? key}) : super(key: key);

  @override
  State<GroundTileWidget> createState() => _GroundTileWidgetState();
}

class _GroundTileWidgetState extends State<GroundTileWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  AnimationStatus _status = AnimationStatus.dismissed;
  late bool wasRedeemed;

  @override
  void initState() {
    wasRedeemed = widget.tile.isRedeemed;
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween(end: 1.0, begin: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _status = status;
      });

    // if already redeeemed, jump to that state
    if (wasRedeemed) {
      _controller.value = 1.0;
    } else {
      _controller.value = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO listen to this specific instance changing?
    if (wasRedeemed != widget.tile.isRedeemed) {
      wasRedeemed = widget.tile.isRedeemed;
      if (_status == AnimationStatus.dismissed) {
        _controller.forward();
      } else if (_status == AnimationStatus.completed) {
        _controller.reverse();
      }
    }

    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.0015)
        ..rotateY(pi * _animation.value),
      child: _animation.value <= 0.5 ? _buildNormal() : _buildRedeemed(),
    );
  }

  Widget _buildNormal() {
    return Image.asset(
      'assets/tile/${widget.tile.type.name}.png',
      filterQuality: FilterQuality.medium,
    );
  }

  Widget _buildRedeemed() {
    return Image.asset(
      'assets/tile/redeemed.png',
      filterQuality: FilterQuality.medium,
    );
  }
}
