# Assignment 2 - Muhammad Irfan Hakim (5025221291)

Berikut adalah branch untuk pekerjaan assigment 2 dengan tugas untuk mengimplementasikan Isar DB sebagai local db dari flutter project yang dibuat.

## Implementasi

### 1. Install Isar DB

**Install Isar DB** menggunakan command di bawah ini

```sh
flutter pub add isar isar_flutter_libs path_provider
flutter pub add -d isar_generator build_runner
```

### 2. Membuat Model dan Build Model

Membuat model **Appointment** untuk Isar DB pada `/lib/data/models/appointment.dart`

```dart
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
```

Kemudian, **Build Model** menggunakan command di bawah agar model tersedia di Isar DB

```
flutter pub run build_runner build
```

### 3. Inisialisasi DB dan Membuat Appointment Repository

Inisialisai Isar DB dapat dilihat pada `/lib/helpers/config/db.dart`

```dart
class DB {
  static final DB _instance = DB._internal();
  factory DB() => _instance;

  late Future<Isar> db;

  DB._internal() {
    db = _openDB();
  }

  Future<Isar> _openDB() async {
    final dir = await getApplicationDocumentsDirectory();

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([
        AppointmentSchema,
        UserSchema,
      ], directory: dir.path);
    }

    return Future.value(Isar.getInstance());
  }
}

```

dan untuk kebutuhan operasi CRUD, method ditulis pada `/lib/data/repositories/appointment_repository.dart`

```dart
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
```

### 4. Buka Database Isar di Web Browser

Untuk membuka databse Isar di Web Browser nantinya ketika menjalankan `flutter run` maka akan diberi link dari isar dev untuk melihat database yang tersambung dengan project.

![Image](https://github.com/user-attachments/assets/894d99e8-7861-4bb5-b8e5-ba9779ca3b1e)

## Demo

[Video Demo Aplikasi](https://youtu.be/a6uP69VhsJk)

## Referensi

[Dokumentasi Isar](https://isar.dev/tutorials/quickstart.html)

[Tutorial Youtube](https://www.youtube.com/watch?v=NuSb0wq9K-I&t=368s)
