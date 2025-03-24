import 'package:flutter/material.dart';
import 'package:Medlink/components/myAppbar.dart';
import 'package:Medlink/components/myAppointmentCard.dart';
import 'package:Medlink/components/myAppointmentSheet.dart';
import 'package:Medlink/components/mySearchBar.dart';

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  List<Map<String, dynamic>> appointments = [
    {
      'id': 1,
      'title': 'Dental Checkup',
      'timeStart': const TimeOfDay(hour: 10, minute: 0),
      'timeEnd': const TimeOfDay(hour: 11, minute: 0),
      'date': DateTime(2025, 3, 23),
      'facility': 'Dental Clinic',
      'location': 'Jakarta',
      'doctor': 'Dr. John Doe',
      'status': 'Confirmed',
    },
  ];

  final TextEditingController _searchController = TextEditingController();

  // Unified method for showing appointment sheet
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

    if (result != null) {
      setState(() {
        if (result.containsKey('action') && result['action'] == 'delete') {
          // Handle deletion
          if (result.containsKey('id')) {
            _deleteAppointment(result['id']);
          }
        } else if (appointment != null) {
          // Handle update
          final index = appointments.indexWhere(
            (item) => item['id'] == appointment['id'],
          );
          if (index != -1) {
            appointments[index] = result;
          }
        } else {
          // Handle new appointment
          result['id'] = DateTime.now().millisecondsSinceEpoch;
          appointments.add(result);
        }
      });
    }
  }

  void _deleteAppointment(int id) {
    setState(() {
      // Try both removal methods to ensure it works
      appointments.removeWhere((item) => item['id'] == id);

      // Double check if it was removed
      if (appointments.any((item) => item['id'] == id)) {
        appointments = appointments.where((item) => item['id'] != id).toList();
      }
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
                                        id:
                                            appointment['id'] is int
                                                ? appointment['id']
                                                : int.parse(
                                                  appointment['id'].toString(),
                                                ),
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
                                        onUpdate: _updateAppointment,
                                        onDelete: _deleteAppointment,
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
        child: const Icon(Icons.add, color: Colors.white, size: 30),
        backgroundColor: const Color.fromARGB(255, 20, 184, 166),
      ),
    );
  }
}
