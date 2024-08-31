import 'package:watchman_app/app/models/location_lat_lng.dart';
import 'package:watchman_app/app/models/parking_facilities_model.dart';
import 'package:watchman_app/app/models/positions_model.dart';

class ParkingModel {
  String? id;
  String? ownerId;
  bool? active;
  LocationLatLng? location;

  @override
  String toString() {
    return 'ParkingModel{id: $id, ownerId: $ownerId, active: $active, location: $location, position: $position, address: $address, parkingName: $parkingName, images: $images, parkingSpace: $parkingSpace, countryCode: $countryCode, phoneNumber: $phoneNumber, perHrRate: $perHrRate, startTime: $startTime, endTime: $endTime, parkingType: $parkingType, reviewCount: $reviewCount, reviewSum: $reviewSum, facilities: $facilities, likedUser: $likedUser}';
  }

  Positions? position;
  String? address;
  String? parkingName;
  List<dynamic>? images;
  String? parkingSpace;
  String? countryCode;
  String? phoneNumber;
  String? perHrRate;
  String? startTime;
  String? endTime;
  String? parkingType;
  String? reviewCount;
  String? reviewSum;
  List<ParkingFacilitiesModel>? facilities;
  List<dynamic>? likedUser;

  ParkingModel({
    this.id,
    this.ownerId,
    this.active,
    this.location,
    this.position,
    this.address,
    this.parkingName,
    this.countryCode,
    this.phoneNumber,
    this.images,
    this.startTime,
    this.facilities,
    this.endTime,
    this.likedUser,
    this.perHrRate,
    this.reviewCount,
    this.reviewSum,
    this.parkingSpace,
    this.parkingType,
  });

  ParkingModel.fromJson(Map<String, dynamic> json) {
    if (json['facilities'] != null) {
      facilities = <ParkingFacilitiesModel>[];
      json['facilities'].forEach((v) {
        facilities!.add(ParkingFacilitiesModel.fromJson(v));
      });
    }
    id = json['id'];
    parkingName = json['parkingName'] ?? '';
    ownerId = json['ownerId'];
    address = json['address'] ?? '';
    active = json['active'] ?? false;
    images = json['images'] ?? '';
    likedUser = json['likedUser'] ?? [];
    countryCode = json['countryCode'] ?? '';
    phoneNumber = json['phoneNumber'] ?? '';
    endTime = json['endTime'] ?? '';
    startTime = json['startTime'] ?? '';
    perHrRate = json['perHrRate'] ?? "";
    parkingSpace = json['parkingSpace'] ?? "";
    reviewCount = json['reviewCount'] ?? "0.0";
    reviewSum = json['reviewSum'] ?? "0.0";
    parkingType = json['parkingType'] ?? "2";
    location = json['location'] != null ? LocationLatLng.fromJson(json['location']) : LocationLatLng();
    position = json['position'] != null ? Positions.fromJson(json['position']) : Positions();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (facilities != null) {
      data['facilities'] = facilities!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    data['ownerId'] = ownerId;
    data['parkingName'] = parkingName;
    data['address'] = address;
    data['active'] = active;
    data['images'] = images;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['phoneNumber'] = phoneNumber;
    data['countryCode'] = countryCode;
    data['likedUser'] = likedUser;
    data['reviewCount'] = reviewCount;
    data['reviewSum'] = reviewSum;
    data['perHrRate'] = perHrRate;
    data['parkingSpace'] = parkingSpace;
    data['parkingType'] = parkingType;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (position != null) {
      data['position'] = position!.toJson();
    }
    return data;
  }
}
