import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key, required this.title, required this.isFirstPage})
    : super(key: key);

  final String title;
  final bool isFirstPage;

  @override
  Widget build(BuildContext context) {
    final Map<bool, List<dynamic>> iconData = {
      true: [Icons.help_outline, () => Navigator.pushNamed(context, '/help')],
      false: [Icons.arrow_back, () => Navigator.pop(context)],
    };

    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: Color.fromARGB(255, 8, 51, 68),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      toolbarHeight: 70,

      leading: IconButton(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        icon: Icon(iconData[isFirstPage]![0] as IconData, size: 30),
        color: const Color.fromARGB(255, 8, 51, 68),
        onPressed: iconData[isFirstPage]![1] as VoidCallback,
      ),

      actions: [
        IconButton(
          padding: EdgeInsets.symmetric(horizontal: 20),
          icon: const Icon(Icons.notifications_outlined, size: 30),
          color: Color.fromARGB(255, 8, 51, 68),
          onPressed: () {},
        ),
      ],

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
