import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:student_attendance/auth/auth_provider.dart';
import 'package:student_attendance/auth/root_page.dart';
import 'package:student_attendance/components/rounded_button.dart';
import 'package:student_attendance/constants.dart';
import 'package:student_attendance/services/handle_error.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class Login extends StatefulWidget {

  static const String id = 'login';

  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

enum authProblems {
  userNotFound,
  userExist,
  passwordNotValid,
  networkError,
  tooManyRequests
}

class _LoginState extends State<Login> {

  final formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;
  bool showSpinner = false;
  final DateTime timestamp = DateTime.now();
  // authProblems errorType;
  ErrorHandler errorHandler = ErrorHandler();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        color: kColor,
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    _showTitle(),
                    const SizedBox(height: 40.0,),
                    _showImage(),
                    const SizedBox(height: 40.0,),
                    _showEmailInput(),
                    const SizedBox(height: 10.0,),
                    _showPasswordInput(),
                    _showButtons(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _showImage(){
    return SvgPicture.asset('assets/login_img.svg');
  }

  Widget _showTitle(){
    return Text('QR Students App', style: Theme.of(context).textTheme.headline4);
  }

  Widget _showEmailInput(){
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        onSaved: (value) => _email = value!.trim(),
        validator: (value) => value!.isEmpty ? 'Email can\'t be empty.' : null,
        keyboardType: TextInputType.emailAddress,
        decoration: kTextFieldDecoration.copyWith(
            hintText: 'الايميل',
            labelText: 'الايميل'
        ),
        style: const TextStyle(
            height: 1.0,
            color: kColor
        ),
      ),
    );
  }

  Widget _showPasswordInput(){
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        onSaved: (value) => _password = value!,
        validator: (value) => value!.isEmpty ? 'Password can\'t be empty.' : null,
        decoration: kTextFieldDecoration.copyWith(
            hintText: 'الباسوورد',
            labelText: 'الباسوورد'
        ),
        obscureText: true,
        style: const TextStyle(
            height: 1.0,
            color: kColor
        ),
      ),
    );
  }

  Widget _showButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: RoundedButton(
        title: 'الدخول',
        colour: gColor,
        onPressed: validateAndSubmit,
        heightSize: 0,
        widthSize: 0,
      ),
    );
  }


  bool validateAndSave(){
    final form = formKey.currentState;
    if(form!.validate()){
      form.save();
      return true;
    }
    else{
      return false;
    }
  }

  validateAndSubmit() async {
    if(validateAndSave()){
      setState(() {
        showSpinner = true;
      });
      try{
        var auth = AuthProvider.of(context)!.auth;
        String user = await auth.signInWithEmailAndPassword(_email, _password).catchError((e){
          errorHandler.handleLoginError(context, e);
          setState(() {
            showSpinner = false;
          });
        });

        setState(() {
          showSpinner = false;
        });
        Navigator.of(context).pushNamed(RootPage.id);

      // ignore: empty_catches
      }catch(e){

      }
    }
    else{

    }
  }
}

