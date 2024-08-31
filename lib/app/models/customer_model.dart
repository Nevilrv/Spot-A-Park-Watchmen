import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  String? fullName;
  String? id;
  String? email;
  String? loginType;
  String? profilePic;
  String? fcmToken;
  String? countryCode;
  String? phoneNumber;
  String? walletAmount;
  String? gender;
  Timestamp? createdAt;

  CustomerModel(
      {this.fullName,
      this.id,
      this.email,
      this.loginType,
      this.profilePic,
      this.fcmToken,
      this.countryCode,
      this.phoneNumber,
      this.walletAmount,
      this.createdAt});

  @override
  String toString() {
    return 'CustomerModel{fullName: $fullName, id: $id, email: $email, loginType: $loginType, profilePic: $profilePic, fcmToken: $fcmToken, countryCode: $countryCode, phoneNumber: $phoneNumber, walletAmount: $walletAmount, gender: $gender, createdAt: $createdAt}';
  }

  CustomerModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    id = json['id'];
    email = json['email'];
    loginType = json['loginType'];
    profilePic = json['profilePic'];
    fcmToken = json['fcmToken'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    walletAmount = json['walletAmount'] ?? "0";
    createdAt = json['createdAt'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['id'] = id;
    data['email'] = email;
    data['loginType'] = loginType;
    data['profilePic'] = profilePic;
    data['fcmToken'] = fcmToken;
    data['countryCode'] = countryCode;
    data['phoneNumber'] = phoneNumber;
    data['walletAmount'] = walletAmount;
    data['createdAt'] = createdAt;
    data['gender'] = gender;

    return data;
  }
}
