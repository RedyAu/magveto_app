import 'package:flutter/material.dart';
import 'package:magveto_app/game/action_dialog.dart';
import 'package:magveto_app/game/actions/round/advance/dialog.dart';
import 'package:magveto_app/logic/game_provider.dart';
import 'package:provider/provider.dart';

class AdvanceRoundButton extends StatelessWidget {
  const AdvanceRoundButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "advance",
      child: Consumer<GameProvider>(builder: (context, game, child) {
        return FilledButton.icon(
          onPressed: () {
            var prevPlayer = game.characterInPlay.player;
            GameProvider.of(context).advanceCharacters();
            if (prevPlayer != game.characterInPlay.player) {
              Navigator.push(
                context,
                ActionRoute(
                  builder: (context) => AdvanceDialog(
                      idWidget:
                          game.teamInPlay.idWidgetFor(game.characterInPlay),
                      playerName: game.characterInPlay.player!.name),
                ),
              );
            }
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Color(0xff45b508)),
            foregroundColor:
                MaterialStateProperty.all<Color>(Color(0xffddeeaa)),
          ),
          icon: Icon(Icons.keyboard_double_arrow_right_rounded),
          label: Text("Kövekező", softWrap: false, overflow: TextOverflow.fade),
        );
      }),
    );
  }
}
