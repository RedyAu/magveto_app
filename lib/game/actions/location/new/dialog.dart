import 'package:flutter/material.dart';
import 'package:magveto_app/game/actions/location/new/inventory-split_dialog.dart';
import 'package:magveto_app/game/location/ground_tiles_view.dart';
import 'package:magveto_app/graphics/drag_card.dart';

import '../../../../graphics/ground_tile.dart';
import '../../../../logic/index.dart';
import '../../../action_dialog.dart';

class NewLocationDialog extends StatefulWidget {
  const NewLocationDialog({Key? key}) : super(key: key);

  @override
  State<NewLocationDialog> createState() => _NewLocationDialogState();
}

final Inventory _neededForNew = Inventory(
  blessing: 1,
  scripture: 1,
  charity: 1,
  prayer: 1,
);

enum TileTypeSetting {
  path,
  rocky,
  thorny,
  redeemed;

  GroundTile get toGroundTile {
    switch (this) {
      case TileTypeSetting.path:
        return GroundTile(GroundTileType.path);
      case TileTypeSetting.rocky:
        return GroundTile(GroundTileType.rocky);
      case TileTypeSetting.thorny:
        return GroundTile(GroundTileType.thorny);
      case TileTypeSetting.redeemed:
        return GroundTile(GroundTileType.path)..isRedeemed = true;
    }
  }
}

class _NewLocationDialogState extends State<NewLocationDialog> {
  late Location location;

  List<TileTypeSetting> tileTypeSettings = [
    TileTypeSetting.path,
    TileTypeSetting.rocky,
    TileTypeSetting.thorny,
  ];

  Set<CharacterWithTeam> _charactersToMove = {};

  late Widget tilesViewWidget;

  late final GameProvider game;

  @override
  void initState() {
    game = GameProvider.of(context);
    location = Location(game.teamInPlay);

    tilesViewWidget = LocationGroundTilesView(
      location,
      characterCount: _charactersToMove.length,
      teamId: game.teamInPlay.id,
      teamColor: game.teamInPlay.color,
      key: ObjectKey(location),
    );

    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    tilesViewWidget = Container();
    tilesViewWidget = new LocationGroundTilesView(
      location,
      characterCount: _charactersToMove.length,
      teamId: game.teamInPlay.id,
      teamColor: game.teamInPlay.color,
      key: ObjectKey(location),
    );

    location = Location(GameProvider.of(context).teamInPlay)
      ..tiles = [
        tileTypeSettings[0].toGroundTile,
        tileTypeSettings[1].toGroundTile,
        tileTypeSettings[2].toGroundTile,
      ];
  }

