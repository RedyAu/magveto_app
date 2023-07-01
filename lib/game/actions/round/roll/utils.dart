import 'dart:math';

import 'package:flutter/material.dart';
import 'package:magveto_app/graphics/index.dart';
import 'package:magveto_app/logic/index.dart';

enum RollOutcome {
  scripture(
    1,
    Hero(
      tag: ItemType.scripture,
      child: ItemWidget(
        type: ItemType.scripture,
        key: Key('s'),
      ),
    ),
  ),
  prayer(
    2,
    Hero(
      tag: ItemType.prayer,
      child: ItemWidget(
        type: ItemType.prayer,
        key: Key('s'),
      ),
    ),
  ),
  charity(
    3,
    Hero(
      tag: ItemType.charity,
      child: ItemWidget(
        type: ItemType.charity,
        key: Key('s'),
      ),
    ),
  ),
  blessing(
    4,
    Hero(
      tag: ItemType.blessing,
      child: ItemWidget(
        type: ItemType.blessing,
        key: Key('c'),
      ),
    ),
  ),
  choose(
    5,
    Center(
      child: const Icon(
        Icons.alt_route_rounded,
        color: Colors.amber,
        size: 50,
      ),
    ),
  ),
  eventCard(
    6,
    Center(
      child: Image(image: AssetImage('assets/event/event.png')),
    ),
  );

  final int value;
  final Widget widget;
  AssetImage get image => AssetImage('assets/dice/$value.png');

  const RollOutcome(this.value, this.widget);
}

extension RollUtils on RollOutcome {
  static RollOutcome random() {
    return RollOutcome.values[Random().nextInt(RollOutcome.values.length)];
  }
}

Stream<RollOutcome> randomRollStream() async* {
  var timer = 1000;
  var delay = 10;
  while (timer > 0) {
    yield RollUtils.random();
    await Future.delayed(Duration(milliseconds: delay));
    timer -= delay;
    delay += 10;
  }
  yield RollUtils.random();
}

class RollWidget extends StatelessWidget {
  const RollWidget({Key? key, required this.rollStream, required this.result})
      : super(key: key);
  final RollOutcome? result;
  final Stream<RollOutcome> rollStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RollOutcome>(
      stream: rollStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = result ?? snapshot.data!;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 50,
                  child: Image(
                    image: snapshot.data!.image,
                    filterQuality: FilterQuality.medium,
                  )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(
                  size: 40,
                  Icons.arrow_right_alt,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 80, maxWidth: 80),
                  child: data.widget),
            ],
          );
        }
        return Container();
      },
    );
  }
}

/// Remember to call game.notify() after using this function
void giveRollResultToAll(RollOutcome result, List<Character> characters) {
  print('Giving $result to all: ${characters.map((c) => c.name).toList()}');

  Inventory inventoryToGive = Inventory();

  switch (result) {
    case RollOutcome.scripture:
      inventoryToGive.scripture = 1;
      break;
    case RollOutcome.prayer:
      inventoryToGive.prayer = 1;
      break;
    case RollOutcome.charity:
      inventoryToGive.charity = 1;
      break;
    case RollOutcome.blessing:
      inventoryToGive.blessing = 1;
      break;
    default:
      break;
  }

  characters.forEach((c) => c.inventory?.give(inventoryToGive));
}

List<CharacterWithTeam> getOtherCharactersByTraitForOutcome(
    RollOutcome outcome, GameProvider game) {
  switch (outcome) {
    case RollOutcome.scripture:
      return game.charactersWithTeams
          .where((c) =>
              c.character.ids.contains(CID.janos) &&
              c.character != game.characterInPlay)
          .toList();
    case RollOutcome.prayer:
      return game.charactersWithTeams
          .where((c) =>
              c.character.ids.contains(CID.jeanphilip) &&
              c.character != game.characterInPlay)
          .toList();
    case RollOutcome.charity:
      return game.charactersWithTeams
          .where((c) =>
              c.character.ids.contains(CID.teofil) &&
              c.character != game.characterInPlay)
          .toList();
    default:
      return [];
  }
}
