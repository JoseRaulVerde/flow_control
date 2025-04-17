import 'package:flow_control/hooks/use_user_actions.dart';
import 'package:flow_control/modals/alert_message.dart';
import 'package:flow_control/services/provider/user_actions_service.dart';
import 'package:flow_control/utils/form_styles.dart';
import 'package:flow_control/widgets/scanning_code.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _userNameFocus = FocusNode();
  final FocusNode _passwordFofus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final log = Logger();
  late final UserActionsService userActions;  

  bool _isLoading = false;
  bool _isReseting = false;


  

  void _scanCodeUser() {
    setState(() {
      _passwordFofus.unfocus();
      _userNameFocus.unfocus();
      _userNameController.clear();
      _passwordController.clear();
    });
  }

  @override
  void initState() {
    super.initState();

    // Accede al hook después de que el contexto esté listo
    Future.delayed(Duration.zero, () {
      userActions = useUserActions(context);
      _checkActiveSession();
    });
  }

  Future<void> _checkActiveSession() async {
    setState(() => _isReseting = true);

    final isLogged = await userActions.checkActiveSession();

    if (isLogged && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      log.i('No hay sesión activa');
    }

    setState(() => _isReseting = false);
  }


  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Image.asset(
                'assets/logogreen.png',
                width: 200,
                height: 200,
              )),
              Container(
                width: double.infinity,
                height: 50,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color.fromARGB(100, 0, 0, 0),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Text('FlowControl V1.0', style: FormStyles.getTextStyleTitle(
                  font: 16, 
                  color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                child: _isReseting
                    ? SizedBox(
                      height: 300,
                      width: 200,
                      child: Center(
                        child:  CircularProgressIndicator()),
                    )
                    : _formLoginData(),              
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formLoginData() {
    final userActions = useUserActions(context);

    void login() async{
      if (_formKey.currentState!.validate()) {
        setState(() => _isLoading = true);

       final error =  await userActions.login(_userNameController.text, _passwordController.text);
       if (error == null && mounted){
          Navigator.pushReplacementNamed(context, '/home');
        } else if (mounted) {
          showAlertModal(context, error ?? 'Ocurrió un error inesperado');
       }
      }
      setState(() => _isLoading = false);
    }

    void forgotPassword (){
    userActions.forgotPassword();
    //enviar el correo
    log.i('click');
  }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Inicia sesion",
            style: TextStyle(
              fontSize: 24, 
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start
          ),
          const SizedBox(height: 20),
          TextFormField(
            focusNode: _userNameFocus,
            controller: _userNameController,
            onFieldSubmitted: (_){
               _passwordFofus.requestFocus();
            },
            decoration: FormStyles.getInputDecoration(label: "Username"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Este campo es obligatorio';
              }
              return null; 
            },
            onChanged: (value) async {
              _userNameController.text = value;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            focusNode: _passwordFofus,
            controller: _passwordController,
            onFieldSubmitted: (value){
              _passwordController.text= value;
              _passwordFofus.unfocus();
              login();
            },
            obscureText: true,
            decoration: FormStyles.getInputDecoration(label: "Password"),
            validator: (value) =>
                value!.isEmpty ? "Ingrese su contraseña" : null,
          ),
          const SizedBox(height: 10),
            IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
              onPressed: (){
                _scanCodeUser();
                showDialog(context: context, builder: (_)=>ScanningCode(focusNode: FocusNode(),),
                );
                },
              icon: const Icon(Icons.drag_handle, size: 30,),
              style: ButtonStyle(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), 
                    side: const BorderSide(
                      color: Colors.lightBlue,
                      width: 1,
                    ),
                  ),
                ),
              )
            ),
          const SizedBox(height: 10),
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.blue)),
                  onPressed: (){
                    login();
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Text("Log in",
                    textAlign: TextAlign.center,
                    style: FormStyles.getTextStyleTitle(font: 16, color: Colors.white)
                    )
                  ),
                ),
          TextButton(
            onPressed: forgotPassword,
            child: Text(
              "Olvido su contraseña",
              textAlign: TextAlign.center,
              style: FormStyles.getTextStyleTitle(font: 14, color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}