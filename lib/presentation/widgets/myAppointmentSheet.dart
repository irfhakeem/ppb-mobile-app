import 'package:flutter/material.dart';
import 'package:medlink/data/models/appointment.dart';
import 'package:medlink/data/repositories/appointment_repository.dart';

class MyAppointmentSheet extends StatefulWidget {
  final Map<String, dynamic>? appointment;
  final bool isViewOnly;

  const MyAppointmentSheet({
    super.key,
    this.appointment,
    this.isViewOnly = false,
  });

  @override
  _MyAppointmentSheetState createState() => _MyAppointmentSheetState();
}

class _MyAppointmentSheetState extends State<MyAppointmentSheet> {
  final _formKey = GlobalKey<FormState>();
  final repository = AppointmentRepository();
  late bool _isEditing;

  late TextEditingController _titleController;
  late TextEditingController _locationController;
  late TextEditingController _facilityController;
  late TextEditingController _doctorController;

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: 0);
  String _status = "Pending";

  @override
  void initState() {
    super.initState();
    _isEditing = !widget.isViewOnly;

    _titleController = TextEditingController(
      text: widget.appointment?['title'] ?? "",
    );
    _locationController = TextEditingController(
      text: widget.appointment?['location'] ?? "",
    );
    _facilityController = TextEditingController(
      text: widget.appointment?['facility'] ?? "",
    );
    _doctorController = TextEditingController(
      text: widget.appointment?['doctor'] ?? "",
    );

    if (widget.appointment != null) {
      _selectedDate = widget.appointment!['date'];
      _startTime = widget.appointment!['timeStart'];
      _endTime = widget.appointment!['timeEnd'];
      _status = widget.appointment!['status'];
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime(BuildContext context, bool isStartTime) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _saveAppointment() async {
    if (_formKey.currentState!.validate()) {
      final appointment =
          Appointment(
              _titleController.text,
              _selectedDate,
              _locationController.text,
              _facilityController.text,
              _doctorController.text,
              _status,
            )
            ..timeStart = _startTime
            ..timeEnd = _endTime;

      Appointment newAppointment;

      if (widget.appointment != null) {
        appointment.id = widget.appointment!['id'];
        newAppointment = await repository.updateAppointment(appointment);
      } else {
        newAppointment = await repository.createAppointment(appointment);
      }

      if (!mounted) return;

      // Tutup dialog
      Navigator.of(context).pop({
        'id': newAppointment.id,
        'title': _titleController.text,
        'date': _selectedDate,
        'timeStart': _startTime,
        'timeEnd': _endTime,
        'location': _locationController.text,
        'facility': _facilityController.text,
        'doctor': _doctorController.text,
        'status': _status,
      });
    }
  }

  void _deleteAppointment() async {
    if (widget.appointment != null) {
      await repository.deleteAppointment(widget.appointment!['id']);
    }

    if (!mounted) return;

    // Tutup dialog
    Navigator.of(context).pop();

    // Tutup sheet dengan return data
    Navigator.of(
      context,
    ).pop({'id': widget.appointment!['id'], 'action': 'delete'});
  }

  @override
  Widget build(BuildContext context) {
    final double sheetHeight = MediaQuery.of(context).size.height * 0.75;

    return Container(
      height: sheetHeight,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add a drag handle at the top for better UX
          Center(
            child: Container(
              width: 50,
              height: 5,
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Center(
            child: Text(
              widget.appointment == null
                  ? "New Appointment"
                  : (_isEditing ? "Edit Appointment" : "Appointment Details"),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      readOnly: !_isEditing,
                      decoration: const InputDecoration(labelText: "Title"),
                      validator:
                          (value) =>
                              value!.isEmpty ? "Please enter title" : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _locationController,
                      readOnly: !_isEditing,
                      decoration: const InputDecoration(labelText: "Location"),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _facilityController,
                      readOnly: !_isEditing,
                      decoration: const InputDecoration(labelText: "Facility"),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _doctorController,
                      readOnly: !_isEditing,
                      decoration: const InputDecoration(labelText: "Doctor"),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Date: ${_selectedDate.toLocal()}".split(' ')[0],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        if (_isEditing)
                          TextButton(
                            onPressed: () => _pickDate(context),
                            child: const Text("Pick Date"),
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Start: ${_startTime.format(context)}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            if (_isEditing)
                              TextButton(
                                onPressed: () => _pickTime(context, true),
                                child: const Text("Pick Start Time"),
                              ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "End: ${_endTime.format(context)}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            if (_isEditing)
                              TextButton(
                                onPressed: () => _pickTime(context, false),
                                child: const Text("Pick End Time"),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _status,
                      decoration: const InputDecoration(labelText: "Status"),
                      items:
                          ["Pending", "Confirmed", "Cancelled"].map((status) {
                            return DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            );
                          }).toList(),
                      onChanged:
                          _isEditing
                              ? (value) => setState(() => _status = value!)
                              : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (widget.isViewOnly && !_isEditing)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  child: const Text("Edit"),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Delete Appointment"),
                          content: const Text(
                            "Are you sure you want to delete this appointment?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: _deleteAppointment,
                              child: const Text("Delete"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Delete"),
                ),
              ],
            ),
          if (_isEditing)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: _saveAppointment,
                  child: const Text("Save"),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
