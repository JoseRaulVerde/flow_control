import 'package:flow_control/modals/logout_modal.dart';
import 'package:flow_control/models/actions_list.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flow_control/utils/form_styles.dart';

class ActionsContainer extends StatefulWidget {
  final List<ActionList> actions;
  final Function(int) onActionPressed;
  final Function() logout;

  const ActionsContainer({
    super.key,
    required this.actions,
    required this.onActionPressed,
    required this.logout,
  });

  @override
  State<ActionsContainer> createState() => _ActionsContainerState();
}

class _ActionsContainerState extends State<ActionsContainer> {
  final Logger log = Logger();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Acciones rápidas",
              style: FormStyles.getTextStyle(font: 16, color: Colors.blue),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            child: Column(
              children: List.generate(widget.actions.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 16,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: ElevatedButton(
                        onPressed:() {
                                    widget.onActionPressed(index);
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              widget.actions[index].isRunning
                                  ? Colors.blueAccent
                                  : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(width: 1, color: Colors.black12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(),
                            Text(
                              widget.actions[index].name,
                              style: FormStyles.getTextStyleTitle(
                                font: 18,
                                color:Colors.black
                              ),
                            ),
                            widget.actions[index].isRunning
                                ? const Icon(
                                  Icons.stop_circle,
                                  color: Colors.redAccent,
                                )
                                : const Icon(
                                  Icons.play_arrow,
                                  color: Colors.black,
                                ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: Colors.blueAccent, width: 1),
                ),
                child: Text(
                  'Cambio de operario',
                  style: FormStyles.getTextStyleTitle(
                    font: 18,
                    color: Colors.blueAccent,
                  ),
                ),
                onPressed: () async {
                  final logout = await showBackDialog(context);
                  if (logout == true) {
                    widget.logout();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
