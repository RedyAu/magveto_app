import 'package:flutter/material.dart';
import 'package:magveto_app/game/action_dialog.dart';

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

    rollStream = randomRollStream().asBroadcastStream();
    rollStream.last.then(
      (r) => setState(
        () {
          outcome = r;
          rolled = r;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var game = GameProvider.of(context);

    List<Character> charactersToReceive = [];
    List<Widget> receivingIDWidgets = [];

    charactersToReceive.add(game.characterInPlay);
    receivingIDWidgets.add(game.teamInPlay.idWidgetFor(game.characterInPlay));

    var teams = game.brotherConnections
        .where((b) => b.isActive && b.hasTeam(game.teamInPlay))
        .map((b) => b.teams.firstWhere((t) => t != game.teamInPlay));

    for (var team in teams) {
      for (var character in team.characters) {
        charactersToReceive.add(character);
        receivingIDWidgets.add(team.idWidgetFor(character));
      }
    }

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
                      outcome != RollOutcome.choose &&
                      charactersToReceive.length > 1)
                  ? Column(
                      children: [
                        ActionSegmentTitle("Megkapják:"),
                        Wrap(
                          children: receivingIDWidgets
                              .map((e) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: e,
                                  ))
                              .toList(),
                        ),
                        SizedBox(height: 15),
                        // TODO character traits receiving
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

                    if (game.characterInPlay.ids.contains(CID.gertrud)) {
                      if (rolled!.value % 2 == 1) {
                        Navigator.push(
                            context,
                            ActionRoute(
                                builder: (context) =>
                                    TraitRollChooseDialog(CID.gertrud)));
                      }
                    }
                    if (game.characterInPlay.ids.contains(CID.ivan)) {
                      if (rolled!.value % 2 == 0) {
                        Navigator.push(
                            context,
                            ActionRoute(
                                builder: (context) =>
                                    TraitRollChooseDialog(CID.ivan)));
                      }
                    }
                  },
            child: const Text('Kérem!', style: TextStyle(fontSize: 20)),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
