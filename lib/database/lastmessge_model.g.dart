// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lastmessge_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LastMessageAdapter extends TypeAdapter<LastMessage> {
  @override
  final int typeId = 4;

  @override
  LastMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LastMessage(
      senderId: fields[0] as String?,
      message: fields[1] as String?,
      conversationId: fields[2] as String?,
      createdAt: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, LastMessage obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.senderId)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.conversationId)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LastMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
