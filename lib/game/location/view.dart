import 'package:flutter/material.dart';

import '../../graphics/inventory_slot.dart';
import '../../logic/index.dart';
import 'ground_tiles_view.dart';

enum LocationViewType { current, other }

class LocationView extends StatelessWidget {
  final Location location;
  final Team team;
  final LocationViewType type;

  const LocationView(this.location, this.team, this.type, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: team.color, width: 3),
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.primaryContainer),
          padding: EdgeInsets.all(3),
          margin: EdgeInsets.all(8),
          child: Flex(
            direction: type == LocationViewType.current
                ? Axis.horizontal
                : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: type == LocationViewType.current
                    ? const EdgeInsets.only(right: 8, left: 8)
                    : const EdgeInsets.only(top: 8),
                child: Flex(
                  direction: type == LocationViewType.current
                      ? Axis.vertical
                      : Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: team.characters
                      .where((c) => c.currentLocation == location)
                      .map((c) => Padding(
                            padding: type == LocationViewType.current
                                ? const EdgeInsets.only(bottom: 8)
                                : const EdgeInsets.only(right: 0),
                            child: SizedBox(
                              width: type == LocationViewType.current ? 50 : 30,
                              height:
                                  type == LocationViewType.current ? 50 : 30,
                              child: team.idWidgetFor(c),
                            ),
                          ))
                      .toList(),
                ),
              ),
              Expanded(
                child: LocationGroundTilesView(location,
                    characterCount: (team.characters
                        .where((c) => c.currentLocation == location)
                        .length),
                    teamId: team.id,
                    teamColor: team.color,
                    key: Key('${location.hashCode} ${team.hashCode}}')),
              ),
            ],
          ),
        ),
      ),
      if (type == LocationViewType.current)
        Container(
          height: 80,
          padding: EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InventorySlotWidget(
                  type: ItemType.scriptureService,
                  count: location.scriptureService),
              InventorySlotWidget(
                  type: ItemType.prayerService, count: location.prayerService),
              InventorySlotWidget(
                  type: ItemType.charityService,
                  count: location.charityService),
            ],
          ),
        )
    ]);
  }
}
