import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/index.dart';
import 'roads/view.dart';

class ActionsSection extends StatelessWidget {
  const ActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, child) => Container(
        child: Column(
          children: [
            RoadsView(),
            Text('Test actions for: ${game.characterInPlay.name}'),
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
        ),
      ),
    );
  }
}
