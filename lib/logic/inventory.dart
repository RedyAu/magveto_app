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

  /// Plusz 3 pont
  int extra3points;

  /// A játékos által összesen gyűjtött pontszám.
  int get totalPoints => 0; // TODO: implement

  Inventory({
    this.scripture = 0,
    this.prayer = 0,
    this.charity = 0,
    this.blessing = 0,
    this.extra3points = 0,
  });

  bool canTake(Inventory other) {
    return scripture >= other.scripture &&
        prayer >= other.prayer &&
        charity >= other.charity &&
        blessing >= other.blessing &&
        extra3points >= other.extra3points;
  }

  void take(Inventory other) {
    scripture -= other.scripture;
    prayer -= other.prayer;
    charity -= other.charity;
    blessing -= other.blessing;
    extra3points -= other.extra3points;
  }

  void give(Inventory other) {
    scripture += other.scripture;
    prayer += other.prayer;
    charity += other.charity;
    blessing += other.blessing;
    extra3points += other.extra3points;
  }
}

/// Pozitív érték esetén a 'to' játékos kap, negatív esetén ad.
class InventoryTransaction extends Inventory {
  /// Null esetén a játék adja vagy veszi el a tárgyakat.
  Character? from;
  Character to;

  InventoryTransaction({
    this.from,
    required this.to,
    int scripture = 0,
    int prayer = 0,
    int charity = 0,
    int blessing = 0,
    int extra3points = 0,
  }) : super(
          scripture: scripture,
          prayer: prayer,
          charity: charity,
          blessing: blessing,
          extra3points: extra3points,
        );
}
