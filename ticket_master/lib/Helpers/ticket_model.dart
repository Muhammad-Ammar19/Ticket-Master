import 'package:hive/hive.dart';

part 'ticket_model.g.dart';

@HiveType(typeId: 0)
class Ticket extends HiveObject {
  @HiveField(0)
  String seatNumber;

  @HiveField(1)
  String section;

  @HiveField(2)
  String row;

  @HiveField(3)
  String date;

  @HiveField(4)
  String time;

  @HiveField(5)
  String imageUrl;

  Ticket({
    required this.seatNumber,
    required this.section,
    required this.row,
    required this.date,
    required this.time,
    required this.imageUrl,
  });
}
