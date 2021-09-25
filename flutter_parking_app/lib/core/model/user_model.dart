class UserModel {
  String uid;
  String email;
  String firstName;
  String secondName;
  bool isClient = true;

  UserModel(
      {this.uid, this.email, this.firstName, this.secondName, this.isClient});

  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        firstName: map['firstName'],
        secondName: map['secondName'],
        isClient: map['isClient']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
      'isClient': isClient
    };
  }
}
