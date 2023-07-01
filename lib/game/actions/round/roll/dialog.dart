import 'package:flutter/material.dart';
import 'package:magveto_app/game/action_dialog.dart';
import 'package:magveto_app/logic/game_provider.dart';

import '../../../../graphics/index.dart';
import '../../../../logic/index.dart';
import 'utils.dart';

class RollDialog extends StatefulWidget {
  const RollDialog({super.key});

  @override
  _RollDialogState createState() => _RollDialogState();
}

class _RollDialogState extends State<RollDialog> {
  late Stream<RollResult> rollStream;
  RollResult? result = null;

  @override
  void initState() {
    super.initState();
    rollStream = Stream.empty();

    rollStream = randomRollStream().asBroadcastStream();
    rollStream.last.then((r) => setState(() => result = r));
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
      showCloseButton: false, // TODO uncomment
      icon: Icon(Icons.casino_outlined),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RollWidget(rollStream: rollStream, result: result),
          SizedBox(height: 30),
          AnimatedSize(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOutCubicEmphasized,
            child: result == RollResult.choose
                ? Column(
                    children: [
                      ActionSegmentTitle("Választhatsz:"),
                      DropdownButton<RollResult>(
                          value: result,
                          autofocus: true,
                          itemHeight: 70,
                          items: RollResult.values
                              .map((v) => DropdownMenuItem(
                                  value: v, child: Center(child: v.display)))
                              .toList(),
                          onChanged: (r) {
                            setState(() {
                              result = r;
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
              child: (result != null &&
                      result != RollResult.eventCard &&
                      result != RollResult.choose &&
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
                      ],
                    )
                  : Container()),
          FilledButton(
            onPressed: (result == null || result == RollResult.choose)
                ? null
                : () {
                    if (result == RollResult.eventCard) {
                      // TODO event card
                    } else {
                      giveRollResultToAll(result!, charactersToReceive);
                      game.notify();
                    }
                    Navigator.pop(context);
                    switch (game.characterInPlay.id) {
                      case CID.gertrud:
                        if (result!.value % 2 == 1) {
                          Navigator.push(
                              context,
                              ActionRoute(
                                  builder: (context) =>
                                      RollChooseDialog(game.characterInPlay)));
                        }
                        break;
                      case CID.ivan:
                        if (result!.value % 2 == 0) {
                          Navigator.push(
                              context,
                              ActionRoute(
                                  builder: (context) =>
                                      RollChooseDialog(game.characterInPlay)));
                        }
                        break;
                      default:
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

class RollChooseDialog extends StatefulWidget {
  final Character character;
  const RollChooseDialog(this.character, {super.key});

  @override
  State<RollChooseDialog> createState() => _RollChooseDialogState();
}

class _RollChooseDialogState extends State<RollChooseDialog> {
  final items = [ItemType.scripture, ItemType.prayer, ItemType.charity];

  @override
  Widget build(BuildContext context) {
    return ActionDialog(
      title: widget.character.name,
      child: Column(
        children: [
          Text(widget.character.description),
          ActionSegmentTitle("Válassz:"),
          FilledButton.tonal(
           onPressed: () {}, child: ItemWidget(type: ItemType.scripture))
        ],
      ),
    );
  }
}
