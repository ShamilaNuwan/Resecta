import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:Resecta/models/project.dart';
import 'package:Resecta/views/helpers/color_gen.dart';

class ProjectListCard extends StatelessWidget {
  final String projectId;
  final Project project;

  const ProjectListCard({
    Key? key,
    required this.projectId,
    required this.project,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Beamer.of(context).beamToNamed('/home/project/$projectId');
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset.fromDirection(1, 1),
              blurRadius: 1,
              color: Colors.grey.shade400,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              width: 50,
              height: 50,
              child: Center(
                child: Text(
                  project.name[0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              decoration: BoxDecoration(
                color: generateColor(project.name),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      project.name,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Text(
                    project.description,
                    textAlign: TextAlign.justify,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
