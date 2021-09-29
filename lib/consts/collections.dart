import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volt_arena/models/users.dart';

final userRef = FirebaseFirestore.instance.collection('users');
final calenderRef = FirebaseFirestore.instance.collection('calenderMeetings');
AppUserModel? currentUser;
