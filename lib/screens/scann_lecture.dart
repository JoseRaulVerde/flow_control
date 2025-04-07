import 'dart:async';

import 'package:flow_control/hooks/use_products_actions.dart';
import 'package:flow_control/models/product.dart';
import 'package:flow_control/provider/product_provider.dart';
import 'package:flow_control/screens/work_list.dart';
import 'package:flow_control/utils/form_styles.dart';
import 'package:flow_control/widgets/loading_check.dart';
import 'package:flow_control/widgets/message_card.dart';
import 'package:flow_control/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';

class ScannLecture extends StatefulWidget {
  const ScannLecture({super.key});

  @override
  State<ScannLecture> createState() => _ScannLectureState();
}

class _ScannLectureState extends State<ScannLecture> {
  final log = Logger();
  bool  _isLoading= false;
  Timer? _timer;
  

void _scanCodeUser(String value) {
  final actionsProvider = Provider.of<ProductsProvider>(context, listen: false);
  final actionsService = useProductsActions(context); 

  setState(() {
    _isLoading = true;
  });

  _timer = Timer(Duration(seconds: 1), () {
    List<Product> newProducts;

    if (actionsProvider.history.isEmpty) {
      newProducts = actionsProvider.products1;
    } else if (actionsProvider.history.length == 1) { 
      newProducts = actionsProvider.products2;
    } else {
      newProducts = actionsProvider.products3;
    }

    for (var newProduct in newProducts) {
      if (!actionsProvider.history.any((existingProduct) => existingProduct.name == newProduct.name)) {
        actionsService.addToHistory(newProduct); //  Agregarlo a history en el provider
      }
    }

    setState(() {
      _isLoading = false;
    });

  });
}

void deleteProduct(int index) {
  final productService = useProductsActions(context);
  productService.deleteProduct(index); //  Elimina el producto usando el servicio
}

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(103, 157, 191, 196),
        title: Text("Lectura de nota de fabricacion", style: TextStyle( fontSize: 16, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.qr_code_scanner, color: Colors.blue),
                      filled: true,
                      fillColor: Color.fromARGB(103, 157, 191, 196),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      labelText: 'Código de barra',
                    ),
                    onSubmitted: (value) {
                      _scanCodeUser(value);
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Información de Nota de Fabricación",
                    style: FormStyles.getTextStyleTitle(font: 18, color: Colors.black),
                  ),

                  //  Usamos Consumer<ProductsProvider> para escuchar cambios en history
                  Consumer<ProductsProvider>(
                    builder: (context, actionsProvider, child) {
                      return _isLoading ?
                         Center(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20.0),
                              child: LoadingCheck(
                                message: "Cargando el producto",
                                icon: Icon(Icons.search),
                                loading: _isLoading,
                              ),
                            ),
                         )
                      : actionsProvider.history.isNotEmpty
                          ? ProductCard(
                              onDelete: (index) => deleteProduct(index),
                            )
                          : MessageCard(
                              message: "Escanea o agrega el código del producto",
                              iconMessage: Icon(
                                Icons.qr_code_scanner_outlined,
                                size: 30,
                                color: Colors.blueAccent,
                              ),
                              isError: false,
                            );
                    },
                  ),
                ],
              ),
            ),
          ),

          //  También corregimos el botón para usar actionsProvider.history
          Align(
            alignment: Alignment.bottomCenter,
            child: Consumer<ProductsProvider>(
              builder: (context, actionsProvider, child) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: actionsProvider.history.isNotEmpty
                        ? () async {
                            // Navegación a Seleccionar trabajo 
                             Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => WorkList(),)
                            );
                          }
                        : null,
                    child: Text(
                      'Seleccionar trabajo',
                      style: FormStyles.getTextStyleTitle(
                        font: 15,
                        color: actionsProvider.history.isNotEmpty ? Colors.white : Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
    );
  }
}