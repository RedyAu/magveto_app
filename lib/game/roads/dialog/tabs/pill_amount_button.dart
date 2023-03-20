import 'package:flutter/material.dart';

class PillAmountButton extends StatelessWidget {
  final List<int> itemListTo;
  final List<int> itemListFrom;
  final int itemTypeIndex;
  final Function onPressed;
  final bool takeItemsFrom;

  const PillAmountButton({
    required this.itemListTo,
    required this.itemListFrom,
    required this.itemTypeIndex,
    this.takeItemsFrom = false,
    required this.onPressed,
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
        if (takeItemsFrom) ...[
          itemListFrom[itemTypeIndex] > 0,
          itemListTo[itemTypeIndex] > 0
        ] else ...[
          itemListTo[itemTypeIndex] < itemListFrom[itemTypeIndex],
          itemListTo[itemTypeIndex] > 0,
        ],
      ],
      direction: Axis.vertical,
      children: [
        if (takeItemsFrom) ...[
          Icon(size: 15, Icons.arrow_upward_rounded),
          Icon(size: 15, Icons.arrow_downward_rounded),
        ] else ...[
          Icon(size: 15, Icons.add),
          Icon(size: 15, Icons.remove),
        ],
      ],
      borderRadius: BorderRadius.circular(99),
      color: Colors.white60,
      selectedColor: Colors.amber,
      fillColor: Theme.of(context).colorScheme.primaryContainer,
      borderColor: Colors.white38,
      selectedBorderColor: Colors.amber,
      onPressed: (index) {
        if (takeItemsFrom) {
          switch (index) {
            case 0:
              if (itemListFrom[itemTypeIndex] < 1) return;
              itemListTo[itemTypeIndex]++;
              itemListFrom[itemTypeIndex]--;
              break;
            case 1:
              if (itemListTo[itemTypeIndex] < 1) return;
              itemListTo[itemTypeIndex]--;
              itemListFrom[itemTypeIndex]++;
              break;
            default:
          }
        } else {
          if (index == 0) {
            itemListTo[itemTypeIndex]++;
            itemListTo[itemTypeIndex] > itemListFrom[itemTypeIndex]
                ? itemListTo[itemTypeIndex] = itemListFrom[itemTypeIndex]
                : itemListTo[itemTypeIndex];
          } else {
            itemListTo[itemTypeIndex]--;
            itemListTo[itemTypeIndex] < 0
                ? itemListTo[itemTypeIndex] = 0
                : itemListTo[itemTypeIndex];
          }
        }
        onPressed();
      },
    );
  }
}
