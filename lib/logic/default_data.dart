import 'package:flutter/material.dart';

import 'team.dart';

List<Team> getDefaultTeams() => [
      Team(1, Color(0xffffed00), [
        Character(CID.joe, "A", characterNames[CID.joe]!,
            characterDescriptions[CID.joe]!),
        Character(CID.mary, "B", characterNames[CID.mary]!,
            characterDescriptions[CID.mary]!),
      ]),
      Team(2, Color(0xffee7f00), [
        Character(CID.janos, "A", characterNames[CID.janos]!,
            characterDescriptions[CID.janos]!),
        Character(CID.maria, "B", characterNames[CID.maria]!,
            characterDescriptions[CID.maria]!),
      ]),
      Team(3, Color(0xffe2001a), [
        Character(CID.hansi, "A", characterNames[CID.hansi]!,
            characterDescriptions[CID.hansi]!),
        Character(CID.gertrud, "B", characterNames[CID.gertrud]!,
            characterDescriptions[CID.gertrud]!),
      ]),
      Team(4, Color(0xff81197f), [
        Character(CID.teofil, "A", characterNames[CID.teofil]!,
            characterDescriptions[CID.teofil]!),
        Character(CID.teofilia, "B", characterNames[CID.teofilia]!,
            characterDescriptions[CID.teofilia]!),
      ]),
      Team(5, Color(0xff008bd0), [
        Character(CID.ivan, "A", characterNames[CID.ivan]!,
            characterDescriptions[CID.ivan]!),
        Character(CID.tatjana, "B", characterNames[CID.tatjana]!,
            characterDescriptions[CID.tatjana]!),
      ]),
      Team(6, Color(0xff009037), [
        Character(CID.jeanphilip, "A", characterNames[CID.jeanphilip]!,
            characterDescriptions[CID.jeanphilip]!),
        Character(CID.bernadette, "B", characterNames[CID.bernadette]!,
            characterDescriptions[CID.bernadette]!),
      ]),
    ];

Map<CID, String> characterNames = {
  CID.joe: "Joe, az áldott",
  CID.mary: "Mary, a szervező",
  CID.janos: "János, az egykönyvű ember",
  CID.maria: "Mária, az építő",
  CID.hansi: "Hansi, az arató",
  CID.gertrud: "Gertrúd, a hiánypótló",
  CID.teofil: "Teofil, a könyörületes szívű",
  CID.teofilia: "Teofília, az útépítő",
  CID.ivan: "Iván, a hiánypótló",
  CID.tatjana: "Tatjana, az arató",
  CID.jeanphilip: "Jean-Philip, az imaharcos",
  CID.bernadette: "Bernadette, a szolgáló",
};

Map<CID, String> characterDescriptions = {
  CID.joe: //! how the hell even
      "Ha valaki áldást kap, Joe is részesedik belőle (ő is kap egy áldáscsillagot).",
  CID.mary: //? done
      "Minden körben szabadon (ellenérték nélkül) lerakhat egy útelemet, ha szüksége van rá.",
  CID.janos: //? done
      "Ha valaki igeolvasáson vesz részt (1-est dob), János is ott van (ő is kap egy igekártyát).",
  CID.maria:
      "Ahhoz, hogy temploma megépüljön, csak két gyülekezeti szolgálatot kell beindítania.",
  CID.hansi:
      "Ha két földje váltságot nyer, ráadásként a harmadikat is megfordíthatja.",
  CID.gertrud: //? done
      "Ha páratlant dob, a felhúzott kártyáján túl még egy olyan ige-, ima-, vagy diakóniakártyát is felvehet, amilyenre a legnagyobb szüksége van.",
  CID.teofil: //? done
      "Ha valaki diakóniai eseményen vesz részt (3-ast dob), Teofil is segít (ő is kap egy diakóniakártyát).",
  CID.teofilia: //? done
      "Minden körben szabadon (ellenérték nélkül) lerakhat egy útelemet, ha szüksége van rá.",
  CID.ivan: //? done
      "Ha párosat dob, a felhúzott kártyáján túl még egy olyan ige-, ima-, vagy diakóniakártyát is felvehet, amilyenre a legnagyobb szüksége van.",
  CID.tatjana:
      "Ha két földje váltságot nyer, ráadásként a harmadikat is megfordíthatja.",
  CID.jeanphilip: //? done
      "Ha valaki imádkozik (2-est dob), Jean-Philip is vele tart (ő is kap egy imakártyát).",
  CID.bernadette:
      "Ahhoz, hogy temploma megépüljön, csak két gyülekezeti szolgálatot kell beindítania.",
};

final Map<Trait, List<CID?>> traitMap = {
  Trait.freeRoad: [CID.mary, CID.teofilia],
  Trait.thirdService: [CID.maria, CID.bernadette],
  Trait.thirdTile: [CID.hansi, CID.tatjana],
  Trait.oddRoll: [CID.gertrud],
  Trait.evenRoll: [CID.ivan],
  Trait.scriptureRoll: [CID.janos],
  Trait.prayerRoll: [CID.jeanphilip],
  Trait.charityRoll: [CID.teofil],
  Trait.allBlessing: [CID.joe],
};
