import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../graphics/index.dart';
import '../../logic/index.dart';
import 'view.dart';

class LocationSection extends StatelessWidget {
  const LocationSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, game, child) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: LocationView(game.characterInPlay.currentLocation!,
                        game.teamInPlay, LocationViewType.current,
                        key: Key(
                            '${game.characterInPlay.currentLocation!.hashCode}')),
                  ),
                ]),
          ),
          SizedBox(
            width: 100,
            child: ListView.builder(
              itemBuilder: (context, int index) {
                return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: game.teams[index].characters
                        .map((e) => e.currentLocation)
                        .toSet()
                        .skipWhile((loc) =>
                            loc == game.characterInPlay.currentLocation)
                        .map((e) => SizedBox(
                              height: 140,
                              child: LocationView(
                                  e!, game.teams[index], LocationViewType.other,
                                  key: Key('${e.hashCode}')),
                            ))
                        .toList());
              },
              itemCount: game.teams.length,
              shrinkWrap: true,
            ),
          ),
        ],
      );
    });
  }
}
