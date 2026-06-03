import 'package:flutter/material.dart';
import '../../models/group.dart';

class GroupScreen extends StatelessWidget {
  final Group group;

  const GroupScreen({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grupo ${group.name}'),
      ),
      body: ListView.builder(
        itemCount: group.teams.length,
        itemBuilder: (context, index) {
          final team = group.teams[index];

          return ListTile(
            leading: Text(
              team.flag,
              style: const TextStyle(fontSize: 30),
            ),
            title: Text(team.name),
          );
        },
      ),
    );
  }
}