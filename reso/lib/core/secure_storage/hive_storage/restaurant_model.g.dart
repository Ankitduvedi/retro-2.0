// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RestaurantAdapter extends TypeAdapter<Restaurant> {
  @override
  final int typeId = 0;

  @override
  Restaurant read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Restaurant(
      image: fields[0] as String,
      about: fields[1] as String,
      name: fields[2] as String,
      createdAt: fields[3] as String,
      id: fields[4] as String,
      email: fields[6] as String,
      pushToken: fields[7] as String,
      seats: fields[9] as int,
      phoneNumber: fields[8] as String,
      address: fields[11] as String,
      designation: fields[12] as String,
      isApproved: fields[13] as int,
      tourPage: fields[14] as String,
      isNewUser: fields[10] as bool,
      ownerId: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Restaurant obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.image)
      ..writeByte(1)
      ..write(obj.about)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.ownerId)
      ..writeByte(6)
      ..write(obj.email)
      ..writeByte(7)
      ..write(obj.pushToken)
      ..writeByte(8)
      ..write(obj.phoneNumber)
      ..writeByte(9)
      ..write(obj.seats)
      ..writeByte(10)
      ..write(obj.isNewUser)
      ..writeByte(11)
      ..write(obj.address)
      ..writeByte(12)
      ..write(obj.designation)
      ..writeByte(13)
      ..write(obj.isApproved)
      ..writeByte(14)
      ..write(obj.tourPage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RestaurantAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
