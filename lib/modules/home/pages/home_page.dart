import 'package:flutter/material.dart';

import '../../../components/icon/icon.dart';
import '../../../core/constant/app_colors.dart';
import '../../asset/pages/asset_content.dart';
import '../../profile/pages/profile_page.dart';
import '../../scanner/pages/scanner_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> contents = <Widget>[
    const SafeArea(
      child: Text(
        'Index 1: Home',
        style: optionStyle,
      ),
    ),
    const AssetContent(),
    const ScannerPage(),
    const Text(
      'Index 4: Transaction',
      style: optionStyle,
    ),
    ProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: contents.elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(AppIcon.homeFilled()),
          ),
          BottomNavigationBarItem(
            label: "Assets",
            icon: Icon(AppIcon.box()),
          ),
          BottomNavigationBarItem(
            label: "Scan",
            icon: Icon(AppIcon.qr()),
          ),
          BottomNavigationBarItem(
            label: "Transaction",
            icon: Icon(AppIcon.transaction()),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(AppIcon.profile()),
          ),
        ],
        backgroundColor: AppColor.white,
        currentIndex: selectedIndex,
        selectedItemColor: AppColor.blue0A1A48,
        unselectedItemColor: AppColor.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
