import 'package:flutter/material.dart';


class FormStyles{
  static InputDecoration getInputDecoration({required String label}) {
    return InputDecoration(
      labelText: label,
      labelStyle: FormStyles.getTextStyleTitle(font: 16, color: Color(0xFF90A4AE)),
      filled: true,
      fillColor: Color.fromARGB(255, 226, 231, 240),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide.none, 
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
  // Titulos
  static TextStyle getTextStyleTitle({required double font, required Color color}){
    return TextStyle(
        fontSize: font,
        fontWeight: FontWeight.w600,
        color: color,
        fontFamily: 'SF Pro Display',
      );
  }
  // Subtitulos
  static TextStyle getTextStyleSubitle({required double font, required Color color}){
    return TextStyle(
        fontSize: font,
        fontWeight: FontWeight.normal,
        color: color,
        wordSpacing: 1.5
      );
  }
  // Texto Generico
  static TextStyle getTextStyle({required double font, required Color color}){
    return TextStyle(
        fontSize: font,
        fontWeight: FontWeight.bold,
        color: color,
      );
  }

  static ButtonStyle genericBackgroundStyle ({required EdgeInsets padding, required Size size}){
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.all(CustomColors().greyBackground),
      minimumSize: WidgetStateProperty.all(size),
      padding: WidgetStateProperty.all(padding), 
      );
  }
  static BoxDecoration boxBackgroundStyle () {
    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      color: CustomColors().greyBackground
    );
  }
  static BoxDecoration boxProductsCardHeaderContainer ({isConfirmed = false}) {
    return BoxDecoration(
      color: isConfirmed ? CustomColors().blueConfirmContainerHeader : CustomColors().blueContainer,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    );
  }
  static BoxDecoration boxProductsCardHeaderContainerConfirmed () {
    return BoxDecoration(
      color: const Color.fromARGB(255, 79, 189, 245),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    );
  }
  static BoxDecoration boxProductsCardBottonContainer ({isConfirmed = false}) {
    return BoxDecoration(
        color: isConfirmed ? CustomColors().greyBackground : Colors.grey[200],
      );
  }
}

class CustomColors {
  final Color blueButton = Color.fromARGB(255, 28, 123, 200);
  final Color blueConfirmContainerHeader = const Color.fromARGB(255, 79, 189, 245);
  final Color blueContainer = const Color.fromARGB(255, 220, 232, 247);
  final Color greyBackground = const Color.fromARGB(103, 175, 185, 186) ;

}