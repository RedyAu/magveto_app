import 'index.dart';

enum LocationType {
  /// Missziói állomás
  outpost,

  /// Gyülekezeti ház
  community,

  /// Templom
  church
}

enum GroundTileType { path, rocky, thorny }

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

  bool get isAllRedeemed => tiles.every((element) => element.isRedeemed);

  /// Bibliaiskola
  int scriptureService = 0;

  /// Imakör
  int prayerService = 0;

  /// Diakóniai szolgálat
  int charityService = 0;

  List<int> get servicesAsIntList =>
      [scriptureService, prayerService, charityService];

  // has at least 3 services in total, and at least of two types.
  bool get isServicesReady =>
      servicesAsIntList.where((element) => element > 0).length >= 2 &&
      servicesAsIntList.reduce((value, element) => value + element) >= 3;

  Location(this.team);
}
