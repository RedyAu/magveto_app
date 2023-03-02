import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../graphics/index.dart';
import '../../logic/index.dart';

class LocationsView extends StatelessWidget {
  const LocationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, game, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: LocationTile(
              game.teamInPlay.characters.first.currentLocation!,
              LocationTileType.current,
            ),
          ),
          Expanded(
            child: LocationTile(
              game.teamInPlay.characters.last.currentLocation!,
              LocationTileType.current,
            ),
          ),
        ],
      );
    });
  }
}

enum LocationTileType { currentBoth, current, other }

class LocationTile extends StatelessWidget {
  final Location location;
  final LocationTileType type;

  const LocationTile(this.location, this.type, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Row(children: [
      Text(location.type.toString()),
      Wrap(
        children: location.tiles
            .map((tile) => SizedBox(width: 60, child: GroundTile(tile)))
            .toList(),
      ),
      Text(
          'Biblia: ${location.scriptureService}\nIma: ${location.prayerService}\nCharity: ${location.charityService}'),
    ]));
  }
}
