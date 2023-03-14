import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../graphics/inventory_slot.dart';
import '../../logic/index.dart';

class InventorySection extends StatelessWidget {
  const InventorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, game, child) {
      return Container(
        height: 88,
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InventorySlotWidget(
                type: ItemType.scripture,
                count: game.characterInPlay.inventory!.scripture),
            InventorySlotWidget(
                type: ItemType.prayer,
                count: game.characterInPlay.inventory!.prayer),
            InventorySlotWidget(
                type: ItemType.charity,
                count: game.characterInPlay.inventory!.charity),
            InventorySlotWidget(
                type: ItemType.blessing,
                count: game.characterInPlay.inventory!.blessing),
          ],
        ),
      );
    });
  }
}
