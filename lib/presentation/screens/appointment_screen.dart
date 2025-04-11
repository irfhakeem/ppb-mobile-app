import 'package:medlink/data/repositories/appointment_repository.dart';
import 'package:flutter/material.dart';
import 'package:medlink/presentation/widgets/myAppbar.dart';
import 'package:medlink/presentation/widgets/myAppointmentCard.dart';
import 'package:medlink/presentation/widgets/myAppointmentSheet.dart';
import 'package:medlink/presentation/widgets/mySearchBar.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  List<Map<String, dynamic>> appointments = [];

  // Fetch appointments from Isar database
  AppointmentRepository appointmentRepository = AppointmentRepository();

  @override
  void initState() {
    super.initState();
    _getAppointments();
  }

  Future<void> _getAppointments() async {
    final fetchedAppointments = await appointmentRepository.getAppointments();
    setState(() {
      appointments.clear();
      appointments.addAll(
        fetchedAppointments.map(
          (appointment) => {
            'id': appointment.id,
            'title': appointment.title,
            'date': appointment.dateTime,
            'timeStart': appointment.timeStart,
            'timeEnd': appointment.timeEnd,
            'location': appointment.location,
            'facility': appointment.facility,
            'doctor': appointment.doctor,
            'status': appointment.status,
          },
        ),
      );
    });
  }

  final TextEditingController _searchController = TextEditingController();

  void _showAppointmentSheet({
    Map<String, dynamic>? appointment,
    bool isViewOnly = false,
  }) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => MyAppointmentSheet(
            appointment: appointment,
            isViewOnly: isViewOnly,
          ),
    );

    // Handle hasil return dari appointment sheet context
    if (result != null) {
      setState(() {
        if (result.containsKey('action') && result['action'] == 'delete') {
          if (result.containsKey('id')) {
            _deleteAppointment(result['id']);
          }
        } else if (appointment != null) {
          _updateAppointment(appointment['id'], result);
        } else {
          appointments.add(result);
        }
      });
    }
  }

  void _deleteAppointment(int id) {
    setState(() {
      appointments.removeWhere((item) => item['id'] == id);
    });
  }

  void _updateAppointment(int id, Map<String, dynamic> updatedAppointment) {
    final index = appointments.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      setState(() {
        appointments[index] = updatedAppointment;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75.0),
        child: MyAppBar(title: 'Appointments', isFirstPage: true),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: MySearchBar(
                    controller: _searchController,
                    onChanged: (value) {
                      print('Search: $value');
                    },
                  ),
                ),

                SizedBox(width: 10),

                TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.filter_alt_outlined,
                        color: Colors.grey.shade600,
                      ),
                      Text(
                        'Filter',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 15),

            Expanded(
              child:
                  appointments.isEmpty
                      ? const Center(
                        child: Text(
                          "No Appointments Found",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                      : SingleChildScrollView(
                        child: Column(
                          children:
                              appointments
                                  .map(
                                    (appointment) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: MyAppointmentCard(
                                        id: appointment['id'],
                                        title:
                                            appointment['title'] ?? 'No Title',
                                        dateTime:
                                            appointment['date'] ??
                                            DateTime.now(),
                                        timeStart:
                                            appointment['timeStart'] ??
                                            const TimeOfDay(hour: 0, minute: 0),
                                        timeEnd:
                                            appointment['timeEnd'] ??
                                            const TimeOfDay(hour: 0, minute: 0),
                                        location:
                                            appointment['location'] ??
                                            'Unknown Location',
                                        facility:
                                            appointment['facility'] ??
                                            'Unknown Facility',
                                        doctor:
                                            appointment['doctor'] ??
                                            'Unknown Doctor',
                                        status:
                                            appointment['status'] ?? 'Pending',
                                        onDelete: (id) {
                                          _deleteAppointment(id);
                                        },
                                        onUpdate: (id, updatedAppointment) {
                                          _updateAppointment(
                                            id,
                                            updatedAppointment,
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAppointmentSheet(isViewOnly: false),
        backgroundColor: const Color.fromARGB(255, 20, 184, 166),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
