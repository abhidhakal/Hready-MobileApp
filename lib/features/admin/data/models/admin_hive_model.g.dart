// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AdminHiveModelAdapter extends TypeAdapter<AdminHiveModel> {
  @override
  final int typeId = 1;

  @override
  AdminHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdminHiveModel(
      adminId: fields[0] as String?,
      name: fields[1] as String,
      profilePicture: fields[2] as String?,
      email: fields[3] as String,
      password: fields[4] as String,
      contactNo: fields[5] as String,
      role: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AdminHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.adminId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.profilePicture)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.password)
      ..writeByte(5)
      ..write(obj.contactNo)
      ..writeByte(6)
      ..write(obj.role);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
