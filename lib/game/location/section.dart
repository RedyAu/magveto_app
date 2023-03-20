import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../graphics/index.dart';
import '../../logic/index.dart';
import 'view.dart';

class LocationSection extends StatelessWidget {
  final BuildContext context;
  LocationSection({required BuildContext this.context, Key? key})
      : super(key: key);

  final ScrollController otherLocationsScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, game, child) {
      Widget rowWidget = Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: LocationView(game.characterInPlay.currentLocation!,
                        LocationViewType.current,
                        key: Key(
                            '${game.characterInPlay.currentLocation!.hashCode}')),
                  ),
                  Container(
                    height: 80,
                    padding: EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InventorySlotWidget(
                            type: ItemType.scriptureService,
                            count: game.locationInPlay.scriptureService),
                        InventorySlotWidget(
                            type: ItemType.prayerService,
                            count: game.locationInPlay.prayerService),
                        InventorySlotWidget(
                            type: ItemType.charityService,
                            count: game.locationInPlay.charityService),
                      ],
                    ),
                  )
                ]),
          ),
          SizedBox(
            width: 100,
            child: FadingEdgeScrollView.fromScrollView(
              shouldDisposeScrollController: true,
              child: ListView(
                controller: otherLocationsScrollController,
                children: Location.locations.map((e) {
                  return AnimatedSize(
                    key: e.key,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOutCubicEmphasized,
                    //height: game.locationInPlay == e ? 14 : 140,
                    child: LocationView(
                      e,
                      game.locationInPlay == e
                          ? LocationViewType.currentOther
                          : LocationViewType.other,
                      key: Key('${e.hashCode}'),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      );

      Future.delayed(Duration(milliseconds: 500))
          .then((value) => Scrollable.ensureVisible(
                game.locationInPlay.key.currentContext!,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOutCubicEmphasized,
              ));

      return rowWidget;
    });
  }
}
