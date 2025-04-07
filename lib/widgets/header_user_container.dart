import 'package:flow_control/provider/user_provider.dart';
import 'package:flow_control/utils/form_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeaderUserContainer extends StatelessWidget {
  const HeaderUserContainer({super.key});

  // Card de informacion de usuario desde Provider
  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<UserProvider>(context);
    final user = employeeProvider.user;

    if (user == null) {
      return const SizedBox();
    }

    final imageUrl =  'https://cdn.pixabay.com/photo/2017/03/27/13/28/man-2178721_1280.jpg'; //user.image ?? 'https://cdn.pixabay.com/photo/2017/03/27/13/28/man-2178721_1280.jpg'; // imagen generica

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(500), 
          child: SizedBox(
            height: 50,
            width: 50,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10), // Espacio entre imagen y texto
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bienvenido", 
              style: FormStyles.getTextStyleTitle(font: 16, color: Colors.black),
            ),
            Text(
              user.userName, 
              style: FormStyles.getTextStyleTitle(font: 16, color: Colors.grey),
            ),
          ],
        )
      ],
    );
  }
}