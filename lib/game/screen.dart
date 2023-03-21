import 'package:flutter/material.dart';
import 'package:magveto_app/logic/game_provider.dart';

import '../graphics/background.dart';
import 'actions/section.dart';
import 'inventory/section.dart';
import 'location/section.dart';
import 'roads/section.dart';
import 'round/section.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return MagvetoScaffold(
        child: Flex(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          direction: orientation == Orientation.portrait
              ? Axis.vertical
              : Axis.horizontal,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child: RoundSection(),
                ),
                Expanded(
                  flex: 2,
                  child: LocationSection(context: context),
                ),
              ],
            )),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InventorySection(GameProvider.of(context, listen: true)
                    .characterInPlay
                    .inventory!),
                RoadsSection(),
                Expanded(child: ActionsSection()),
              ],
            ))
          ],
        ),
      );
    });
  }
}

