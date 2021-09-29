import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingsModel {
  final String? meetingId;
  final String? meetingTitle;
  final Timestamp? startingTime;
  final Timestamp? endingTime;
  final bool? isAllDay;

  MeetingsModel({
    this.meetingId,
    this.meetingTitle,
    this.startingTime,
    this.endingTime,
    this.isAllDay,
  });

  Map<String, dynamic> toMap() {
    return {
      "meetingId": meetingId,
      "meetingTitle": meetingTitle,
      "startingTime": startingTime,
      "endingTime": endingTime,
      "isAllDay": isAllDay,
    };
  }

  factory MeetingsModel.fromMap(Map map) {
    return MeetingsModel(
      meetingId: map["meetingId"],
      meetingTitle: map["meetingTitle"],
      startingTime: map["startingTime"],
      endingTime: map["endingTime"],
      isAllDay: map["isAllDay"],
    );
  }

  factory MeetingsModel.fromDocument(doc) {
    return MeetingsModel(
      meetingId: doc.data()["meetingId"],
      meetingTitle: doc.data()["meetingTitle"],
      startingTime: doc.data()["startingTime"],
      endingTime: doc.data()["endingTime"],
      isAllDay: doc.data()["isAllDay"],
    );
  }
}
