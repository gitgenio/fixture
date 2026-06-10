import 'dart:math';

import '../models/group.dart';
import '../models/team.dart';
import '../models/football_match.dart';
import '../data/knockout_rules.dart';

class KnockoutGenerator {

  static Team getThird(
      List<Team> availableThirds,
      List<String> allowedGroups,
      ) {

    final candidates = availableThirds
        .where(
          (team) => allowedGroups.contains(team.name),
    )
        .toList();

    candidates.shuffle();

    final selected = candidates.first;

    availableThirds.remove(selected);

    return selected;
  }

  static List<FootballMatch> generateRoundOf32(
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

      FootballMatch(
        home: second('A'),
        away: second('B'),
      ),

      FootballMatch(
        home: first('C'),
        away: second('F'),
      ),

      FootballMatch(
        home: first('E'),
        away: getThird(
          thirds,
          thirdPlaceRules[74]!,
        ),
      ),

      FootballMatch(
        home: first('F'),
        away: second('C'),
      ),

      FootballMatch(
        home: second('E'),
        away: second('I'),
      ),

      FootballMatch(
        home: first('I'),
        away: getThird(
          thirds,
          thirdPlaceRules[77]!,
        ),
      ),

      FootballMatch(
        home: first('A'),
        away: getThird(
          thirds,
          thirdPlaceRules[79]!,
        ),
      ),

      FootballMatch(
        home: first('L'),
        away: getThird(
          thirds,
          thirdPlaceRules[80]!,
        ),
      ),

      FootballMatch(
        home: first('G'),
        away: getThird(
          thirds,
          thirdPlaceRules[82]!,
        ),
      ),

      FootballMatch(
        home: first('D'),
        away: getThird(
          thirds,
          thirdPlaceRules[81]!,
        ),
      ),

      FootballMatch(
        home: first('H'),
        away: second('J'),
      ),

      FootballMatch(
        home: second('K'),
        away: second('L'),
      ),

      FootballMatch(
        home: first('B'),
        away: getThird(
          thirds,
          thirdPlaceRules[85]!,
        ),
      ),

      FootballMatch(
        home: first('J'),
        away: second('H'),
      ),

      FootballMatch(
        home: first('K'),
        away: getThird(
          thirds,
          thirdPlaceRules[87]!,
        ),
      ),

      FootballMatch(
        home: second('D'),
        away: second('G'),
      ),
    ];
  }
}