import 'package:flutter/material.dart';

class MyFacilityCard extends StatelessWidget {
  final String facilityName;
  final String facilityAddress;
  final String facilityContact;
  final String facilityType;
  final String facilityImage;

  MyFacilityCard({
    required this.facilityName,
    required this.facilityAddress,
    required this.facilityContact,
    required this.facilityType,
    required this.facilityImage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.asset(facilityImage),
          ListTile(title: Text(facilityName), subtitle: Text(facilityAddress)),
          ListTile(title: Text(facilityContact), subtitle: Text(facilityType)),
        ],
      ),
    );
  }
}
