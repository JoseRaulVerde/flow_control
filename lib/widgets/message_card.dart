import 'package:flutter/material.dart';


class MessageCard extends StatelessWidget {
  final String message;
  final bool isError;
  final Icon iconMessage;

  const MessageCard({
    super.key, 
    required this.message, 
    required this.iconMessage, 
    required this.isError
    });

  @override
  Widget build(BuildContext context) {
    
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message, 
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, 
                  color: isError ?Colors.redAccent[100] : Colors.black 
                ),
              ),
              SizedBox(height: 15,),
              Center(child: iconMessage),
              SizedBox(height: 15,)
            ]
          ),
        ),
      ),
      );
  }
}