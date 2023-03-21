import 'package:flutter/material.dart';

import '../../../../logic/index.dart';
import '../../../action_dialog.dart';

class RedeemDialog extends StatefulWidget {
  final GroundTile tile;
  const RedeemDialog(this.tile, {Key? key}) : super(key: key);

  @override
  _RedeemDialogState createState() => _RedeemDialogState();
}

class _RedeemDialogState extends State<RedeemDialog> {
  @override
  Widget build(BuildContext context) {
    GameProvider game = GameProvider.of(context);

    return ActionDialog(
        heroTag: widget.tile.hashCode,
        title: "${widget.tile.type.displayName}mező megváltása",
        icon: Icon(Icons.stream_sharp),
        child: Column(
          children: [
            Image.asset(
              "assets/button/redeem_${widget.tile.type.name}.png",
              height: 100,
              filterQuality: FilterQuality.medium,
            ),
            SizedBox(height: 20),
            Text(widget.tile.type.description),
            SizedBox(height: 20),
            ActionSegmentTitle("A megváltáshoz be kell adnod:"),
            SizedBox(height: 20),
            Wrap(
              children: game.characterInPlay.inventory!
                  .getCompareWithBlessingWidgetList(widget.tile.type.giveToRedeem)
                  .map((e) => SizedBox(height: 65, child: e))
                  .toList(),
            ),
            ActionSegmentTitle(
              game.characterInPlay.inventory!.canTake(widget.tile.type.giveToRedeem)
                  ? "Be tudsz adni mindent! ✅"
                  : (game.characterInPlay.inventory!
                              .getTakeWithBlessing(widget.tile.type.giveToRedeem) !=
                          null
                      ? "Be tudsz adni mindent, de a hitből kell építkezned!"
                      : "Nem tudsz beadni mindent!"),
              subtitle: true,
            ),
            SizedBox(height: 20),
            FilledButton(
                onPressed: game.characterInPlay.inventory!
                            .getTakeWithBlessing(widget.tile.type.giveToRedeem) !=
                        null
                    ? () {
                        game.characterInPlay.inventory!.take(game
                            .characterInPlay.inventory!
                            .getTakeWithBlessing(widget.tile.type.giveToRedeem)!);
                        widget.tile.isRedeemed = true;
                        game.notify();
                        Navigator.pop(context);
                      }
                    : null,
                child: Text("Megváltom!", style: TextStyle(fontSize: 20))),
            SizedBox(height: 10),
          ],
        ));
  }
}
