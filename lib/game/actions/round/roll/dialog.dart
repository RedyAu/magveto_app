import 'package:flutter/material.dart';
import 'package:magveto_app/game/action_dialog.dart';
import 'package:magveto_app/logic/game_provider.dart';

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
    return ActionDialog(
      heroTag: "roll",
      title: "Dobás",
      //showCloseButton: false, // TODO uncomment
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
          FilledButton(
            onPressed: (result == null || result == RollResult.choose)
                ? null
                : () {
                    if (result == RollResult.eventCard) {
                    } else {
                      var game = GameProvider.of(context);
                      game.postDiceCallbacks.forEach((e) {
                        e(result!);
                      });
                      game.notify();
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
