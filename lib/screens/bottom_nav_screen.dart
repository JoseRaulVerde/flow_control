import 'package:flow_control/modals/alert_message.dart';
import 'package:flow_control/provider/product_provider.dart';
import 'package:flow_control/screens/settings_screen.dart';
import 'package:flow_control/screens/home_screen.dart';
import 'package:flow_control/screens/work_screen.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';

class BottomNavScreen extends StatefulWidget {
  final int initialIndex;

  const BottomNavScreen({super.key, this.initialIndex = 0});

  @override
  BottomNavScreenState createState() => BottomNavScreenState();
}

class BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;
  final log = Logger();

  final List<Map<String, dynamic>> _screens = [
    {"screen": HomeScreen(), "title": "Dashboard"},
    {"screen": WorkScreen(), "title": "Control de trabajo"},
    {"screen": SettingsScreen(), "title": "Configuracion"},
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }
  


  @override
  Widget build(BuildContext context) {
  final runningEvent = Provider.of<ProductsProvider>(context, listen: false);

  void onItemTapped(int index) {
    setState(() {
      if (!runningEvent.isEventRunning){
        _selectedIndex = index;
      }else{
        showAlertModal(context, "Necesitas terminar el proceso");
      }
    });
  }
  return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          showAlertModal(context, "Necesitas cerrar sesion (Cambio de operario)");
        }
      },
      child: Scaffold(
        body: _screens[_selectedIndex]["screen"],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.format_list_bulleted_outlined), label: 'Trabajos'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Configuracion'),
          ],
        ),
      ),
    );
  }
}