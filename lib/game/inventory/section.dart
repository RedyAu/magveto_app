import 'package:flutter/material.dart';

import '../../graphics/inventory_slot.dart';
import '../../logic/index.dart';

class InventorySection extends StatelessWidget {
  final Inventory inventory;
  const InventorySection(Inventory this.inventory, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InventorySlotWidget(
              type: ItemType.scripture, count: inventory.scripture),
          InventorySlotWidget(type: ItemType.prayer, count: inventory.prayer),
          InventorySlotWidget(type: ItemType.charity, count: inventory.charity),
          InventorySlotWidget(
              type: ItemType.blessing, count: inventory.blessing),
        ],
      ),
    );
  }
}
