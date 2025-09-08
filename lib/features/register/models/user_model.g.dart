// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as int,
      name: fields[1] as String,
      email: fields[2] as String,
      phone: fields[3] as String,
      countryCode: fields[14] as String,
      token: fields[4] as String,
      image: fields[5] as String,
      addedTeamsCount: fields[6] as int,
      addedCommunitiesCount: fields[8] as int,
      addedSubCommunitiesCount: fields[9] as int,
      addedMembersCount: fields[7] as int,
      remainsTeamsCount: fields[10] as int,
      remainsCommunitiesCount: fields[11] as int,
      remainsSubCommunitiesCount: fields[12] as int,
      remainsMembersCount: fields[13] as int,
      workId: fields[15] as String?,
      company: fields[16] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.token)
      ..writeByte(5)
      ..write(obj.image)
      ..writeByte(6)
      ..write(obj.addedTeamsCount)
      ..writeByte(7)
      ..write(obj.addedMembersCount)
      ..writeByte(8)
      ..write(obj.addedCommunitiesCount)
      ..writeByte(9)
      ..write(obj.addedSubCommunitiesCount)
      ..writeByte(10)
      ..write(obj.remainsTeamsCount)
      ..writeByte(11)
      ..write(obj.remainsCommunitiesCount)
      ..writeByte(12)
      ..write(obj.remainsSubCommunitiesCount)
      ..writeByte(13)
      ..write(obj.remainsMembersCount)
      ..writeByte(14)
      ..write(obj.countryCode)
      ..writeByte(15)
      ..write(obj.workId)
      ..writeByte(16)
      ..write(obj.company);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
