import 'package:flow_control/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    if (user == null) {
      return const Center(child: Text('No hay usuario cargado.'));
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              if (user.image != null)
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2017/03/27/13/28/man-2178721_1280.jpg'),
                ),
              const SizedBox(height: 16),
              Text('ID: ${user.id}'),
              Text('Username: ${user.userName}'),
              Text('Nombre: ${user.name}'),
              Text('Apellido: ${user.lastName}'),
              Text('Email: ${user.email}'),
            ],
          ),
        ),
      )
    );
  }
}