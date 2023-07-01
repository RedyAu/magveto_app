import 'package:flutter/material.dart';
import 'package:magveto_app/game/actions/round/roll/utils.dart';
import 'package:provider/provider.dart';

import '../../../../logic/index.dart';
import '../../../action_dialog.dart';

class TraitRollChooseDialog extends StatelessWidget {
  final CID cid;
  TraitRollChooseDialog(this.cid, {super.key});

  final items = [ItemType.scripture, ItemType.prayer, ItemType.charity];

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, game, child) {
      return ActionDialog(
        title: characterNames[cid]!,
        child: Column(
          children: [
            Text(characterDescriptions[cid]!),
            ActionSegmentTitle("Válassz:"),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              height: 65,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  FilledButton.tonal(
                    onPressed: () {
                      game.characterInPlay.inventory!
                          .give(Inventory(scripture: 1));
                      game.notify();
                      Navigator.pop(context);
                    },
                    child: RollOutcome.scripture.widget,
                  ),
                  FilledButton.tonal(
                    onPressed: () {
                      game.characterInPlay.inventory!
                          .give(Inventory(prayer: 1));
                      game.notify();
                      Navigator.pop(context);
                    },
                    child: RollOutcome.prayer.widget,
                  ),
                  FilledButton.tonal(
                    onPressed: () {
                      game.characterInPlay.inventory!
                          .give(Inventory(charity: 1));
                      game.notify();
                      Navigator.pop(context);
                    },
                    child: RollOutcome.charity.widget,
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
