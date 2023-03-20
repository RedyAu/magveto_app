import 'package:flutter/material.dart';
import 'package:magveto_app/game/inventory/section.dart';
import 'package:magveto_app/game/roads/dialog/tabs/pill_amount_button.dart';
import 'package:provider/provider.dart';

import '../../../../logic/game_provider.dart';
import '../../../../logic/index.dart';
import '../../../action_dialog.dart';

class InventorySplitDialog extends StatefulWidget {
  const InventorySplitDialog({super.key});

  @override
  State<InventorySplitDialog> createState() => _InventorySplitDialogState();
}

class _InventorySplitDialogState extends State<InventorySplitDialog> {
  late List<int> newInventory;
  late List<int> oldInventory;

  @override
  void initState() {
    List<int> originalInventory = context
        .read<GameProvider>()
        .teamInPlay
        .characters
        .first
        .inventory!
        .asIntList;
    newInventory = originalInventory.map((e) => (e / 2).floor()).toList();
    oldInventory = originalInventory.map((e) => (e / 2).ceil()).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ActionDialog(
      showCloseButton: false,
      heroTag: "inventory_split",
      title: "Tárgyak elosztása",
      icon: Icon(Icons.grid_view_rounded),
      child: Consumer<GameProvider>(builder: (context, game, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ActionSegmentTitle(
                "A csapat két misszionáriusa külön helyszínen folytatja a szolgálatot."),
            ActionSegmentTitle(
              "Osszátok el a közös tárgyaitokat, mostantól külön-külön kezelhetitek őket.",
              subtitle: true,
            ),
            game.teamInPlay.idWidgetFor(game.teamInPlay.characters.first),
            InventorySection(Inventory.fromIntList(oldInventory)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List<Widget>.generate(
                  4,
                  (index) => PillAmountButton(
                      itemListTo: oldInventory,
                      itemListFrom: newInventory,
                      itemTypeIndex: index,
                      takeItemsFrom: true,
                      onPressed: () => setState(
                            () {},
                          ))),
            ),
            SizedBox(height: 8),
            InventorySection(Inventory.fromIntList(newInventory)),
            game.teamInPlay.idWidgetFor(game.teamInPlay.characters.last),
            SizedBox(height: 15),
            FilledButton(
                onPressed: () {
                  game.teamInPlay.characters.first.inventory =
                      Inventory.fromIntList(oldInventory);
                  game.teamInPlay.characters.last.inventory =
                      Inventory.fromIntList(newInventory);
                  Navigator.pop(context);
                },
                child: Text(
                  "Mehet!",
                  style: TextStyle(fontSize: 20),
                )),
            SizedBox(height: 8),
          ],
        );
      }),
    );
  }
}
