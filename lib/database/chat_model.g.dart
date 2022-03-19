// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyChatListAdapter extends TypeAdapter<MyChatList> {
  @override
  final int typeId = 2;

  @override
  MyChatList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyChatList(
      participants: (fields[0] as List?)?.cast<Participant>(),
      isRoom: fields[1] as bool?,
      roomName: fields[2] as String?,
      createdAt: fields[3] as DateTime?,
      updatedAt: fields[4] as DateTime?,
      id: fields[5] as String?,
      lastMessage: fields[6] as LastMessage?,
      unreadMessageList: (fields[7] as List?)?.cast<LastMessage>(),
    );
  }

  @override
  void write(BinaryWriter writer, MyChatList obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.participants)
      ..writeByte(1)
      ..write(obj.isRoom)
      ..writeByte(2)
      ..write(obj.roomName)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.lastMessage)
      ..writeByte(7)
      ..write(obj.unreadMessageList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyChatListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
