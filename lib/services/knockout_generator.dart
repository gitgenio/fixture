import 'dart:math';

import '../models/group.dart';
import '../models/team.dart';
import '../models/match.dart';
import '../data/knockout_rules.dart';

class KnockoutGenerator {

  static Team getThird(
      List<Team> availableThirds,
      List<String> allowedGroups,
      ) {

    final candidates = availableThirds
        .where(
          (team) => allowedGroups.contains(team.group),
    )
        .toList();

    candidates.shuffle();

    final selected = candidates.first;

    availableThirds.remove(selected);

    return selected;
  }

  static List<Match> generateRoundOf32(
      List<Group> groups,
      ) {

    final thirds = groups
        .map(
          (group) => group.teams.firstWhere(
            (team) => team.position == 3,
      ),
    )
        .toList();

    Team first(String groupName) =>
        groups
            .firstWhere((g) => g.name == groupName)
            .teams
            .firstWhere((t) => t.position == 1);

    Team second(String groupName) =>
        groups
            .firstWhere((g) => g.name == groupName)
            .teams
            .firstWhere((t) => t.position == 2);

    return [

      Match(
        home: second('A'),
        away: second('B'),
      ),

      Match(
        home: first('C'),
        away: second('F'),
      ),

      Match(
        home: first('E'),
        away: getThird(
          thirds,
          thirdPlaceRules[74]!,
        ),
      ),

      Match(
        home: first('F'),
        away: second('C'),
      ),

      Match(
        home: second('E'),
        away: second('I'),
      ),

      Match(
        home: first('I'),
        away: getThird(
          thirds,
          thirdPlaceRules[77]!,
        ),
      ),

      Match(
        home: first('A'),
        away: getThird(
          thirds,
          thirdPlaceRules[79]!,
        ),
      ),

      Match(
        home: first('L'),
        away: getThird(
          thirds,
          thirdPlaceRules[80]!,
        ),
      ),

      Match(
        home: first('G'),
        away: getThird(
          thirds,
          thirdPlaceRules[82]!,
        ),
      ),

      Match(
        home: first('D'),
        away: getThird(
          thirds,
          thirdPlaceRules[81]!,
        ),
      ),

      Match(
        home: first('H'),
        away: second('J'),
      ),

      Match(
        home: second('K'),
        away: second('L'),
      ),

      Match(
        home: first('B'),
        away: getThird(
          thirds,
          thirdPlaceRules[85]!,
        ),
      ),

      Match(
        home: first('J'),
        away: second('H'),
      ),

      Match(
        home: first('K'),
        away: getThird(
          thirds,
          thirdPlaceRules[87]!,
        ),
      ),

      Match(
        home: second('D'),
        away: second('G'),
      ),
    ];
  }
}