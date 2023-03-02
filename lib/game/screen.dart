import 'package:flutter/material.dart';

import 'actions/widget.dart';
import 'inventory/widget.dart';
import '../logic/roll.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return MaterialApp(
        home: Scaffold(
            body: Flex(
          direction: orientation == Orientation.portrait
              ? Axis.vertical
              : Axis.horizontal,
          children: [
            Expanded(child: InventoryWidget()),
            Expanded(child: ActionsWidget())
          ],
        )),
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
          Hero(tag: "Roll button", child: ElevatedButton(
            onPressed: !_isRolling ? _startRoll : null,
            child: const Text('Roll'),
          ))
          
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
