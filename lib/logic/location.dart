import 'package:flutter/material.dart';

import 'index.dart';

enum LocationType {
  /// Missziói állomás
  outpost,

  /// Gyülekezeti ház
  community,

  /// Templom
  church
}

enum GroundTileType {
  path,
  rocky,
  thorny;

  String get displayName {
    switch (this) {
      case GroundTileType.path:
        return "Út";
      case GroundTileType.rocky:
        return "Sziklás talaj ";
      case GroundTileType.thorny:
        return "Tövises talaj ";
    }
  }

  String get description {
    switch (this) {
      case GroundTileType.path:
        return """
Akinek olyan a szíve, mint az útfél, az hallja ugyan az igét, de nem fogja fel Isten üzenetét, mert az ördög kikapkodja szívéből az igemagot.
Így az útfélen az ige hirdetésére van a legnagyobb szükség.
De nem hanyagolhatja el a misszionárius a szociális segítségnyújtást sem, hiszen ha csak prédikál, s nem cselekszi az igét, nem lesz foganatja a szavainak.
Az imádság pedig önmagában a misszió alapja, ima nélkül csakúgy, mint Isten áldása nélkül, semmibe sem kezdhet a misszionárius.""";
      case GroundTileType.rocky:
        return """Ahol sziklás talajra esik az igemag, ott ugyan befogadják az igét, de nem gyökerezik elég mélyen, nincs kitartó hit, hogy a nehézségeket is vállalni tudják.
Így a misszionáriusoknak legelőször is imádsággal kell megerősíteniük a lelkeket.
De a diakóniai segítségnyújtás sem maradhat el, mert az élet gondja még jobban megkeményítheti az emberek szívét.""";
      case GroundTileType.thorny:
        return """
Akiknek olyan a szívük, mint a tövises föld, azoknál a szociális problémák, az élet gondja-baja, vagy éppen a jólét elnyomja az ige szavát, így ott leginkább a diakóniai lelkületre van szükség.
De Isten igéje nélkül semmit sem ér a segélyosztás, a szociális segítségnyújtás, vagy a mások nyomorúságának megláttatása.""";
    }
  }

  Inventory get giveToRedeem {
    switch (this) {
      case GroundTileType.path:
        return Inventory(
          scripture: 2,
          prayer: 1,
          charity: 1,
          blessing: 1,
        );
      case GroundTileType.rocky:
        return Inventory(
          prayer: 2,
          charity: 1,
          scripture: 1,
          blessing: 1,
        );
      case GroundTileType.thorny:
        return Inventory(
          charity: 2,
          prayer: 1,
          scripture: 1,
          blessing: 1,
        );
    }
  }
}

class GroundTile {
  GroundTileType type;
  bool isRedeemed = false;

  GroundTile(this.type);
}

class Location {
  LocationType type = LocationType.outpost;
  Team team;

  List<GroundTile> tiles = [
    GroundTile(GroundTileType.path),
    GroundTile(GroundTileType.rocky),
    GroundTile(GroundTileType.thorny),
  ];

  static List<Location> locations = [];

  bool get isAllRedeemed => tiles.every((element) => element.isRedeemed);

  GlobalKey key = GlobalKey();

  /// Bibliaiskola
  int scriptureService = 0;

  /// Imakör
  int prayerService = 0;

  /// Diakóniai szolgálat
  int charityService = 0;

  int get index => locations.indexOf(this);

  List<int> get servicesAsIntList =>
      [scriptureService, prayerService, charityService];

  // has at least 3 services in total, and at least of two types.
  bool get isServicesReady =>
      servicesAsIntList.where((element) => element > 0).length >= 2 &&
      servicesAsIntList.reduce((value, element) => value + element) >= 3;

  Location(this.team);

  factory Location.create(Team team) {
    var location = new Location(team);
    locations.add(location);
    // sort by character id (get first character with location)
    try {
      locations.sort((a, b) {
        if (a.team != b.team) return 0;
        return a.team.characters
            .firstWhere((element) => element.currentLocation == a)
            .letter
            .compareTo(b.team.characters
                .firstWhere((element) => element.currentLocation == b)
                .letter);
      });
    } catch (_) {}

    locations.sort((a, b) => a.team.id.compareTo(b.team.id));
    return location;
  }
}
