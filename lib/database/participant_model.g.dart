// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ParticipantAdapter extends TypeAdapter<Participant> {
  @override
  final int typeId = 3;

  @override
  Participant read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Participant(
      username: fields[0] as String?,
      avatar: fields[1] as String?,
      id: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Participant obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.avatar)
      ..writeByte(2)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParticipantAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
