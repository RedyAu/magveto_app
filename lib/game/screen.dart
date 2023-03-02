import 'package:flutter/material.dart';

import 'actions/widget.dart';
import 'inventory/widget.dart';
import '../logic/roll.dart';
import 'locations/widget.dart';
import 'round/widget.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return Scaffold(
        backgroundColor: Colors.grey[800],
        body: SafeArea(
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
                    child: RoundView(),
                  ),
                  Expanded(
                    flex: 2,
                    child: LocationsView(),
                  ),
                ],
              )),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: ActionsView(),
                  ),
                  Expanded(
                    flex: 1,
                    child: InventoryView(),
                  ),
                ],
              ))
            ],
          ),
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
