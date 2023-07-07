// ignore_for_file: constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/user_model.dart';

enum ToastStates { SUCCESS, ERROR, WARNING }

const double iconSize = 20;
String? currentUserId;
var usersCollection = FirebaseFirestore.instance.collection('users');
var storageRef = FirebaseStorage.instance.ref();
UserModel? currentUserModel;

// Images:
String postImage =
    'https://img.freepik.com/free-photo/social-media-concept-with-smartphone_52683-100042.jpg?w=996&t=st=1686823672~exp=1686824272~hmac=80b9e1f260e90380e86b53f226d1e2ff16d1764869ddd07a7e6952ea96f263a0';
String profileImage =
    'https://img.freepik.com/free-photo/digital-painting-mountain-with-colorful-tree-foreground_1340-25699.jpg?w=996&t=st=1686819059~exp=1686819659~hmac=47d9c7e835567a6ad2c3ae54ee999e6a77c73fa1d1860f7653af8e191b04a845';
String introCardImage =
    'https://image.freepik.com/free-photo/horizontal-shot-smiling-curly-haired-woman-indicates-free-space-demonstrates-place-your-advertisement-attracts-attention-sale-wears-green-turtleneck-isolated-vibrant-pink-wall_273609-42770.jpg';
String foodImage =
    'https://img.freepik.com/free-photo/traditional-tajine-dishes-couscous-fresh-salad-rustic-wooden-table-tagine-lamb-meat-pumpkin-top-view-flat-lay_2829-6116.jpg?w=1060&t=st=1687035689~exp=1687036289~hmac=991b40a4460f9444af4064223dd1ba4293523514d2bb3f5b0f09963f22f80c74';
String catImage =
    'https://img.freepik.com/free-photo/close-up-portrait-beautiful-cat_23-2149214419.jpg?w=996&t=st=1687036446~exp=1687037046~hmac=90d6ab32eb696da06d7b842f8ab21295eeec101911317f02369638441f415822';
const String blankImageURL =
    'https://firebasestorage.googleapis.com/v0/b/friendo-14343.appspot.com/o/Blank%20image.png?alt=media&token=6d508ae1-d6b1-4445-af75-504ce4ff061b';
