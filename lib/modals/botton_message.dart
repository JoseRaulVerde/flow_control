import 'package:flutter/material.dart';


void bottonMessage (BuildContext context, String message , {Color color = Colors.orange}){
   ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          duration: Durations.long4,
        ),
      );
}