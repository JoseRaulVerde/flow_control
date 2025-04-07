
import 'package:flow_control/provider/timer_provider.dart';
import 'package:flow_control/services/provider/timer_actions_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

TimerActionsService useTimerActionServices(BuildContext context){
  final timerProvider = Provider.of<TimerProvider>(context, listen: false);
  return TimerActionsService(timerProvider);
}