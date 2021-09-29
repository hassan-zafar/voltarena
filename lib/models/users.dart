import 'dart:convert';

class AppUserModel {
  final String? id;
  final String? userName;
  final String? phoneNo;
  final String? password;
  final String? timestamp;
  final bool? isAdmin;
  final String? email;
  final String? androidNotificationToken;

  // final Map? sectionsAppointed;
  AppUserModel(
      {this.id,
      this.userName,

      this.phoneNo,
      this.password,
      this.timestamp,
      this.isAdmin,
      this.email,
      this.androidNotificationToken});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'phoneNo': phoneNo,
      'password': password,
      'timestamp': timestamp,
      'isAdmin': isAdmin,
      'email': email,
      'androidNotificationToken': androidNotificationToken,
    };
  }

  factory AppUserModel.fromMap(Map<String, dynamic> map) {
    return AppUserModel(
        id: map['id'],
        userName: map['userName'],
        phoneNo: map['phoneNo'],
        password: map['password'],
        timestamp: map['timestamp'],
        isAdmin: map['isAdmin'],
        email: map['email'],
        androidNotificationToken: map['androidNotificationToken']);
  }

  factory AppUserModel.fromDocument(doc) {
    return AppUserModel(
        id: doc.data()["id"],
        password: doc.data()["password"],
        userName: doc.data()["userName"],
        timestamp: doc.data()["timestamp"],
        email: doc.data()["email"],
        isAdmin: doc.data()["isAdmin"],
        phoneNo: doc.data()["phoneNo"],
        androidNotificationToken: doc.data()["androidNotificationToken"],
        );
  }

  String toJson() => json.encode(toMap());

  factory AppUserModel.fromJson(String source) =>
      AppUserModel.fromMap(json.decode(source));
}
