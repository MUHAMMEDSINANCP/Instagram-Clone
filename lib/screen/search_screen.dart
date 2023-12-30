import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screen/profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/utils/global_variables.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(labelText: 'Search for a user'),
          onFieldSubmitted: (String _) {
            setState(() {
              isShowUsers = true;
            });
          },
        ),
      ),
      body: isShowUsers
          ? FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo: searchController.text)
                  .get(),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    // log(snapshot.data?.docs.length.toString() ?? "no dATA");
                    var docData = snapshot.data!.docs[index].data();

                    return docData['photoUrl'] != null
                        ? InkWell(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProfileScreen(uid: docData['uid']),
                              ),
                            ),
                            child: ListTile(
                              title: Text(docData['username']),
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(docData['photoUrl']),
                                radius: 16,
                              ),
                            ),
                          )
                        : const Center(
                            child: Text(
                            "User not found",
                            style: TextStyle(color: Colors.redAccent),
                          ));
                  },
                );
              },
            )
          : FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var docData = snapshot.data!.docs[index].data();
                    return Image.network(docData['postUrl']);
                  },
                  staggeredTileBuilder: (index) => MediaQuery.of(context)
                              .size
                              .width >
                          webScreenSize
                      ? StaggeredTile.count(
                          (index % 7 == 0) ? 1 : 1, (index % 7 == 0) ? 1 : 1)
                      : StaggeredTile.count(
                          (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                );
              },
            ),
    );
  }
}
