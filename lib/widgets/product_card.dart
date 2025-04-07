import 'package:flow_control/models/product.dart';
import 'package:flow_control/provider/product_provider.dart';
import 'package:flow_control/utils/form_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final Function(int) onDelete;
  const ProductCard({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child:
            productProvider.history.length == 1
                ? _oneProductCard(productProvider.history[0])
                : _multipleProductCard(productProvider.history),
      ),
    );
  }

  // Múltiples productos correctamente implementados
  Widget _multipleProductCard(List<Product> products) {
    return SizedBox(
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return _productMultipleCard(products[index], index);
        },
      ),
    );
  }

  // Card individual para cada producto dentro de `ListView`
  Widget _productMultipleCard(Product product, int index) {
    return Builder(
      builder: (context) {
        return Card(
          elevation: 1,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.blueGrey.shade200),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFEAF4FA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: FormStyles.boxProductsCardHeaderContainer(),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'NF: ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              Text(
                                product.fabricationNote,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Modelo: ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              Text(
                                product.name,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                ' | ${product.type}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => onDelete(index),
                        icon: Icon(
                          Icons.delete_outlined,
                          color: Colors.red[300],
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _sizeColumn("Terminados", "50"),
                      _sizeColumn("Faltantes", "90"),
                      _sizeColumn("Total", "320", isBold: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget auxiliar para cada talla y cantidad
  Widget _sizeColumn(String size, String amount, {bool isBold = false}) {
    return Column(
      children: [
        Text(
          size,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // widget de solo un producto
  Widget _oneProductCard(Product product) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleAndData("NOTA DE FABRICACION", product.fabricationNote),
        const SizedBox(height: 15),
        _titleAndData("CLIENTE", product.client),
        const SizedBox(height: 15),
        _titleAndData("MODELO", product.name),
        const SizedBox(height: 10),
        _titleAndData("COLOR", product.color),
        const SizedBox(height: 15),
        _titleAndData("TIPO", product.type),
        const SizedBox(height: 15),
        Container(
          alignment: Alignment.center,
          child: Image.network(
            product.image,
            width: double.infinity,
            height: 250,
          ),
        ),
        SizedBox(height: 15),
        Text(
          "Cantidad",
          style: FormStyles.getTextStyleTitle(font: 18, color: Colors.black),
        ),
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            //tallas a analizar y preguntar
            children: [
              _sizeColumn("Terminados", "50"),
              _sizeColumn("Faltantes", "90"),
              _sizeColumn("Total", "320", isBold: true),
            ],
          ),
        ),
      ],
    );
  }

  // WIDGET DE TITULO Y DATO DE OBTENCION
  Widget _titleAndData(String title, String data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title: ",
          style: FormStyles.getTextStyleTitle(font: 14, color: Colors.blueGrey),
        ),
        const SizedBox(height: 5),
        Text(
          data,
          style: FormStyles.getTextStyle(font: 14, color: Colors.black),
        ),
      ],
    );
  }
}
