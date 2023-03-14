import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:magveto_app/graphics/index.dart';
import 'package:magveto_app/logic/index.dart';

import '../../../action_dialog.dart';

class ServicesDialog extends StatefulWidget {
  const ServicesDialog(BuildContext context, {Key? key}) : super(key: key);

  @override
  _ServicesDialogState createState() => _ServicesDialogState();
}

class _ServicesDialogState extends State<ServicesDialog> {
  ScrollController segmentedButtonScrollController = ScrollController();
  Set<ServiceType> _selectedServiceSet = {};
  ServiceType get selectedService {
    if (_selectedServiceSet.isEmpty) {
      return ServiceType.values.first;
    }
    return _selectedServiceSet.single;
  }

  @override
  Widget build(BuildContext context) {
    GameProvider game = GameProvider.of(context);

    return ActionDialog(
        heroTag: "service",
        title: "Szolgálat indítása",
        icon: Icon(Icons.add_circle_outline_rounded),
        child: Column(
          children: [
            Text(
                "Ahhoz, hogy a gyülekezet tovább gyarapodhasson, s templomos gyülekezetté váljon, gyülekezeti szolgálatokat kell kiépíteni."),
            SizedBox(height: 20),
            ActionSegmentTitle(
              "Válaszd ki, milyen szolgálatot szeretnél indítani:",
              subtitle: true,
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 70,
              child: FadingEdgeScrollView.fromSingleChildScrollView(
                shouldDisposeScrollController: true,
                child: SingleChildScrollView(
                  controller: segmentedButtonScrollController,
                  scrollDirection: Axis.horizontal,
                  child: SegmentedButton<ServiceType>(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (states) {
                          if (states.contains(MaterialState.selected)) {
                            return Theme.of(context)
                                .colorScheme
                                .primaryContainer;
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
                    selected: _selectedServiceSet,
                    onSelectionChanged: (value) {
                      setState(() {
                        _selectedServiceSet = value;
                      });
                    },
                    segments: ServiceType.values
                        .map(
                          (e) => ButtonSegment<ServiceType>(
                            value: e,
                            label: SizedBox(
                              height: 70,
                              width: 70,
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: ItemWidget(
                                  type: ItemType.values.firstWhere(
                                      (element) => element.name == e.name),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOutCubicEmphasized,
              height: _selectedServiceSet.isEmpty ? 0 : 230,
              child: _selectedServiceSet.isEmpty
                  ? null
                  : Column(
                      children: [
                        Spacer(flex: 2),
                        ActionSegmentTitle(
                          "${selectedService.displayName} indításához szükséges:",
                        ),
                        Spacer(flex: 1),
                        Wrap(
                          children: game.characterInPlay.inventory!
                              .getCompareWithBlessingWidgetList(
                                  selectedService.giveToStart)
                              .map((e) => SizedBox(height: 65, child: e))
                              .toList(),
                        ),
                        ActionSegmentTitle(
                          game.characterInPlay.inventory!
                                  .canTake(selectedService.giveToStart)
                              ? "Be tudsz adni mindent! ✅"
                              : (game.characterInPlay.inventory!
                                          .getTakeWithBlessing(
                                              selectedService.giveToStart) !=
                                      null
                                  ? "Be tudsz adni mindent, de a hitből kell építkezned! ⭐"
                                  : "Nem tudsz beadni mindent! ❌"),
                          subtitle: true,
                        ),
                        Spacer(flex: 3),
                        FilledButton(
                          onPressed: game.characterInPlay.inventory!
                                      .getTakeWithBlessing(
                                          selectedService.giveToStart) !=
                                  null
                              ? () {
                                  game.characterInPlay.inventory!.take(game
                                      .characterInPlay.inventory!
                                      .getTakeWithBlessing(
                                          selectedService.giveToStart)!);

                                  switch (selectedService) {
                                    case ServiceType.scriptureService:
                                      game.locationInPlay.scriptureService++;
                                      break;
                                    case ServiceType.prayerService:
                                      game.locationInPlay.prayerService++;
                                      break;
                                    case ServiceType.charityService:
                                      game.locationInPlay.charityService++;
                                      break;
                                  }

                                  game.notify();
                                  Navigator.pop(context);
                                }
                              : null,
                          child: Text(
                            "Mehet!",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Spacer(flex: 3)
                      ],
                    ),
            ),
          ],
        ));
  }
}

enum ServiceType {
  scriptureService,
  prayerService,
  charityService;

  String get displayName {
    switch (this) {
      case ServiceType.scriptureService:
        return "Bibliaiskola";
      case ServiceType.prayerService:
        return "Imakör";
      case ServiceType.charityService:
        return "Diakóniai szolgálat";
    }
  }

  Inventory get giveToStart {
    switch (this) {
      case ServiceType.scriptureService:
        return Inventory(
          scripture: 2,
          prayer: 1,
          blessing: 1,
        );
      case ServiceType.prayerService:
        return Inventory(
          prayer: 2,
          charity: 1,
          blessing: 1,
        );
      case ServiceType.charityService:
        return Inventory(
          charity: 2,
          prayer: 1,
          blessing: 1,
        );
    }
  }
}
