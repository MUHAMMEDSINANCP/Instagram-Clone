import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screen/add_post_screen.dart';
import 'package:instagram_clone/screen/profile_screen.dart';
import 'package:instagram_clone/screen/search_screen.dart';

import '../screen/feed_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
 const FeedScreen(),
const  SearchScreen(),
const  AddPostScreen(),
 const Text('notification'),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
