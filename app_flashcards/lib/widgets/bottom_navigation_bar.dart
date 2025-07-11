import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color.fromARGB(255, 126, 49, 115),
      selectedItemColor: Colors.white,
      currentIndex: currentIndex,
      onTap: (idx) {
          onTap(idx);
      },
      showUnselectedLabels: false,
      showSelectedLabels: false,
      items: const [
        BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home, size: 28)),
        BottomNavigationBarItem(label: 'Account', icon: Icon(Icons.settings, size: 28)),
      ],
    );
  }
}