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

  List<GroundTile> tiles = [
    GroundTile(GroundTileType.path),
    GroundTile(GroundTileType.rocky),
    GroundTile(GroundTileType.thorny),
  ];

  Team team;

  /// Bibliaiskola
  int scriptureService = 0;

  /// Imakör
  int prayerService = 0;

  /// Diakóniai szolgálat
  int charityService = 0;

  Location(this.team);
}
