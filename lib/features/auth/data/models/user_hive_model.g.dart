// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserHiveModelAdapter extends TypeAdapter<UserHiveModel> {
  @override
  final int typeId = 2;

  @override
  UserHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserHiveModel(
      userId: fields[0] as String?,
      name: fields[1] as String,
      email: fields[2] as String,
      role: fields[3] as String,
      profilePicture: fields[4] as String?,
      contactNo: fields[5] as String?,
      department: fields[6] as String?,
      position: fields[7] as String?,
      dateOfJoining: fields[8] as DateTime?,
      status: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserHiveModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.role)
      ..writeByte(4)
      ..write(obj.profilePicture)
      ..writeByte(5)
      ..write(obj.contactNo)
      ..writeByte(6)
      ..write(obj.department)
      ..writeByte(7)
      ..write(obj.position)
      ..writeByte(8)
      ..write(obj.dateOfJoining)
      ..writeByte(9)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
