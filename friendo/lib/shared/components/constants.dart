// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum ToastStates { SUCCESS, ERROR, WARNING }
String? uid;
var usersDB = FirebaseFirestore.instance.collection('users');
