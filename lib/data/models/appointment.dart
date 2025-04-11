import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

part 'appointment.g.dart';

@collection
class Appointment {
  Appointment(
    this.title,
    this.dateTime,
    this.location,
    this.facility,
    this.doctor,
    this.status,
  );

  Id id = Isar.autoIncrement;

  String? title;
  DateTime? dateTime;
  String? location;
  String? facility;
  String? doctor;
  String? status;
  int? timeStartMinutes;
  int? timeEndMinutes;

  @ignore
  TimeOfDay? get timeStart =>
      timeStartMinutes == null
          ? null
          : TimeOfDay(
            hour: timeStartMinutes! ~/ 60,
            minute: timeStartMinutes! % 60,
          );

  set timeStart(TimeOfDay? value) {
    timeStartMinutes = value == null ? null : value.hour * 60 + value.minute;
  }

  @ignore
  TimeOfDay? get timeEnd =>
      timeEndMinutes == null
          ? null
          : TimeOfDay(
            hour: timeEndMinutes! ~/ 60,
            minute: timeEndMinutes! % 60,
          );

  set timeEnd(TimeOfDay? value) {
    timeEndMinutes = value == null ? null : value.hour * 60 + value.minute;
  }
}
