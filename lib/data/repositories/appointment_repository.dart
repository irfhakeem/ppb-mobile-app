import 'package:medlink/data/models/appointment.dart';
import 'package:medlink/helpers/config/db.dart';
import 'package:isar/isar.dart';

class AppointmentRepository {
  Future<List<Appointment>> getAppointments() async {
    final isar = await DB().db;
    return await isar.appointments.where().findAll();
  }

  Future<Appointment> createAppointment(Appointment appointment) async {
    final isar = await DB().db;
    await isar.writeTxn(() => isar.appointments.put(appointment));
    return appointment;
  }

  Future<Appointment> updateAppointment(Appointment appointment) async {
    final isar = await DB().db;
    await isar.writeTxn(() async {
      final existingAppointment = await isar.appointments.get(appointment.id);
      if (existingAppointment != null) {
        await isar.appointments.put(appointment);
      } else {
        throw Exception("Appointment id ${appointment.id} tidak ada");
      }
    });
    return appointment;
  }

  Future<void> deleteAppointment(int id) async {
    final isar = await DB().db;
    await isar.writeTxn(() => isar.appointments.delete(id));
  }
}
