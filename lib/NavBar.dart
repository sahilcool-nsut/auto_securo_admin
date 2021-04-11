import 'package:auto_securo_admin/screens/camera_screen2.dart';
import 'package:auto_securo_admin/screens/login_screens/login_button_screen.dart';
import 'package:auto_securo_admin/screens/login_screens/login_screen.dart';
import 'package:auto_securo_admin/screens/navbar_screens/link_vehicle.dart';
import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:auto_securo_admin/globals.dart' as globals;

import 'screens/navbar_screens/QRScanner.dart';
import 'screens/home_page.dart';

class NavBar extends StatefulWidget {
  final int currentPage;

  NavBar({this.currentPage});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  // int getCurrentPage(){
  //   if(widget.currentPage == null){
  //     return 1;
  //   }
  //   else{
  //     return widget.currentPage;
  //   }
  // }
  int currentPageLocal;

  GlobalKey bottomNavigationKey = GlobalKey();
  @override
  void initState() {
    currentPageLocal = widget.currentPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: _getPage(currentPageLocal),
        ),
      ),
      bottomNavigationBar: FancyBottomNavigation(
        circleColor: Colors.red,
        inactiveIconColor: Colors.red,
        tabs: [
          TabData(
            iconData: Icons.qr_code_scanner,
            title: "QR Scanner",
            // onclick: () => Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => ScannerScreen(),
            //   ),
            // ),
          ),
          TabData(iconData: Icons.camera_enhance, title: 'Custom'),
          TabData(
            iconData: Icons.home,
            title: "Home",
            // onclick: () {
            //   final FancyBottomNavigationState fState = bottomNavigationKey
            //       .currentState as FancyBottomNavigationState;
            //   fState.setPage(2);
            // },
          ),
          TabData(iconData: Icons.car_rental, title: "Link Vehicle")
        ],
        initialSelection: currentPageLocal,
        key: bottomNavigationKey,
        onTabChangedListener: (position) {
          setState(() {
            currentPageLocal = position;
          });
        },
      ),
    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return QRScanner();
      case 1:
        return CameraScreen2();
      case 2:
        return HomePage();
      default:
        return globals.user == null ? LoginButton() : LinkVehicle();
    }
  }
}
