import 'package:flutter/material.dart';
import 'package:magveto_app/game/action_dialog.dart';
import 'package:provider/provider.dart';

import '../../../../logic/index.dart';
import 'trait_choose.dart';
import 'utils.dart';

class RollDialog extends StatefulWidget {
  const RollDialog({super.key});

  @override
  _RollDialogState createState() => _RollDialogState();
}

class _RollDialogState extends State<RollDialog> {
  late Stream<RollOutcome> rollStream;
  RollOutcome? outcome = null;
  RollOutcome? rolled = null;

  @override
  void initState() {
    super.initState();
    rollStream = Stream.empty();

    var game = GameProvider.of(context);

    // TODO check for in effect event that prevents item type??
    charactersToReceive.add(game.characterInPlay);

    var teams = game.brotherConnections
        .where((b) => b.isActive && b.hasTeam(game.teamInPlay))
        .map((b) => b.teams.firstWhere((t) => t != game.teamInPlay));

    for (var team in teams) {
      for (var character in team.characters) {
        charactersToReceive.add(character);
        brotherConnectionIDWidgets.add(team.idWidgetFor(character));
      }
    }

    rollStream = randomRollStream().asBroadcastStream();
    rollStream.last.then(
      (r) => setState(
        () {
          outcome = r;
          rolled = r;
          var traitAffected = getOtherCharactersByTraitForOutcome(r, game);
          charactersToReceive.addAll(traitAffected.map((e) => e.character));
          traitAffectedIDWidgets.addAll(
            traitAffected.map(
              (c) => c.team.idWidgetFor(c.character),
            ),
          );
        },
      ),
    );
  }

  List<Character> charactersToReceive = [];
  List<Widget> brotherConnectionIDWidgets = [];
  List<Widget> traitAffectedIDWidgets = [];
  // todo get list of characters affected by event card state

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, game, child) {
      return ActionDialog(
        heroTag: "roll",
        title: "Dobás",
        //showCloseButton: false, // TODO uncomment
        icon: Icon(Icons.casino_outlined),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RollWidget(rollStream: rollStream, result: outcome),
            SizedBox(height: 30),
            AnimatedSize(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOutCubicEmphasized,
              child: outcome == RollOutcome.choose
                  ? Column(
                      children: [
                        ActionSegmentTitle("Választhatsz:"),
                        DropdownButton<RollOutcome>(
                            value: outcome,
                            autofocus: true,
                            itemHeight: 70,
                            items: RollOutcome.values
                                .map((v) => DropdownMenuItem(
                                    value: v, child: Center(child: v.widget)))
                                .toList(),
                            onChanged: (r) {
                              setState(() {
                                outcome = r;
                              });
                            }),
                        SizedBox(height: 15),
                      ],
                    )
                  : Container(),
            ),
            AnimatedSize(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOutCubicEmphasized,
                child: (outcome != null &&
                        outcome != RollOutcome.eventCard &&
                        outcome != RollOutcome.choose)
                    ? Column(
                        children: [
                          if (brotherConnectionIDWidgets.isNotEmpty ||
                              traitAffectedIDWidgets.isNotEmpty)
                            ActionSegmentTitle("Megkapják még"),
                          if (brotherConnectionIDWidgets.isNotEmpty)
                            Column(
                              children: [
                                SizedBox(height: 15),
                                ActionSegmentTitle("Testvérgyülekezetek:",
                                    subtitle: true),
                                Wrap(
                                  children: brotherConnectionIDWidgets
                                      .map((e) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: e,
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          if (traitAffectedIDWidgets.isNotEmpty)
                            Column(
                              children: [
                                SizedBox(height: 15),
                                ActionSegmentTitle("Karakterek:",
                                    subtitle: true),
                                Wrap(
                                  children: traitAffectedIDWidgets
                                      .map((e) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: e,
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                        ],
                      )
                    : Container()),
            FilledButton(
              onPressed: (outcome == null || outcome == RollOutcome.choose)
                  ? null
                  : () {
                      if (outcome == RollOutcome.eventCard) {
                        // TODO event card
                      } else {
                        giveRollResultToAll(outcome!, charactersToReceive);
                        game.notify();
                      }
                      Navigator.pop(context);

                      if (game.characterInPlay.hasTrait(Trait.oddRoll) !=
                          null) {
                        if (rolled!.value % 2 == 1) {
                          Navigator.push(
                              context,
                              ActionRoute(
                                  builder: (context) => TraitRollChooseDialog(
                                      game.characterInPlay
                                          .hasTrait(Trait.oddRoll)!)));
                        }
                      }
                      if (game.characterInPlay.hasTrait(Trait.evenRoll) !=
                          null) {
                        if (rolled!.value % 2 == 0) {
                          Navigator.push(
                              context,
                              ActionRoute(
                                  builder: (context) => TraitRollChooseDialog(
                                      game.characterInPlay
                                          .hasTrait(Trait.evenRoll)!)));
                        }
                      }
                    },
              child: const Text('Kérem!', style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 15),
          ],
        ),
      );
    });
  }
}
