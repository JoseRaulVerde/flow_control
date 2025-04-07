import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flow_control/provider/user_provider.dart';
import 'package:flow_control/services/provider/user_actions_service.dart';

// hook de aplicacion de servicio de provider de user
UserActionsService useUserActions(BuildContext context) {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  return UserActionsService(userProvider);
}