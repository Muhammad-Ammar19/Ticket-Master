// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TicketAdapter extends TypeAdapter<Ticket> {
  @override
  final int typeId = 0;

  @override
  Ticket read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ticket(
      seatNumber: fields[0] as String,
      section: fields[1] as String,
      row: fields[2] as String,
      date: fields[3] as String,
      time: fields[4] as String,
      imageUrl: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Ticket obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.seatNumber)
      ..writeByte(1)
      ..write(obj.section)
      ..writeByte(2)
      ..write(obj.row)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.time)
      ..writeByte(5)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TicketAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
