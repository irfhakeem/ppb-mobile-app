import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:medlink/data/models/appointment.dart';
import 'package:medlink/data/models/user.dart';

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
