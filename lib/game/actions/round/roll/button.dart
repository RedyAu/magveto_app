import 'package:flutter/material.dart';
import 'package:magveto_app/game/action_dialog.dart';
import 'package:magveto_app/logic/game_provider.dart';
import 'package:provider/provider.dart';

import 'dialog.dart';

class RollButton extends StatelessWidget {
  const RollButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "roll",
      child: Consumer<GameProvider>(builder: (context, game, child) {
        return FilledButton.icon(
          onPressed: game.rollsLeft > 0
              ? () {
                  game.rollsLeft--;
                  Navigator.push(
                    context,
                    ActionRoute(builder: (context) => RollDialog()),
                  );
                }
              : null,
          icon: Padding(
              padding: const EdgeInsets.all(5),
              child: Image.asset(
                'assets/button/roll.png',
                filterQuality: FilterQuality.medium,
              )),
          label: Badge(
              label: Text(game.rollsLeft.toString()),
              offset: Offset(15, -5),
              isLabelVisible: game.rollsLeft > 1,
              child:
                  Text("Dobás", softWrap: false, overflow: TextOverflow.fade)),
        );
      }),
    );
  }
}
