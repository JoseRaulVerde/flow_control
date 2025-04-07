import 'package:flow_control/hooks/use_products_actions.dart';
import 'package:flow_control/hooks/use_timer_actions.dart';
import 'package:flow_control/hooks/use_user_actions.dart';
import 'package:flow_control/modals/botton_message.dart';
import 'package:flow_control/modals/modal_resume_products.dart';
import 'package:flow_control/models/actions_list.dart';
import 'package:flow_control/models/work_component.dart';
import 'package:flow_control/provider/product_provider.dart';
import 'package:flow_control/provider/timer_provider.dart';
import 'package:flow_control/repositories/components_services.dart';
import 'package:flow_control/screens/scann_lecture.dart';
import 'package:flow_control/services/provider/products_actions_service.dart';
import 'package:flow_control/services/provider/timer_actions_services.dart';
import 'package:flow_control/services/provider/user_actions_service.dart';
import 'package:flow_control/utils/form_styles.dart';
import 'package:flow_control/modals/modal_stop_reasons.dart';
import 'package:flow_control/widgets/header_user_container.dart';
import 'package:flow_control/widgets/timer.dart';
import 'package:flow_control/widgets/work_screen_actions.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';

class WorkScreen extends StatefulWidget {
  const WorkScreen({super.key});

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen>{
  late ProductsProvider componentProvider;
  late TimerProvider timerProvider;
  late TimerActionsService timerService;
  late UserActionsService userActions;
  late ProductsActionsService productActions;

  final log = Logger();
  List<ActionList> actions = [
    ActionList(name: "Producir"),
    ActionList(name: "Montar"),
    ActionList(name: "Desmontar"),
    ActionList(name: "Autorizar"),
  ];

  @override
  void initState() {
    super.initState();
    timerProvider = Provider.of<TimerProvider>(context, listen: false);
    timerService = useTimerActionServices(context);
    productActions = useProductsActions(context);
    userActions = useUserActions(context);
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    componentProvider = Provider.of<ProductsProvider>(context, listen: true);
  }

  void toggleAction(int index) async {
    final componentAction = useProductsActions(context);

    if (componentProvider.history.isNotEmpty) {

      final isAnotherRunning = actions.asMap().entries.any((entry) {
        return entry.key != index && entry.value.isRunning == true;
      });

      if (isAnotherRunning) {
        bottonMessage(context, "solo puedes tener una acción activa a la vez");
        return;
      }

      if (actions[index].isRunning) {
        // Si ya está corriendo esta acción, terminarla
        final result = await _openModalList(actions[index].name);
        componentAction.addLastEvent();
        timerService.reset();

        setState(() {
          actions[index].isRunning = false;
        });

        if (result != null) log.i(result);
      } else {
        // Iniciar la acción
        componentAction.addEvent(actions[index].name); //campo para agregar accion actual

        setState(() {
          for (var action in actions) {
            action.isRunning = false;
          }
          actions[index].isRunning = true;
          timerService.start();
        });
      }
    }else {
      bottonMessage(context, "No hay trabajos a realizar");
    }
  }
  
  /*
    Logica para limpiar todos los datos guardados 
    y en en el arbol de Widgets 
  */
  void handleLogout(){
    timerService.deleteTimer();
    productActions.clearHistory();
    userActions.logout();
  }

  Future<String?> _openModalList (String name) async{
    final result = await  showReasonsModalList(context, name, ComponentsServices().listStopTitle);
    if (result == ComponentsServices().listStopTitle[0]){
      if (mounted) showResultModal(context);
    }
    return result;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 32,
        automaticallyImplyLeading: false,
        title: const Text("Control de trabajo"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderUserContainer(),
                Column(
                  children: [
                    IconButton(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          onPressed: (){
                            if (componentProvider.isEventRunning){
                              bottonMessage(context, "Termina la ejecucion en proceso", color: Colors.redAccent);
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ScannLecture(),)
                            );
                          },
                          icon: Icon(Icons.drag_handle,),
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Colors.grey[200]),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8), 
                                side: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          )
                      ),
                      componentProvider.history.length == 1 ?
                      Text(componentProvider.history[0].fabricationNote, style: FormStyles.getTextStyleSubitle(font: 10, color: Colors.blue))
                      : componentProvider.history.length > 1 
                      ? Text("*", style: FormStyles.getTextStyleSubitle(font: 16, color: Colors.blue))
                      : SizedBox()
                  ],
                ),
              ],
            ),
            _terminalInfo("Bordado", "Bordadora 12C"),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Text(
                    "Trabajo confirmado",
                    style: FormStyles.getTextStyleSubitle(font: 16, color: Colors.black),
                  ),
                ),
                componentProvider.component != null ?
                _currentWork(componentProvider.component!)
                : SizedBox(),
              ],
            ),
            ActionsContainer(
              actions: actions,
              onActionPressed: toggleAction,
              logout: handleLogout
            ),
            _timerAndEvents(),
          ],
        ),
      ),
    );
  }

  //informacion de trabajo
  Widget _currentWork (WorkComponent component){
    
    return ListTile(
      minLeadingWidth: 10,
      dense: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: CircleAvatar(
        maxRadius: 15,
        backgroundColor: Colors.blueAccent,
        child: Text(component.code, style: FormStyles.getTextStyle(font: 8, color: Colors.white)),
      ),
      title: Text(component.title, style: FormStyles.getTextStyleTitle(font: 14, color: Colors.black)),
      subtitle: Text(component.subtitle, style: FormStyles.getTextStyleSubitle(font: 10, color: Colors.blueGrey)),
    );
  }

  // Informacion de terminal 
  Widget _terminalInfo(String area, String station) {
    final double textFont = 14;
    final TextStyle textStaticStyle = FormStyles.getTextStyleSubitle(font: textFont, color: Colors.black);
    final TextStyle textDataStyle = FormStyles.getTextStyle(font: textFont, color: Colors.blueGrey);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Información de terminal", style: FormStyles.getTextStyleTitle(font: 16, color: Colors.black)),
          const SizedBox(height: 5),
          Row(
            children: [
              Text("Área: ", style: textDataStyle),
              Text(area, style: textStaticStyle),
              Text(", Estación ", style: textDataStyle),
              Text(station, style: textStaticStyle),
            ],
          )
        ],
      ),
    );
  }

  // Últimos eventos
  Widget _timerAndEvents() {
    String lastEvent = '';
    String startEvent = '';
    String endEvent = '';

    if (componentProvider.events != null) {
      final events = componentProvider.events!.previousEvent;
      
      if (events!= null){

        if ( events.nameEvent.isNotEmpty) {
          lastEvent = events.nameEvent;
          startEvent = "${events.startEvent.hour}:${events.startEvent.minute.toString().padLeft(2, '0')}";

        }

        if (events.endEvent != null) {
        endEvent = "${events.endEvent!.hour}:${events.endEvent!.minute.toString().padLeft(2, '0')}";
      }
    }
    }

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Consumer<TimerProvider>(
            builder: (context, timerProvider, _) {
              return TimerWidget();
            },
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _eventLabel("Último Evento:", lastEvent, flex: 4),
              _eventLabel("Inicio:", startEvent),
              _eventLabel("Fin:", endEvent),
            ],
          ),
        Divider()
        ],
      ),
    );
  }

  Widget _eventLabel(String title, String? value, {int flex = 2}) {
    return Expanded(
      flex: flex,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: FormStyles.getTextStyle(font: 12, color: Colors.blueGrey),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Tooltip(
              message: value ?? '',
              child: Text(
                value ?? '',
                style: FormStyles.getTextStyle(font: 12, color: Colors.black),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}