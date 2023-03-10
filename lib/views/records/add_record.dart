import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:Resecta/models/project.dart';
import 'package:Resecta/models/record.dart';
import 'package:Resecta/providers/progress_provider.dart';
import 'package:Resecta/views/helpers/firebase_builders.dart';
import 'package:Resecta/views/helpers/formdata_manager.dart';
import 'package:Resecta/views/helpers/is_allowed.dart';
import 'package:Resecta/views/helpers/snackbar_messages.dart';
import 'package:Resecta/views/widgets/fields/record_field.dart';

class AddRecordPage extends StatelessWidget {
  final String projectId;

  const AddRecordPage({Key? key, required this.projectId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projectRef =
        FirebaseFirestore.instance.collection('projects').doc(projectId);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Add New Entry")),
        body: FirestoreFutureBuilder(
          future: projectRef.get(),
          builder: (context, projectData) => AddRecordPageForm(
            projectId: projectId,
            project: Project.fromJson(projectData),
          ),
        ),
      ),
    );
  }
}

class AddRecordPageForm extends ConsumerWidget {
  final String projectId;
  final Project project;
  final _formKey = GlobalKey<FormBuilderState>();

  AddRecordPageForm({Key? key, required this.projectId, required this.project})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: project.fields.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: RecordFieldWidget(
                  key: Key(index.toString()),
                  index: index,
                  field: project.fields[index],
                ),
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => _handleCencel(context),
                  child: const Text("Cancel"),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFFCFD8DC)),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _handleSubmit(context, ref),
                  child: const Text("Submit"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleCencel(BuildContext context) {
    Beamer.of(context).beamBack();
  }

  void _handleSubmit(BuildContext context, WidgetRef ref) async {
    final formState = _formKey.currentState!;
    if (!formState.validate()) return;
    formState.save();

    final formData = formState.value;

    final progressNotifier = ref.read(progressProvider.notifier);
    progressNotifier.start();
    try {
      // Get current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        showErrorMessage(context, 'You are logged out!');
        Beamer.of(context).beamToNamed('/login');
        return;
      }
      // Make sure users is able to add record
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      if (!isAllowedToAddRecord(userRef, project)) return;

      final formDataManager = FormDataManager(
          projectId: projectId, userId: user.uid, project: project);
      final fieldValues = formDataManager.extract(formData);
      final record = Record(
        user: FirebaseFirestore.instance.collection('users').doc(user.uid),
        project:
            FirebaseFirestore.instance.collection('projects').doc(projectId),
        timestamp: Timestamp.now(),
        status: RecordStatus.done,
        fields: fieldValues,
      );

      // Add current user to allowed list if not already in it
      if (!project.allowedUsers.contains(userRef)) {
        FirebaseFirestore.instance
            .collection('projects')
            .doc(projectId)
            .update({
          "allowedUsers": FieldValue.arrayUnion([userRef])
        });
      }
      // Add record and upload
      FirebaseFirestore.instance.collection('records').add(record.toJson());
      formDataManager.startUploading();
      showSuccessMessage(context, 'Record is being uploaded...');
      Beamer.of(context).beamBack();
    } catch (e) {
      showErrorMessage(context, 'Something went wrong!! Please try again.');
    } finally {
      progressNotifier.stop();
    }
  }
}
