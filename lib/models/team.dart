
class Team {
  final String name;
  final String flag;

  int? position; // 1,2,3,4

  Team({
    required this.name,
    required this.flag,
    this.position,
  });
}