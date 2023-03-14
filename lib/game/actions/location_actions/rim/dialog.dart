import 'package:flutter/material.dart';

import '../../../../graphics/ground_tile.dart';
import '../../../../logic/index.dart';
import '../../../action_dialog.dart';

class RimDialog extends StatefulWidget {
  const RimDialog({Key? key}) : super(key: key);

  @override
  State<RimDialog> createState() => _RimDialogState();
}

class _RimDialogState extends State<RimDialog> {
  Set<GroundTileType> _selectedTileTypeSet = {};
  GroundTileType get selectedTileType {
    if (_selectedTileTypeSet.isEmpty) {
      return GroundTileType.values.first;
    }
    return _selectedTileTypeSet.single;
  }

  @override
  Widget build(BuildContext context) {
    GameProvider game = GameProvider.of(context);

    return ActionDialog(
      heroTag: "rim",
      title: "Szórványgyülekezeti föld megváltása",
      icon: Icon(Icons.outlined_flag_rounded),
      child: Column(
        children: [
          Text(
              "A játék végén, amikor már nincs lehetőség új missziói állomás alapítására, a gyülekezetek a területükhöz kapcsolódó terméketlen mezőket megválthatják, és mint szórványgyülekezeteket a gyülekezethez csatolhatják."),
          SizedBox(height: 10),
          ActionSegmentTitle(
            "Válaszd ki a föld típusát:",
            subtitle: true,
          ),
          SizedBox(height: 10),
          SegmentedButton<GroundTileType>(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                (states) {
                  if (states.contains(MaterialState.selected)) {
                    return Theme.of(context).colorScheme.primaryContainer;
                  }
                  return Color(0xffa8814c);
                },
              ),
              side: MaterialStatePropertyAll<BorderSide?>(
                BorderSide(
                  color: Colors.amber,
                ),
              ),
            ),
            showSelectedIcon: false,
            emptySelectionAllowed: true,
            selected: _selectedTileTypeSet,
            onSelectionChanged: (value) {
              setState(() {
                _selectedTileTypeSet = value;
              });
            },
            segments: GroundTileType.values
                .map(
                  (e) => ButtonSegment<GroundTileType>(
                    value: e,
                    label: Padding(
                      padding: const EdgeInsets.all(3),
                      child: SizedBox(
                        height: 65,
                        width: 65,
                        child: GroundTileWidget(GroundTile(e)),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOutCubicEmphasized,
            height: _selectedTileTypeSet.isEmpty ? 10 : 230,
            child: _selectedTileTypeSet.isEmpty
                ? null
                : Column(
                    children: [
                      Spacer(flex: 2),
                      ActionSegmentTitle(
                          "${selectedTileType.displayName}mező megváltásához szükséges:"),
                      Spacer(flex: 1),
                      Wrap(
                        children: game.characterInPlay.inventory!
                            .getCompareWithBlessingWidgetList(
                                selectedTileType.giveToRedeem)
                            .map((e) => SizedBox(height: 65, child: e))
                            .toList(),
                      ),
                      ActionSegmentTitle(
                        game.characterInPlay.inventory!
                                .canTake(selectedTileType.giveToRedeem)
                            ? "Be tudsz adni mindent! ✅"
                            : (game.characterInPlay.inventory!
                                        .getTakeWithBlessing(
                                            selectedTileType.giveToRedeem) !=
                                    null
                                ? "Be tudsz adni mindent, de a hitből kell építkezned!"
                                : "Nem tudsz beadni mindent!"),
                        subtitle: true,
                      ),
                      Spacer(flex: 3),
                      FilledButton(
                          onPressed: game.characterInPlay.inventory!
                                      .getTakeWithBlessing(
                                          selectedTileType.giveToRedeem) !=
                                  null
                              ? () {
                                  game.characterInPlay.inventory!.take(game
                                      .characterInPlay.inventory!
                                      .getTakeWithBlessing(
                                          selectedTileType.giveToRedeem)!);

                                  game.teamInPlay.rimsRedeemed++;

                                  game.notify();
                                  Navigator.pop(context);
                                }
                              : null,
                          child: Text("Megváltom!",
                              style: TextStyle(fontSize: 20))),
                      Spacer(flex: 2),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
