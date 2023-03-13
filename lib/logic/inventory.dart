import 'package:flutter/material.dart';
import 'package:magveto_app/graphics/index.dart';

class Inventory {
  /// Ige
  int scripture;

  /// Ima
  int prayer;

  /// Diakónia
  int charity;

  /// Áldás
  int blessing;

  /// A játékos által összesen gyűjtött pontszám.
  int get totalPoints => 0; // TODO: implement

  Inventory({
    this.scripture = 0,
    this.prayer = 0,
    this.charity = 0,
    this.blessing = 0,
  });

  List<int> get asIntList => [scripture, prayer, charity, blessing];
  // return an ItemWidget for each item of each type of item
  List<Widget> get asWidgetList => [
        ...List<Widget>.generate(
            blessing, (index) => ItemWidget(type: ItemType.blessing)),
        ...List<Widget>.generate(
            scripture, (index) => ItemWidget(type: ItemType.scripture)),
        ...List<Widget>.generate(
            prayer, (index) => ItemWidget(type: ItemType.prayer)),
        ...List<Widget>.generate(
            charity, (index) => ItemWidget(type: ItemType.charity)),
      ];

  // Generates widgets for each item of each type in other.
  // Matches other's content to this, and determines if each item can be given.
  List<Widget> getCompareWithBlessingWidgetList(Inventory other) {
    Map<ItemType, int> otherItems = {
      ItemType.blessing: other.blessing,
      ItemType.scripture: other.scripture,
      ItemType.prayer: other.prayer,
      ItemType.charity: other.charity,
    };
    Map<ItemType, int> thisItems = {
      ItemType.blessing: blessing,
      ItemType.scripture: scripture,
      ItemType.prayer: prayer,
      ItemType.charity: charity,
    };
    bool blessingUsedInstead = false;

    // Go trough each item type in other. Subtract it from this if possible.
    // If not, use a blessing one time
    //   (show it in Stack,
    //   in the lower right corner as a blessing item.
    //   Also apply opacity to original item).
    // If not and a blessing has been used before, indicate it on the Stack
    //   with a warning sign icon (same place as blessing item).

    List<Widget> widgets = [];

    for (var otherItem in otherItems.entries) {
      for (var i = 0; i < otherItem.value; i++) {
        bool blessingUsedInsteadForThis = false;
        bool notEnoughOfThis = false;

        if (thisItems[otherItem.key]! < 1) {
          // Not enough to cover
          if (otherItem.key != ItemType.blessing &&
              !blessingUsedInstead &&
              thisItems[ItemType.blessing]! > 0) {
            // Can use blessing instead
            blessingUsedInstead = true;
            blessingUsedInsteadForThis = true;
            thisItems[ItemType.blessing] = thisItems[ItemType.blessing]! - 1;
          } else {
            // Can't use blessing instead
            notEnoughOfThis = true;
          }
        } else {
          // There is enough of this to cover
          thisItems[otherItem.key] = thisItems[otherItem.key]! - 1;
        }

        widgets.add(
          Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity:
                    blessingUsedInsteadForThis || notEnoughOfThis ? 0.5 : 1,
                child: ItemWidget(type: otherItem.key),
              ),
              Transform.translate(
                offset: Offset(15, 15),
                child: blessingUsedInsteadForThis
                    ? SizedBox(
                        height: 40, child: ItemWidget(type: ItemType.blessing))
                    : (notEnoughOfThis
                        ? Icon(
                            Icons.close_rounded,
                            size: 40,
                          )
                        : null),
              )
            ],
          ),
        );
      }
    }

    return widgets;
  }

  bool canTake(Inventory other) {
    return scripture >= other.scripture &&
        prayer >= other.prayer &&
        charity >= other.charity &&
        blessing >= other.blessing;
  }

  // Same logic as getCompareWithBlessingWidgetList.
  // Return an Inventory that has to be taken from this.
  // Return null if not enough items.
  Inventory? getTakeWithBlessing(Inventory other) {
    Map<ItemType, int> otherItems = {
      ItemType.blessing: other.blessing,
      ItemType.scripture: other.scripture,
      ItemType.prayer: other.prayer,
      ItemType.charity: other.charity,
    };
    Map<ItemType, int> thisItems = {
      ItemType.blessing: blessing,
      ItemType.scripture: scripture,
      ItemType.prayer: prayer,
      ItemType.charity: charity,
    };
    bool blessingUsedInstead = false;

    for (var otherItem in otherItems.entries) {
      for (var i = 0; i < otherItem.value; i++) {
        bool notEnoughOfThis = false;

        if (thisItems[otherItem.key]! < 1) {
          // Not enough to cover
          if (otherItem.key != ItemType.blessing &&
              !blessingUsedInstead &&
              thisItems[ItemType.blessing]! > 0) {
            // Can use blessing instead
            blessingUsedInstead = true;
            thisItems[ItemType.blessing] = thisItems[ItemType.blessing]! - 1;
          } else {
            // Can't use blessing instead
            notEnoughOfThis = true;
          }
        } else {
          // There is enough of this to cover
          thisItems[otherItem.key] = thisItems[otherItem.key]! - 1;
        }

        if (notEnoughOfThis) return null;
      }
    }

    return Inventory(
      scripture: other.scripture - thisItems[ItemType.scripture]!,
      prayer: other.prayer - thisItems[ItemType.prayer]!,
      charity: other.charity - thisItems[ItemType.charity]!,
      blessing: other.blessing - thisItems[ItemType.blessing]!,
    );
  }

  void take(Inventory other) {
    scripture -= other.scripture;
    prayer -= other.prayer;
    charity -= other.charity;
    blessing -= other.blessing;
  }

  void give(Inventory other) {
    scripture += other.scripture;
    prayer += other.prayer;
    charity += other.charity;
    blessing += other.blessing;
  }
}

enum ItemType {
  scripture,
  prayer,
  charity,
  blessing,
  scriptureService,
  prayerService,
  charityService
}

/// returns list like: [scripture used, prayer used, charity used, blessing used, pairs]
// TODO use records when they are added to dart
List<int> resolvePairs(List<int> items) {
  var _items = [...items];

  // match pairs of different kinds of incoming items. count the number of pairs possible.
  // one element in the list is one kind of item. the value is the number of items of that kind.

  // go trough each kind of item, and decrement it, until there are no more other item kinds to decrement it together with.
  int i, j, pairs = 0;
  int? thisIndex, otherIndex;
  for (i = 0; i < _items.length; i++) {
    thisIndex = i;
    if (items[thisIndex] < 1) continue;

    while (_items[i] > 0) {
      // find an item kind that can be decremented together with this one
      otherIndex = null;
      for (j = 0; j < _items.length; j++) {
        if (j == i) continue;
        if (_items[j] > 0) {
          otherIndex = j;
          break;
        }
      }
      if (otherIndex == null) break;
      if (items[thisIndex] < 1) break;

      _items[thisIndex]--;
      _items[otherIndex]--;
      pairs++;
    }
  }

  return [
    items[0] - _items[0],
    items[1] - _items[1],
    items[2] - _items[2],
    items[3] - _items[3],
    pairs,
  ];
}
