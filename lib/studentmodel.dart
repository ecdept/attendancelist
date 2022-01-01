import 'package:hive/hive.dart';

part 'studentmodel.g.dart';

@HiveType(typeId: 1)

class StudentModel{

  @HiveField(0)
  final String date;

  @HiveField(1)
  late List<String> attendance;

  StudentModel({required this.date,required this.attendance,});
}