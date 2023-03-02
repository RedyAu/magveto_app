import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/index.dart';

class ActionsView extends StatelessWidget {
  const ActionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, child) => Container(
          color: Colors.red,
          child: Column(
            children: [
              Text('Actions: ${game.characterInPlay.name}'),
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
                  game.characterInPlay.currentLocation!.tiles[0] =
                      TileType.redeemed;
                  game.notify();
                },
                child: const Text('Redeem and add 1 to scripture service'),
              ),
              ElevatedButton(
                onPressed: () {
                  game.characterInPlay.currentLocation!.type =
                      LocationType.church;
                  game.characterInPlay.currentLocation!.tiles[0] =
                      TileType.path;
                  game.notify();
                },
                child: const Text('Reset redeem, change type'),
              ),
            ],
          )),
    );
  }
}
