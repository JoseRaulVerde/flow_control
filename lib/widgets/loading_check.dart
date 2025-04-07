import 'package:flutter/material.dart';

class LoadingCheck extends StatelessWidget {
  final String message;
  final Icon icon;
  final bool loading;
  final VoidCallback? checkButton;

  const LoadingCheck({
    super.key,
    required this.message,
    required this.icon,
    required this.loading,
    this.checkButton, 
  });

  // Widget de loading
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon, 
        const SizedBox(height: 20),
        Text(
          message,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        !loading
            ? ElevatedButton(
                onPressed: checkButton,
                child: const Text('Volver a intentar'),
              )
            : const CircularProgressIndicator(color: Colors.blue,),
      ],
    );
  }
}