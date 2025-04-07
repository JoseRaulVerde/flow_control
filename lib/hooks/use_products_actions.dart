import 'package:flow_control/provider/product_provider.dart';
import 'package:flow_control/services/provider/products_actions_service.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

// hook de aplicacion de servicio de provider de product
ProductsActionsService useProductsActions(BuildContext context){
  final productProvider = Provider.of<ProductsProvider>(context, listen: false);
  return ProductsActionsService(productProvider);
}