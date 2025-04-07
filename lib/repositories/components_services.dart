import 'dart:convert';
import 'package:flow_control/models/work_component.dart';
import 'package:http/http.dart' as http;


class ComponentsServices {

 Future<List<WorkComponent>> getComponents() async{
  try {
    // final url  = Uri.parse('Obtencion de datos'); // url para obtencion de datos

    //  final response = await http.get(url);
    
    // if (response.statusCode == 200) {
    //   final body = jsonDecode(response.body);
    //   if (body.containsKey("data")) {
    //     return componentsList; //body["data"];
    //   } else {
    //     throw Exception("La respuesta de la API no contiene datos válidos");
    //   }
    // } else if (response.statusCode == 401){
    //   throw (
    //       "Error de autenticacion. por favor inicie sesion nuevamente");
    // }else if(response.statusCode == 500){
    //   throw ('Hubo un error en el servidor');
    // }
    //   throw ('Hubo un problema. Intentelo mas tarde');
        return componentsList; //body["data"];
  } catch (e) {
    rethrow;
    } 
  }

   Future<List<String>> getProductPhases() async{
    try {
      return componentTitles;
    } catch (e) {
      rethrow;
    }
   }

  List<WorkComponent> componentsList = [
  WorkComponent(
    code: "DTG",
    title: "GC IMPRESION DTG \$32",
    subtitle: "DS00000010624 / FRENTE DTG",
    category: "DTG",
  ),
  WorkComponent(
    code: "EST",
    title: "GC ETIQUETA TALLA EST",
    subtitle: "DS0000000249 / ETIQ INT",
    category: "EST",
  ),
  WorkComponent(
    code: "BORD",
    title: "GC BORDADO 5,000 P.",
    subtitle: "DS0000001079 / MANGA IZO BORD",
    category: "BORD",
  ),
  WorkComponent(
    code: "CED",
    title: "PLAY C / RED JUV -00000",
    subtitle: "M00151-00DDD / M01",
    category: "CED",
  ),
];

List<String> componentTitles = [
  "M-GC-CD RECEPCION Y ENVIO",
  "M-GC-CD DESETIQUETADO",
  "M-GC-ES DOBLADO ESTAMPADO",
  "M-GC-ES TERMINADO ESTAMPADO",
  "M-GC-BO DIGITALIZADO",
];

List<String> listStopTitle = [
  "finalizado", 
  "Opción 2", 
  "Opción 3", 
  "Opción 4"
];

}