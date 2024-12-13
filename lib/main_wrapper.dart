import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int selectedIndex = 0;

  void _goBranch(int index) {
    print('Navigating to branch $index');
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }


  @override
  Widget build(BuildContext context) {
    // Gunakan GoRouterState untuk mendapatkan lokasi
    final location = GoRouterState.of(context).uri.toString();

    // Memeriksa apakah lokasi saat ini adalah /welcomepage
    bool showBottomNav = location != '/welcomepage' && !location.startsWith('/welcomepage/');

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: widget.navigationShell,
      ),
      bottomNavigationBar: showBottomNav
          ? SlidingClippedNavBar(
        backgroundColor: Colors.white,
        onButtonPressed: (index) {
          setState(() {
            selectedIndex = index;
          });
          _goBranch(selectedIndex);
        },
        iconSize: 30,
        activeColor: Colors.black,
        selectedIndex: selectedIndex,
        barItems: [
          BarItem(
            icon: Icons.home,
            title: 'Home',
          ),
          BarItem(
            icon: Icons.groups,
            title: 'Bimbingan',
          ),
          BarItem(
            icon: Icons.note_alt,
            title: 'Menguji',
          ),
          BarItem(
            icon: Icons.person,
            title: 'Profile',
          ),
        ],
      )
          : null, // Jangan tampilkan bottom navigation di /welcomepage
    );
  }
}
