import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List item navbar untuk memudahkan penggunaan
    final List<Map<String, dynamic>> navItems = [
      {'icon': Icons.home, 'label': 'Home'},
      {'icon': Icons.location_on, 'label': 'Facility'},
      {'icon': Icons.history, 'label': 'History'},
      {'icon': Icons.person, 'label': 'Profile'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (index) {
          final bool isSelected = currentIndex == index;

          return GestureDetector(
            onTap: () => onTap(index),
            child: Container(
              height: 50,
              constraints: BoxConstraints(minWidth: isSelected ? 120 : 60),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? const Color.fromARGB(255, 209, 250, 229)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment:
                    isSelected
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                children: [
                  SizedBox(width: isSelected ? 16 : 0),
                  Icon(
                    navItems[index]['icon'],
                    color:
                        isSelected
                            ? const Color.fromARGB(255, 20, 184, 166)
                            : Colors.grey,
                    size: 30,
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    Text(
                      navItems[index]['label'],
                      style: const TextStyle(
                        color: Color.fromARGB(255, 20, 184, 166),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
