import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Resecta/views/helpers/firebase_builders.dart';
import 'package:Resecta/views/helpers/get_projects.dart';
import 'package:Resecta/views/home/list_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resecta"),
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)),
        ),
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(
                child: Image.network("https://www.linkpicture.com/q/Picture1-removebg-preview_1.png"),
              ),
            ),
            ListTile(
              title: const Text("My Projects"),
              onTap: () => Beamer.of(context).beamToNamed('/home/my-projects'),
            ),
            ListTile(
              title: const Text("Private Projects"),
              onTap: () =>
                  Beamer.of(context).beamToNamed('/home/private-projects'),
            ),
            ListTile(
              title: const Text("Public Projects"),
              onTap: () =>
                  Beamer.of(context).beamToNamed('/home/public-projects'),
            ),
            // const Divider(),
            // ListTile(
            //   title: const Text("Create Project"),
            //   trailing: const Icon(Icons.add),
            //   onTap: () => Beamer.of(context).beamToNamed('/home/add-project'),
            // ),
            // const Divider(),
            // ListTile(
            //   title: const Text("Record Assets"),
            //   onTap: () =>
            //       Beamer.of(context).beamToNamed('/home/record-assets'),
            // ),
            const Divider(),
            ListTile(
              title: const Text("Logout"),
              trailing: const Icon(Icons.logout),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Beamer.of(context).beamingHistory.clear();
                Beamer.of(context).beamToNamed("/login");
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey.shade100,
        padding: const EdgeInsets.all(8),
        height: MediaQuery.of(context).size.height,
        child: FirebaseUserStreamBuilder(
          builder: (context, currentUserId) => SingleChildScrollView(
            child: Column(
              children: [
                HomeProjectListSection(
                  title: "My Projects",
                  path: '/home/my-projects',
                  query: getMyProjects(currentUserId),
                ),
                const SizedBox(height: 16),
                HomeProjectListSection(
                  title: "Private Projects",
                  path: '/home/private-projects',
                  query: getPrivateProjects(currentUserId),
                ),
                const SizedBox(height: 16),
                HomeProjectListSection(
                  title: "Public Projects",
                  path: '/home/public-projects',
                  max: 3,
                  query: getPublicProjects(),
                ),
                const SizedBox(height: 72),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Beamer.of(context).beamToNamed('/home/add-project');
        },
        label: const Text("Create Project"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
