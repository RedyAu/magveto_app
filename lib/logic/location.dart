import 'game_provider.dart';

enum LocationType {
  /// Missziói állomás
  outpost,

  /// Gyülekezeti ház
  community,

  /// Templom
  church
}

enum TileType { path, rocky, thorny, redeemed }

class Location {
  LocationType type = LocationType.outpost;

  List<TileType> tiles = [TileType.path, TileType.rocky, TileType.thorny];

  /// Bibliaiskola
  int scriptureService = 0;

  /// Imakör
  int prayerService = 0;

  /// Diakóniai szolgálat
  int charityService = 0;

  Location();
}
