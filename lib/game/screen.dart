import 'package:flutter/material.dart';
import 'package:magveto_app/graphics/background.dart';

import 'actions/section.dart';
import 'inventory/section.dart';
import '../logic/roll.dart';
import 'location/section.dart';
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
                  child: LocationSection(),
                ),
              ],
            )),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InventorySection(),
                Expanded(
                  flex: 3,
                  child: ActionsSection(),
                ),
              ],
            ))
          ],
        ),
      );
    });
  }
}

class RollDialog extends StatefulWidget {
  const RollDialog({super.key});

  @override
  _RollDialogState createState() => _RollDialogState();
}

class _RollDialogState extends State<RollDialog> {
  late Stream<Roll> rollStream;
  bool _isRolling = false;

  @override
  void initState() {
    super.initState();
    rollStream = Stream.empty();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RollWidget(rollStream: rollStream),
          FilledButton(
            onPressed: !_isRolling ? _startRoll : null,
            child: const Text('Roll'),
          )
        ],
      ),
    );
  }

  void _startRoll() {
    setState(() {
      rollStream = randomRollStream().asBroadcastStream();
      _isRolling = true;
      rollStream.last.then((_) => setState(() => _isRolling = false));
    });
  }
}
