import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../graphics/index.dart';
import '../../logic/index.dart';
import 'view.dart';

class LocationSection extends StatefulWidget {
  final BuildContext context;
  LocationSection({required BuildContext this.context, Key? key})
      : super(key: key);

  @override
  State<LocationSection> createState() => _LocationSectionState();
}

class _LocationSectionState extends State<LocationSection> {
  late ScrollController otherLocationsScrollController;

  @override
  void initState() {
    otherLocationsScrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    otherLocationsScrollController.dispose();
    super.dispose();
  }

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
            child: FadingEdgeScrollView.fromSingleChildScrollView(
              child: SingleChildScrollView(
                controller: otherLocationsScrollController,
                child: Column(
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
          ),
        ],
      );

      // TODO call this from a less hacky place
      Future.delayed(Duration(milliseconds: 500))
          .then((value) => Scrollable.ensureVisible(
                game.locationInPlay.key.currentContext!,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOutCubicEmphasized,
                alignment: 0.5,
              ));

      return rowWidget;
    });
  }
}
