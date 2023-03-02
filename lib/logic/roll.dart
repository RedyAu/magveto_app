import 'dart:math';

import 'package:flutter/material.dart';

import 'inventory.dart';
import 'team.dart';

enum Roll { scripture, prayer, charity, blessing, choose, eventCard }

extension RollUtils on Roll {
  static Roll random() {
    return Roll.values[Random().nextInt(Roll.values.length)];
  }

  InventoryTransaction transactionFor(Character character) {
    switch (this) {
      case Roll.scripture:
        return InventoryTransaction(
          to: character,
          scripture: 1,
        );
      case Roll.prayer:
        return InventoryTransaction(
          to: character,
          prayer: 1,
        );
      case Roll.charity:
        return InventoryTransaction(
          to: character,
          charity: 1,
        );
      case Roll.blessing:
        return InventoryTransaction(
          to: character,
          blessing: 1,
        );
      default:
        throw Exception('Roll $this cannot be converted to transaction');
    }
  }
}

Stream<Roll> randomRollStream() async* {
  var timer = 1000;
  var delay = 50;
  while (timer > 0) {
    yield RollUtils.random();
    await Future.delayed(Duration(milliseconds: delay));
    timer -= delay;
    delay += 50;
  }
  yield RollUtils.random();
}

class RollWidget extends StatelessWidget {
  const RollWidget({Key? key, required this.rollStream}) : super(key: key);

  final Stream<Roll> rollStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Roll>(
      stream: rollStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data) {
            case Roll.scripture:
              return const Text('Scripture');
            case Roll.prayer:
              return const Text('Prayer');
            case Roll.charity:
              return const Text('Charity');
            case Roll.blessing:
              return const Text('Blessing');
            case Roll.choose:
              return const Text('Choose');
            case Roll.eventCard:
              return const Text('Event Card');
            default:
              return const Text('Unknown roll');
          }
        }
        return const Text('Rolling...');
      },
    );
  }
}
