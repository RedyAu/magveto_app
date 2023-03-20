import 'package:flutter/material.dart';

import '../../logic/index.dart';
import 'ground_tiles_view.dart';

enum LocationViewType { current, other, currentOther }

class LocationView extends StatelessWidget {
  final Location location;
  final LocationViewType type;

  const LocationView(this.location, this.type, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: location.team.color, width: 3),
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.primaryContainer),
      padding: (type != LocationViewType.currentOther)
          ? EdgeInsets.all(3)
          : EdgeInsets.zero,
      margin: type == LocationViewType.current
          ? EdgeInsets.all(8)
          : EdgeInsets.only(top: 8, right: 8),
      child: (type != LocationViewType.currentOther)
          ? Flex(
              direction: type == LocationViewType.current
                  ? Axis.horizontal
                  : Axis.vertical,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: type == LocationViewType.current
                      ? const EdgeInsets.only(left: 8)
                      : const EdgeInsets.only(top: 8),
                  child: Flex(
                    direction: type == LocationViewType.current
                        ? Axis.vertical
                        : Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: location.team.characters
                        .where((c) => c.currentLocation == location)
                        .map((c) => SizedBox(
                              width: type == LocationViewType.current ? 50 : 30,
                              height:
                                  type == LocationViewType.current ? 50 : 30,
                              child: location.team.idWidgetFor(c),
                            ))
                        .toList(),
                  ),
                ),
                if (type == LocationViewType.current)
                  Expanded(child: groundTilesView())
                else
                  groundTilesView()
              ],
            )
          : null,
    );
  }

  LocationGroundTilesView groundTilesView() {
    return LocationGroundTilesView(location,
        characterCount: (location.team.characters
            .where((c) => c.currentLocation == location)
            .length),
        teamId: location.team.id,
        teamColor: location.team.color,
        key: Key('${location.hashCode} ${location.team.hashCode}}'));
  }
}
