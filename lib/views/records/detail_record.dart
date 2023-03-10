import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Resecta/models/project.dart';
import 'package:Resecta/models/record.dart';
import 'package:Resecta/models/user.dart';
import 'package:Resecta/views/helpers/firebase_builders.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:Resecta/views/widgets/tiles/record_field_tile.dart';

class DetailRecordPage extends StatelessWidget {
  final String projectId;
  final String recordId;

  const DetailRecordPage(
      {Key? key, required this.projectId, required this.recordId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get current user
    return FirebaseUserStreamBuilder(
      builder: (context, currentUserId) {
        final projectRef =
            FirebaseFirestore.instance.collection('projects').doc(projectId);
        final recordRef =
            FirebaseFirestore.instance.collection('records').doc(recordId);

        // Get project
        return FirestoreStreamBuilder(
          stream: projectRef.snapshots(),
          builder: (context, projectMap) {
            final project = Project.fromJson(projectMap);

            // Scaffold wrapper
            return Scaffold(
              appBar: AppBar(
                title: const Text('Entry Details'),
              ),
              // Guard for user is owner
              body: FirestoreStreamBuilder(
                stream: recordRef.snapshots(),
                builder: (context, recordMap) {
                  final record = Record.fromJson(recordMap);

                  // User of record
                  return FirestoreStreamBuilder(
                    stream: record.user.snapshots(),
                    builder: (context, userMap) => DetailRecordView(
                      project: project,
                      record: record,
                      recordId: recordId,
                      currentUserId: currentUserId,
                      user: User.fromJson(userMap),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class DetailRecordView extends StatelessWidget {
  final Project project;
  final String recordId;
  final Record record;
  final User user;
  final String currentUserId;

  const DetailRecordView({
    Key? key,
    required this.project,
    required this.recordId,
    required this.record,
    required this.user,
    required this.currentUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = min(project.fields.length, record.fields.length);
    final timeagoMsg = timeago.format(record.timestamp.toDate());

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.card_membership),
          title: Text(recordId),
          subtitle: const Text("Entry ID"),
        ),
        ListTile(
          leading: const Icon(Icons.account_circle),
          title: Text("${user.name} (${user.email})"),
          subtitle: const Text("Added by"),
        ),
        ListTile(
          leading: const Icon(Icons.timer),
          title: Text(
              "${DateFormat('yyyy-MM-dd - kk:mm:ss').format(record.timestamp.toDate())}"
              " ($timeagoMsg)"),
          subtitle: const Text("Added at"),
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: items,
            itemBuilder: (context, index) => RecordFieldTile(
              field: project.fields[index],
              value: record.fields[index],
            ),
          ),
        ),
      ],
    );
  }
}
