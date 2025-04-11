import 'package:isar/isar.dart';
import 'package:medlink/presentation/widgets/myAppointmentSheet.dart';
import 'package:medlink/helpers/helpers.dart';
import 'package:flutter/material.dart';

class MyAppointmentCard extends StatefulWidget {
  const MyAppointmentCard({
    super.key,
    required this.id,
    required this.title,
    required this.timeStart,
    required this.timeEnd,
    required this.dateTime,
    required this.location,
    required this.facility,
    required this.doctor,
    required this.status,
    required this.onUpdate,
    required this.onDelete,
  });

  final Id id;
  final String title;
  final TimeOfDay timeStart;
  final TimeOfDay timeEnd;
  final DateTime dateTime;
  final String location;
  final String facility;
  final String doctor;
  final String status;
  final Function(int id, Map<String, dynamic> updatedAppointment) onUpdate;
  final Function(int id) onDelete;

  @override
  State<MyAppointmentCard> createState() => _MyAppointmentCardState();
}

class _MyAppointmentCardState extends State<MyAppointmentCard> {
  bool isSelected = false;

  void _showAppointmentSheet() {
    setState(() {
      isSelected = !isSelected;
    });

    showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return MyAppointmentSheet(
          appointment: {
            'id': widget.id,
            'title': widget.title,
            'timeStart': widget.timeStart,
            'timeEnd': widget.timeEnd,
            'date': widget.dateTime,
            'location': widget.location,
            'facility': widget.facility,
            'doctor': widget.doctor,
            'status': widget.status,
          },
          isViewOnly: true,
        );
      },
    ).then((updatedAppointment) {
      if (updatedAppointment != null) {
        if (updatedAppointment.containsKey('action') &&
            updatedAppointment['action'] == 'delete') {
          widget.onDelete(widget.id);
        } else {
          widget.onUpdate(widget.id, updatedAppointment);
        }
      }
      setState(() {
        isSelected = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> dateInfo = Helpers.formatDate(widget.dateTime);
    String day = dateInfo[0];
    String month = dateInfo[1];

    return GestureDetector(
      onTap: _showAppointmentSheet,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border:
              isSelected ? Border.all(color: Colors.grey, width: 1.5) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    day,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    month,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 20, 184, 166),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Container(width: 2, height: 90, color: Colors.grey.shade300),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          widget.status,
                          style: TextStyle(
                            color: switch (widget.status) {
                              "Confirmed" => Colors.green,
                              "Cancelled" => Colors.red,
                              "Pending" => Colors.orange,
                              "Rescheduled" => Colors.blue,
                              _ => Colors.grey,
                            },
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.grey.shade600,
                              size: 15,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              "${widget.timeStart.format(context)} - ${widget.timeEnd.format(context)}",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: Colors.grey.shade600,
                              size: 15,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              widget.location,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.facility,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    Text(
                      widget.doctor,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
