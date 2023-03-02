import 'game_provider.dart';

enum LocationType {
  /// Missziói állomás
  outpost,

  /// Gyülekezeti ház
  community,

  /// Templom
  church
}

class Location {
  LocationType type = LocationType.outpost;

  bool pathTileRedeemed = false;
  bool rockyTileRedeemed = false;
  bool thornyTileRedeemed = false;

  /// Bibliaiskola
  int scriptureService = 0;

  /// Imakör
  int prayerService = 0;

  /// Diakóniai szolgálat
  int charityService = 0;

  Location();
}
