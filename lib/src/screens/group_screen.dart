import 'package:fixture2026/src/screens/round_of_32_screen.dart';
import 'package:flutter/material.dart';
import '../../models/group.dart';
import '../../models/team.dart';

class GroupScreen extends StatefulWidget {
  final Group group;

  const GroupScreen({
    super.key,
    required this.group,
  });

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final List<Team> selectedTeams = [];

  @override
  void initState() {
    super.initState();
    // ------------------------------------------------------------------
    // Limpiamos las posiciones anteriores al entrar a la pantalla
    // para evitar que queden estados corruptos (ej. dos primeros lugares)
    // ------------------------------------------------------------------
    for (var team in widget.group.teams) {
      team.position = null;
    }
  }

  void selectTeam(Team team) {
    if (selectedTeams.contains(team)) {
      return;
    }

    if (selectedTeams.length < 3) {
      setState(() {
        selectedTeams.add(team);
        team.position = selectedTeams.length;
      });

      if (selectedTeams.length == 3) {
        assignFourthPlace();
      }
    }
  }

  void assignFourthPlace() {

    final remaining = widget.group.teams.firstWhere(
          (team) => !selectedTeams.contains(team),
    );

    remaining.position = 4;
  }

  int? getPosition(Team team) {
    return team.position;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grupo ${widget.group.name}'),
      ),
      body: ListView.builder(
        itemCount: widget.group.teams.length,
        itemBuilder: (context, index) {

          final team = widget.group.teams[index];

          return ListTile(
            onTap: () => selectTeam(team),

            leading: Text(
              team.flag,
              style: const TextStyle(fontSize: 30),
            ),

            title: Text(team.name),

            trailing: getPosition(team) != null
                ? CircleAvatar(
              child: Text(
                '${getPosition(team)}',
              ),
            )
                : null,
          );
        },
      ),
    );
  }


}
