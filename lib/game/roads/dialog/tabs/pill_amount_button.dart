import 'package:flutter/material.dart';

class PillAmountButton extends StatelessWidget {
  final List<int> itemsToUse;
  final List<int> playerInventory;
  final int itemTypeIndex;
  final Function resolveItemsToUse;

  const PillAmountButton({
    required this.itemsToUse,
    required this.playerInventory,
    required this.itemTypeIndex,
    required this.resolveItemsToUse,
  });

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      constraints: BoxConstraints(
        minWidth: 35,
        minHeight: 35,
      ),
      // set selected if action is available
      isSelected: [
        itemsToUse[itemTypeIndex] < playerInventory[itemTypeIndex],
        itemsToUse[itemTypeIndex] > 0,
      ],
      direction: Axis.vertical,
      children: [
        Icon(size: 15, Icons.add),
        Icon(size: 15, Icons.remove),
      ],
      borderRadius: BorderRadius.circular(99),
      color: Colors.white60,
      selectedColor: Colors.amber,
      fillColor: Theme.of(context).colorScheme.primaryContainer,
      borderColor: Colors.white38,
      selectedBorderColor: Colors.amber,
      onPressed: (index) {
        if (index == 0) {
          itemsToUse[itemTypeIndex]++;
          itemsToUse[itemTypeIndex] > playerInventory[itemTypeIndex]
              ? itemsToUse[itemTypeIndex] = playerInventory[itemTypeIndex]
              : itemsToUse[itemTypeIndex];
        } else {
          itemsToUse[itemTypeIndex]--;
          itemsToUse[itemTypeIndex] < 0
              ? itemsToUse[itemTypeIndex] = 0
              : itemsToUse[itemTypeIndex];
        }
        resolveItemsToUse();
      },
    );
  }
}
