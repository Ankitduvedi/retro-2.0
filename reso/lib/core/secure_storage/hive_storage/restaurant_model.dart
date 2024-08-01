import 'package:hive/hive.dart';

part 'restaurant_model.g.dart';

@HiveType(typeId: 0)
class Restaurant extends HiveObject {
  @HiveField(0)
  late String image;

  @HiveField(1)
  late String about;

  @HiveField(2)
  late String name;

  @HiveField(3)
  late String createdAt;

  @HiveField(4)
  late String id;

  @HiveField(5)
  late String ownerId;

  @HiveField(6)
  late String email;

  @HiveField(7)
  late String pushToken;

  @HiveField(8)
  late String phoneNumber;

  @HiveField(9)
  late int seats;

  @HiveField(10)
  late bool isNewUser;

  @HiveField(11)
  late String address;

  @HiveField(12)
  late String designation;

  @HiveField(13)
  late int isApproved;

  @HiveField(14)
  late String tourPage;

  Restaurant({
    required this.image,
    required this.about,
    required this.name,
    required this.createdAt,
    required this.id,
    required this.email,
    required this.pushToken,
    required this.seats,
    required this.phoneNumber,
    required this.address,
    required this.designation,
    required this.isApproved,
    required this.tourPage,
    required this.isNewUser,
    required this.ownerId,
  });

  Restaurant.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    about = json['about'] ?? '';
    name = json['name'] ?? '';
    createdAt = json['created_at'] ?? '';
    id = json['id'] ?? '';
    ownerId = json['ownerId'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
    phoneNumber = json['phoneNumber'] ?? '';
    seats = json['seats'] ?? 0;
    address = json['address'] ?? '';
    designation = json['designation'] ?? '';
    isApproved = json['isApproved'] ?? 0;
    isNewUser = json['isNewUser'] ?? false;
    tourPage = json['tourPage'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['about'] = about;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['ownerId'] = ownerId;
    data['email'] = email;
    data['push_token'] = pushToken;
    data['phoneNumber'] = phoneNumber;
    data['seats'] = seats;
    data['address'] = address;
    data['designation'] = designation;
    data['isApproved'] = isApproved;
    data['tourPage'] = tourPage;
    data['isNewUser'] = isNewUser;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'about': about,
      'name': name,
      'createdAt': createdAt,
      'id': id,
      'ownerId': ownerId,
      'email': email,
      'pushToken': pushToken,
      'seats': seats,
      'phoneNumber': phoneNumber,
      'address': address,
      'designation': designation,
      'isApproved': isApproved,
      'tourPage': tourPage,
      'isNewUser': isNewUser,
    };
  }

  factory Restaurant.empty() {
    return Restaurant(
      image: '',
      about: '',
      name: '',
      createdAt: '',
      id: '',
      ownerId: '',
      email: '',
      pushToken: '',
      seats: 0,
      phoneNumber: '',
      address: '',
      designation: '',
      isApproved: 0,
      tourPage: '',
      isNewUser: false,
    );
  }

  Restaurant copyWith({
    String? image,
    String? about,
    String? name,
    String? createdAt,
    String? id,
    String? ownerId,
    String? email,
    String? pushToken,
    String? phoneNumber,
    int? seats,
    String? address,
    String? designation,
    int? isApproved,
    bool? isNewUser,
    String? tourPage,
  }) {
    return Restaurant(
      image: image ?? this.image,
      about: about ?? this.about,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      email: email ?? this.email,
      pushToken: pushToken ?? this.pushToken,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      seats: seats ?? this.seats,
      address: address ?? this.address,
      designation: designation ?? this.designation,
      isApproved: isApproved ?? this.isApproved,
      isNewUser: isNewUser ?? this.isNewUser,
      tourPage: tourPage ?? this.tourPage,
    );
  }
}