  @override
  Widget build(BuildContext context) {
    tilesViewWidget = LocationGroundTilesView(
      location,
      characterCount: _charactersToMove.length,
      teamId: game.teamInPlay.id,
      teamColor: game.teamInPlay.color,
    );

    return ActionDialog(
      heroTag: "new_location",
      title: "Új missziói állomás",
      icon: Icon(Icons.person_pin_circle_rounded),
      child: Column(
        children: [
          Text("""
A templomos gyülekezetetek már saját lelkipásztorral, működő szolgálatokkal rendelkezik, így a misszionáriusok ezen a missziói területen átadják a munkát, s új szolgálatba léphetnek.
Válasszatok a táblán egy olyan új helyet, ahol háromféle mező határos. Ha ilyen már nincs, akkor két mező típusa azonos is lehet.
Most eldönthetitek, hogy a csapat mindkét misszionáriusa az új állomásra kerüljön, vagy csak egyikük."""),
          SizedBox(height: 10),
          ActionSegmentTitle(
            "Húzd át a kívánt misszionáriusokat az új helyre:",
            subtitle: true,
          ),
          SizedBox(height: 10),
          AnimatedSize(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOutCubicEmphasized,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: game.charactersWithTeams
                  .where((c) =>
                      c.character.currentLocation == game.locationInPlay &&
                      !_charactersToMove.any((e) =>
                          e.character ==
                          c.character)) //why exactly was this needed??
                  .map(
                    (e) => Draggable(
                      data: e,
                      feedback: DragCard(e.team.idWidgetFor(e.character)),
                      child: DragCard(e.team.idWidgetFor(e.character)),
                      childWhenDragging: DragCard(
                          e.team.idWidgetFor(e.character),
                          dragging: true),
                    ),
                  )
                  .toList(),
            ),
          ),
          DragTarget<CharacterWithTeam>(
            onWillAccept: (_) => true,
            onAccept: (e) {
              setState(() {
                _charactersToMove.add(e);
              });
            },
            builder: (context, candidateData, rejectedData) {
              return SizedBox(
                height: 180,
                child: Container(
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: game.teamInPlay.color, width: 3),
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.primaryContainer),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (_charactersToMove.isEmpty)
                              ...List.generate(
                                2,
                                (_) => Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.grey, width: 3),
                                  ),
                                ),
                              ),
                            ..._charactersToMove
                                .map(
                                  (e) => Row(
                                    children: [
                                      e.team.idWidgetFor(e.character),
                                      IconButton(
                                        icon: Icon(Icons.close),
                                        onPressed: () {
                                          setState(() {
                                            _charactersToMove.remove(e);
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                )
                                .toList()
                          ],
                        ),
                      ),
                      Expanded(
                        child: tilesViewWidget,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 10),
          Card(
            clipBehavior: Clip.hardEdge,
            child: ExpansionTile(
              title: Text("Mezők testreszabása"),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ...List.generate(3, (index) {
                      return DropdownButton(
                        itemHeight: 70,
                        value: tileTypeSettings[index],
                        items: [
                          ...TileTypeSetting.values
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child:
                                            GroundTileWidget(e.toGroundTile)),
                                  ))
                              .toList(),
                        ],
                        onChanged: (value) {
                          setState(() {
                            tileTypeSettings[index] = value!;
                          });
                        },
                      );
                    }),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          ActionSegmentTitle("A létrehozáshoz be kell adnod:"),
          Wrap(
            children: game.characterInPlay.inventory!
                .getCompareWithBlessingWidgetList(_neededForNew)
                .map((e) => SizedBox(height: 65, child: e))
                .toList(),
          ),
          ActionSegmentTitle(
            game.characterInPlay.inventory!.canTake(_neededForNew)
                ? "Be tudsz adni mindent! ✅"
                : (game.characterInPlay.inventory!
                            .getTakeWithBlessing(_neededForNew) !=
                        null
                    ? "Be tudsz adni mindent, de hitből kell építkezned!"
                    : "Nem tudsz beadni mindent!"),
            subtitle: true,
          ),
          SizedBox(height: 10),
          Hero(
            tag: "inventory_split",
            child: FilledButton(
                onPressed: _charactersToMove.isNotEmpty &&
                        game.characterInPlay.inventory!
                                .getTakeWithBlessing(_neededForNew) !=
                            null
                    ? () {
                        bool differentNumber = _charactersToMove.length !=
                            game.characters
                                .where((element) =>
                                    element.currentLocation ==
                                    game.locationInPlay)
                                .length;
                        Location newLocation = Location.create(game.teamInPlay)
                          ..tiles = tileTypeSettings
                              .map((e) => e.toGroundTile)
                              .toList();
                        _charactersToMove.forEach((element) {
                          element.character.currentLocation = newLocation;
                        });

                        game.characterInPlay.inventory!.take(game
                            .characterInPlay.inventory!
                            .getTakeWithBlessing(_neededForNew)!);

                        if (differentNumber) {
                          // Split inventories
                          Navigator.pushReplacement(
                              context,
                              ActionRoute(
                                  builder: (_) => InventorySplitDialog()));
                        } else {
                          Navigator.pop(context);
                        }

                        game.notify();
                      }
                    : null,
                child: Text(
                    (_charactersToMove.length !=
                            game.characters
                                .where((element) =>
                                    element.currentLocation ==
                                    game.locationInPlay)
                                .length)
                        ? "Tovább"
                        : "Mehet!",
                    style: TextStyle(fontSize: 20))),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
