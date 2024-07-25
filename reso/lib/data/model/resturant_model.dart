class Restaurant {
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

  late String image;
  late String about;
  late String name;
  late String createdAt;
  late String id;
  late String ownerId;
  late String email;
  late String pushToken;
  late String phoneNumber;
  late int seats;
  late bool isNewUser;
  late String address;
  late String designation;
  late int isApproved;
  late String tourPage = "";

  // Update fromJson method to include the new field
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
    seats = json['seats'] ?? '';
    address = json['address'] ?? '';
    designation = json['designation'] ?? '';
    isApproved = json['isApproved'] ?? 0;
    isNewUser = json['isNewUser'] ?? false;
    tourPage = json['tourPage'] ?? "";
    // Add the new field
  }

  // Update toJson method to include the new field
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

    // Add the new field
    return data;
  }

  // Similarly, update the toMap method if needed
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
      'isNewUser': isNewUser,

      'designation': designation,
      // Add the new field
      'isApproved': isApproved,

      'tourPage': tourPage
    };
  }

  // If you have a factory constructor for creating an empty object, make sure to include the new field there as well
  factory Restaurant.empty() {
    return Restaurant(
        isNewUser: false,
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
        tourPage: "");
  }

  // Add a copyWith method
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
    String? dateOfBirth,
    String? gender,
    String? address,
    String? designation,
    int? isApproved,
    bool? isNewUser,
  }) {
    return Restaurant(
        isNewUser: isNewUser ?? this.isNewUser,
        image: image ?? this.image,
        about: about ?? this.about,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
        id: id ?? this.id,
        ownerId: ownerId ?? this.ownerId,
        email: email ?? this.email,
        pushToken: pushToken ?? this.pushToken,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        seats: seats,
        address: address ?? this.address,
        designation: designation ?? this.designation,
        isApproved: isApproved ?? this.isApproved,
        tourPage: tourPage);
  }
}
