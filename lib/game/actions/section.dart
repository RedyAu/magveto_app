import 'package:flutter/material.dart';
import 'package:magveto_app/game/actions/round/view.dart';
import 'package:provider/provider.dart';

import '../../logic/index.dart';
import '../action_dialog.dart';
import 'location/view.dart';
import 'round/roll/dialog.dart';

class ActionsSection extends StatelessWidget {
  const ActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, child) => Column(
        children: [
          //Spacer(),
          LocationActionsView(),
          //Spacer(),
          RoundActionsView(),
          //Spacer(),
          //? Test actions
          Expanded(
            child: ListView(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      ActionRoute(builder: (context) => RollDialog()),
                    );
                  },
                  child: const Text('Roll dialog'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      game.characterInPlay.additionalIds.toggle(CID.gertrud),
                  child: const Text('Toggle Gertrud'),
                )
              ],
            ),
          ),
          /*Wrap(
            children: [
              ElevatedButton(
                onPressed: () {
                  game.advanceCharacters();
                },
                child: const Text('Next character'),
              ),
              ElevatedButton(
                onPressed: () {
                  game.characterInPlay.currentLocation!.type =
                      LocationType.outpost;
                  game.characterInPlay.currentLocation!.scriptureService++;
                  game.characterInPlay.currentLocation!.tiles[0].isRedeemed =
                      true;
                  game.notify();
                },
                child: const Text('Redeem and add 1 to scripture service'),
              ),
              ElevatedButton(
                onPressed: () {
                  game.characterInPlay.currentLocation!.type =
                      LocationType.community;
                  game.notify();
                },
                child: const Text('change type to community'),
              ),
              ElevatedButton(
                onPressed: () {
                  game.characterInPlay.currentLocation!.type =
                      LocationType.church;
                  game.characterInPlay.currentLocation!.tiles[0].isRedeemed =
                      false;
                  game.notify();
                },
                child: const Text('Reset redeem, change type'),
              ),
            ],
          ),*/
        ],
      ),
    );
  }
}
