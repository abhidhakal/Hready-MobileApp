// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmployeeHiveModelAdapter extends TypeAdapter<EmployeeHiveModel> {
  @override
  final int typeId = 3;

  @override
  EmployeeHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmployeeHiveModel(
      employeeId: fields[0] as String?,
      name: fields[1] as String,
      email: fields[2] as String,
      password: fields[3] as String,
      profilePicture: fields[4] as String,
      contactNo: fields[5] as String,
      role: fields[6] as String,
      department: fields[7] as String,
      position: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EmployeeHiveModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.employeeId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.profilePicture)
      ..writeByte(5)
      ..write(obj.contactNo)
      ..writeByte(6)
      ..write(obj.role)
      ..writeByte(7)
      ..write(obj.department)
      ..writeByte(8)
      ..write(obj.position);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeeHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
