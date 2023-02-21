import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Resecta/models/project.dart';
import 'package:Resecta/models/user.dart';
import 'package:Resecta/views/helpers/firebase_builders.dart';

class BlacklistedUserListPage extends StatelessWidget {
  final String projectId;

  const BlacklistedUserListPage({Key? key, required this.projectId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get current user
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: FirebaseUserStreamBuilder(
        builder: (context, currentUserId) {
          final projectRef =
              FirebaseFirestore.instance.collection('projects').doc(projectId);

          // Get project
          return FirestoreStreamBuilder(
            stream: projectRef.snapshots(),
            builder: (context, projectMap) {
              final project = Project.fromJson(projectMap);
              final isOwner = (currentUserId == project.owner.id);
              if (!isOwner) return const Center(child: Text("Not allowed"));

              return ListView.builder(
                itemCount: project.allowedUsers.length,
                itemBuilder: (context, index) {
                  final allowedUserDocRef = project.allowedUsers[index];
                  return FirestoreStreamBuilder(
                    stream: allowedUserDocRef.snapshots(),
                    builder: (context, userMap) {
                      final allowedUser = User.fromJson(userMap);
                      final isBlacklisted =
                          project.blacklistedUsers.contains(allowedUserDocRef);

                      return ListTile(
                        tileColor: Color(0xFFECEFF1),
                        shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)
                                    )
                              ),
                        title:
                            Text("${allowedUser.name} (${allowedUser.email})"),
                        subtitle: isBlacklisted
                            ? const Text("Blacklisted")
                            : const Text("Allowed"),
                        trailing: Icon(
                          isBlacklisted ? Icons.person_add: Icons.block,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onTap: () async {
                          if (isBlacklisted) {
                            await FirebaseFirestore.instance
                                .collection('projects')
                                .doc(projectId)
                                .update({
                              "blacklistedUsers":
                                  FieldValue.arrayRemove([allowedUserDocRef])
                            });
                          } else {
                            await FirebaseFirestore.instance
                                .collection('projects')
                                .doc(projectId)
                                .update({
                              "blacklistedUsers":
                                  FieldValue.arrayUnion([allowedUserDocRef])
                            });
                          }
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
