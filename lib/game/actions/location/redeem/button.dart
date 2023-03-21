import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../logic/index.dart';
import '../../../action_dialog.dart';
import 'dialog.dart';

class RedeemButtons extends StatelessWidget {
  const RedeemButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, child) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: game.locationInPlay.tiles
              .where((element) => !element.isRedeemed)
              .map((e) => Expanded(child: redeemButton(e, context)))
              .toList(),
        );
      },
    );
  }

  Widget redeemButton(GroundTile tile, BuildContext context) {
    return Hero(
      tag: tile.hashCode,
      child: FilledButton.tonal(
        onPressed: () => Navigator.push(
          context,
          ActionRoute(
            builder: (context) => RedeemDialog(tile),
          ),
        ),
        child: Image.asset(
          "assets/button/redeem_${tile.type.name}.png",
          filterQuality: FilterQuality.medium,
        ),
      ),
    );
  }
}
