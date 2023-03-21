import 'package:flutter/material.dart';
import 'package:magveto_app/game/actions/round/advance/button.dart';
import 'package:magveto_app/game/actions/round/custom_action/button.dart';
import 'package:magveto_app/game/actions/round/roll/button.dart';
import 'package:magveto_app/logic/game_provider.dart';
import 'package:provider/provider.dart';

class RoundActionsView extends StatelessWidget {
  const RoundActionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, game, child) {
      return Container(
        height: 90,
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 3, child: RollButton()),
            //CustomActionButton(),
            Expanded(flex: 2, child: AdvanceRoundButton()),
          ],
        ),
      );
    });
  }
}
