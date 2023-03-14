import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../logic/index.dart';
import 'view.dart';

class LocationSection extends StatelessWidget {
  final BuildContext context;
  LocationSection({required BuildContext this.context, Key? key})
      : super(key: key);

  final AutoScrollController otherLocationsScrollController =
      AutoScrollController(initialScrollOffset: -10);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, game, child) {
      // HACK very very hack!!!!
      int tagIndex;
      tagIndex = 0;
      int? selectedIndex;
      selectedIndex = null;

      Widget rowWidget = Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: LocationView(game.characterInPlay.currentLocation!,
                        game.teamInPlay, LocationViewType.current,
                        key: Key(
                            '${game.characterInPlay.currentLocation!.hashCode}')),
                  ),
                ]),
          ),
          SizedBox(
            width: 100,
            child: FadingEdgeScrollView.fromScrollView(
              shouldDisposeScrollController: true,
              child: ListView.builder(
                controller: otherLocationsScrollController,
                itemBuilder: (context, int index) {
                  return AutoScrollTag(
                    index: tagIndex,
                    key: ValueKey(index),
                    controller: otherLocationsScrollController,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: game.teams[index].characters
                            .map((e) => e.currentLocation)
                            .toSet()
                            .map((e) {
                          tagIndex++;

                          if (game.locationInPlay == e)
                            selectedIndex = tagIndex;

                          return AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOutCubicEmphasized,
                            height: game.locationInPlay == e ? 14 : 140,
                            child: LocationView(
                                e!, game.teams[index], LocationViewType.other,
                                key: Key('${e.hashCode}')),
                          );
                        }).toList()),
                  );
                },
                itemCount: game.teams.length,
                shrinkWrap: true,
              ),
            ),
          ),
        ],
      );

      // HACK very very hack!!!!
      Future.delayed(Duration(milliseconds: 550)).then((_) {
        print('Locations section built, selected index: $selectedIndex');
        if (selectedIndex != null) {
          otherLocationsScrollController.scrollToIndex(
            selectedIndex! - 1,
            preferPosition: AutoScrollPosition.middle,
          );
        }
      });

      return rowWidget;
    });
  }
}
