import 'package:flow_control/hooks/use_products_actions.dart';
import 'package:flow_control/modals/alert_message.dart';
import 'package:flow_control/models/product.dart';
import 'package:flow_control/provider/product_provider.dart';
import 'package:flow_control/services/provider/products_actions_service.dart';
import 'package:flow_control/utils/form_styles.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class CardWorkUnits extends StatefulWidget {
  const CardWorkUnits({super.key});

  @override
  State<CardWorkUnits> createState() => _CardWorkUnitsState();
}



class _CardWorkUnitsState extends State<CardWorkUnits> {
  final log = Logger();
  String? _errorMessage;
  Map<int, TextEditingController> controllers = {};
  late ProductsActionsService actionsProductProvider;
  late ProductsProvider productsProvider;
  bool confirmProduct = false; 

  _showMessageWarning(){
    if(_errorMessage != null){
    showAlertModal(context, _errorMessage!);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    actionsProductProvider = useProductsActions(context);
    productsProvider = Provider.of<ProductsProvider>(context, listen: true);
  }
  @override
  void initState() {
  super.initState();
  productsProvider = Provider.of<ProductsProvider>(context, listen: false);
}

  // Widget de muestra lista de componentes y fases a seleccionar
  @override
  Widget build(BuildContext context) {

    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Column(
        spacing: 10,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text("unidades Trabajadas", style: FormStyles.getTextStyleTitle(font: 24, color: Colors.black),)
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: productsProvider.history.length,
              itemBuilder: (context, index) {
                for (int i = 0; i < productsProvider.history.length; i++) {
                  if (!controllers.containsKey(i)) {
                    final restValue = int.tryParse(productsProvider.history[i].rest) ?? 0;
                    controllers[i] = TextEditingController(text: restValue.toString());
                  }
                }
                return _productCard(productsProvider.history[index], index);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(CustomColors().blueButton)
                ),
                onPressed: (){
                  // Eliminar productos del historial
                  actionsProductProvider.deleteProductsConfirmed();
                  Navigator.pop(
                      context,
                    );
                }, 
                child: Text("Confirmar cantidades", style: FormStyles.getTextStyleTitle(font: 16, color: Colors.white),), ),
            ),
          )
        ],
      ),
    );
  }

  Widget _productCard(Product product, int index) {
  return Card(
    elevation: 0,
    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
    child: Container(
      decoration: FormStyles.boxProductsCardBottonContainer(isConfirmed: product.confirmed),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Container(
            decoration:FormStyles.boxProductsCardHeaderContainer(isConfirmed: product.confirmed),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('NF: ', style: TextStyle(
                      fontSize: 15, 
                      fontWeight: FontWeight.bold, 
                      color: product.confirmed? Colors.black54 :Colors.blueGrey
                      )
                    ),
                    Text(product.fabricationNote, style: TextStyle(
                      fontSize: 15, 
                      fontWeight: FontWeight.bold, 
                      color: product.confirmed? Colors.white70 : Colors.black
                      )
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Modelo: ', style: TextStyle(
                      fontSize: 15, 
                      fontWeight: FontWeight.bold, 
                      color: product.confirmed? Colors.black54 :Colors.blueGrey
                      )
                    ),
                    Text(product.name, style: TextStyle(
                      fontSize: 15, 
                      fontWeight: FontWeight.bold, 
                      color: product.confirmed? Colors.white70 : Colors.black
                      )
                    ),
                    Text(' | ${product.type}', style: TextStyle(
                      fontSize: 14, 
                      color:  product.confirmed? Colors.white70 : Colors.black
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),
  
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _sizeColumn("Terminados", int.parse(product.currentAmount), index: index),
                _sizeColumn("Faltantes", int.parse(product.rest), index: index),
                _sizeColumn("Generados", int.parse(product.rest), index: index, isInput: true),
                _sizeColumn("Total", int.parse(product.total), index: index, isBold: true),
                Container(
                  height: 35,
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      width: 2, 
                      color:   product.confirmed? Colors.transparent : CustomColors().blueButton.withAlpha(128), 
                    ),
                  ),
                  child: product.confirmed?  
                  Icon(Icons.check, color: CustomColors().blueConfirmContainerHeader, size: 30,)
                  : TextButton(
                    onPressed: (){
                      //send data to database
                      actionsProductProvider.confirmedProductHander(index);
                    },
                    child: Text(
                      "Confirmar",
                      style: FormStyles.getTextStyle(
                        font: 13, 
                        color: CustomColors().blueButton.withAlpha(128),
                      ),
                    ),
                  ),
                ),
                Divider()
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
  // Widget auxiliar para cada talla y cantidad
  Widget _sizeColumn(String data, int amount, {bool isBold = false, bool isInput = false, int index = 0}) {
      if (!controllers.containsKey(index)) {
    controllers[index] = TextEditingController(text: amount.toString());
  }

  void generateValueHandle (int index, String amount){
      actionsProductProvider.addProductGenerated(index, amount);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            data,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          Container(
          width: 40, 
          height: 2, 
          decoration: BoxDecoration(
            color:CustomColors().blueButton.withAlpha(128), 
            borderRadius: BorderRadius.circular(4), 
          ),
        ),
        isInput ?
          SizedBox(
            width: 40,
            height: 20, 
            child: TextFormField(
              controller: isInput ? controllers[index] : null,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                ),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                int? newValue = int.tryParse(value);
                if (newValue != null) {
                  if (newValue > amount) {
                    setState(() {
                      controllers[index]!.text = amount.toString();
                      controllers[index]!.selection = TextSelection.fromPosition(
                        TextPosition(offset: controllers[index]!.text.length),
                      );
                      //generar accion para guardar el valor
                      generateValueHandle(index, amount.toString());
                    _errorMessage = "Los productos generados no pueden exceder los faltantes";
                    });
                    _showMessageWarning();
                  } else {
                    setState(() {
                      _errorMessage = null;
                    });
                    generateValueHandle(index, value);
                  }
                }
              }
            ),
          )
          : Text(
            amount.toString(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }


}
