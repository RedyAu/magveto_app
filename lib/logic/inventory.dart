// factor out the logic for the inventory

import 'team.dart';

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

  bool canTake(Inventory other) {
    return scripture >= other.scripture &&
        prayer >= other.prayer &&
        charity >= other.charity &&
        blessing >= other.blessing;
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
