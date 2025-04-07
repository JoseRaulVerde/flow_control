import 'package:flow_control/utils/form_styles.dart';
import 'package:flow_control/widgets/header_user_container.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  final log = Logger();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 33,
        title: Text('Dashboard',),
        centerTitle: true,
        actions: [Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Transform.rotate(
            angle: 4.7,
            child: Icon(Icons.tune,),
          )
        )],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderUserContainer(),
              const SizedBox(height: 10), 
              _staticInformation(),
              const SizedBox(height: 15),
              _resumeInfo(),
              const SizedBox(height: 15),
              _productivityContainer()
            ],
          ),
        ),
      ),
    );
  }
  /// Información estadística
  Widget _staticInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "Información estadística", 
            style: FormStyles.getTextStyleTitle(font: 15, color: Colors.black),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _customButton("Estación"),
            _customButton("Operador"),
            _customButton("Ambos"),
          ],
        )
      ],
    );
  }

  /// Botón reutilizable
  Widget _customButton(String label) {
    return TextButton(
      style: FormStyles.genericBackgroundStyle(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        size: const Size(110, 30),
      ),
      onPressed: () {},
      child: Text(
        label,
        style: FormStyles.getTextStyleTitle(font: 12, color: Colors.black),
      ),
    );
  }

  /// Resumen de información
  Widget _resumeInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "Resumen",
            style: FormStyles.getTextStyleTitle(font: 20, color: Colors.blue),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribuye las tarjetas de manera uniforme
          children: [
          Expanded(child: _cardInfo("Total", "24h")), //envio de datos
          SizedBox(height: 10,),
          Expanded(child: _cardInfo("Hoy", "2h")) //envio de datos
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: _cardInfo("Esta semana", "4h")
        )
      ],
    );
  }

  /// Tarjeta de información
  Widget _cardInfo(String title, String data) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        height: 120, // Ajustado para evitar overflow
        padding: const EdgeInsets.all(12), 
        decoration: FormStyles.boxBackgroundStyle(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              Text(
                title,
                style: FormStyles.getTextStyleTitle(font: 18, color: Colors.black),
              ),
              const SizedBox(height: 5), // Espacio entre textos
              Text(
                data,
                style: FormStyles.getTextStyleTitle(font: 22, color: Colors.black),
                softWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Tarjeta de productividad
  Widget _productivityContainer(){
    return Column(
      children: [
        _customList("Puroductividad", 5.2, "CurrentValue"),
        _customList("Pausas", 4.6, "Value Description"),
        _customList("Maquina", 9.3, "Value Description"),
      ],
    );
  }

  // Contenedor de informacion para Productividad
  Widget _customList(String titleList, double average, String value){
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(titleList, style: FormStyles.getTextStyleTitle(font: 15, color: Colors.black),)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$average%", style: FormStyles.getTextStyleSubitle(font: 14, color: const Color.fromARGB(255, 116, 113, 113)),),
                Text(value, style: FormStyles.getTextStyleSubitle(font: 14, color: Colors.black),)
              ],
            )
          ],
        ),
      ),
    ); 
    }
}