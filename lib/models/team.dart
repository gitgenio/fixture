
class Team {
  final String name;
  final String flag;
  final String group;

  int? position; // 1,2,3,4

  Team({
    required this.name,
    required this.flag,
    required this.group,
        this.position,
  });
}