import 'package:flow_control/provider/product_provider.dart';
import 'package:flow_control/provider/timer_provider.dart';
import 'package:flow_control/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsProvider()), // Agregar ProductsProvider
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TimerProvider()),
      ],
      child: MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter App',
      initialRoute: AppRoutes.login, //login debe de iniciar
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}