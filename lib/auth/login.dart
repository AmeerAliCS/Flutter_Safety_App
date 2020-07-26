import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:safetyapp/auth/auth_provider.dart';
import 'package:safetyapp/auth/root_page.dart';
import 'package:safetyapp/components/rounded_button.dart';
import 'package:safetyapp/constants.dart';
import 'package:safetyapp/services/handle_error.dart';

final usersRef = Firestore.instance.collection('users');
final casesRef = Firestore.instance.collection('cases');
final adminRef = Firestore.instance.collection('adminPanel');

final GoogleSignIn googleSignIn = GoogleSignIn();

class Login extends StatefulWidget {

  static const String id = 'login';

  @override
  _LoginState createState() => _LoginState();
}

enum FormType {
  login,
  register
}

enum authProblems {
  UserNotFound,
  UserExist,
  PasswordNotValid,
  NetworkError,
  TooManyRequests
}

class _LoginState extends State<Login> {

  final formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String name;
  FormType formType = FormType.login;
  bool showSpinner = false;
  final DateTime timestamp = DateTime.now();
  authProblems errorType;
  ErrorHandler errorHandler = ErrorHandler();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        color: kGreenColor,
        inAsyncCall: showSpinner,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Image.asset('assets/images/top_shape.png')
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Form(
                  key: formKey,
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 20.0),
                        child: Text(formType == FormType.login ? 'Safety App' : 'Register',
                          style:
                          TextStyle(fontSize: 40, color: kGreenColor, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: buildInputs() + buildSubmitButtons(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Image.asset('assets/images/bottom_shape.png')
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildInputs(){
    if(formType == FormType.login){
      return[

        TextFormField(
          onSaved: (value) => _email = value.trim(),
          validator: (value) => value.isEmpty ? 'Email can\'t be empty.' : null,
          keyboardType: TextInputType.emailAddress,
          decoration: kTextFieldDecoration.copyWith(
              hintText: 'Enter your email',
              labelText: 'Email'
          ),
          style: TextStyle(
              height: 1.0,
              color: kGreenColor
          ),
        ),

        SizedBox(height: 15.0,),

        TextFormField(
          onSaved: (value) => _password = value,
          validator: (value) => value.isEmpty ? 'Password can\'t be empty.' : null,
          decoration: kTextFieldDecoration.copyWith(
              hintText: 'Enter your password',
              labelText: 'Password'
          ),
          obscureText: true,
          style: TextStyle(
              height: 1.0,
              color: kGreenColor
          ),
        ),
      ];
    }

    else{

      return [

        TextFormField(
          onSaved: (value) => name = value,
          validator: (value) => value.isEmpty ? 'Name can\'t be empty.' : null,
          keyboardType: TextInputType.emailAddress,
          decoration: kTextFieldDecoration.copyWith(
              hintText: 'Enter your name',
              labelText: 'Name'
          ),
          style: TextStyle(
              height: 1.0,
              color: kGreenColor
          ),
        ),

        SizedBox(height: 15.0,),

        TextFormField(
          onSaved: (value) => _email = value,
          validator: (value) => value.isEmpty ? 'Email can\'t be empty.' : null,
          keyboardType: TextInputType.emailAddress,
          decoration: kTextFieldDecoration.copyWith(
              hintText: 'Enter your email',
              labelText: 'Email'
          ),
          style: TextStyle(
              height: 1.0,
              color: kGreenColor
          ),
        ),

        SizedBox(height: 15.0,),

        TextFormField(
          onSaved: (value) => _password = value,
          validator: (value) {
            if(value.isEmpty){
              return 'Password can\'t be empty.';
            }
            else if(value.trim().length < 6){
              return 'Password too short';
            }
            else{
              return null;
            }
          },
          decoration: kTextFieldDecoration.copyWith(
              hintText: 'Enter your password',
              labelText: 'Password'
          ),
          obscureText: true,
          style: TextStyle(
              height: 1.0,
              color: kGreenColor
          ),
        ),
      ];
    }

  }

  List<Widget> buildSubmitButtons (){
    if(formType == FormType.login){
      return [
        Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: RoundedButton(
            title: 'Login',
            colour: kGreenColor,
            onPressed: validateAndSubmit,
          ),
        ),
        Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(
              'OR',
              style: TextStyle(color: kGreenColor, fontSize: 16),
              textAlign: TextAlign.center,
            )),

        OutlineButton(
          shape:  RoundedRectangleBorder(borderRadius:  BorderRadius.circular(20.0)),
          borderSide: BorderSide(color: kGreenColor),
          child: Container(
            padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/google_icon.png', height: 25, width: 40,),
                SizedBox(width: 4.0,),
                Text('Login with google', style: TextStyle(fontSize: 18),),

              ],
            ),
          ),
          onPressed: () async {
            final auth = AuthProvider.of(context).auth;
            auth.loginWithGoogle().then((user) {
            Navigator.of(context).pushNamed(RootPage.id);
            });
          },
        ),

        SizedBox(height: 5.0,),

        InkWell(
          child: Center(child: Text('Don\'t have an account? Register')),
          onTap: moveToRegister,
        ),
      ];
    }
    else{
      return [

        SizedBox(height: 15.0,),

        RoundedButton(
          title: 'Create an account',
          colour: kGreenColor,
          onPressed: validateAndSubmit,
        ),

        SizedBox(height: 5.0,),

        InkWell(
          child: Center(child: Text('have an account? Login')),
          onTap: moveToLogin,
        ),

      ];
    }
  }

  bool validateAndSave(){
    final form = formKey.currentState;
    if(form.validate()){
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
        var auth = AuthProvider.of(context).auth;

        if(formType == FormType.login){
          String user = await auth.signInWithEmailAndPassword(_email, _password).catchError((e){
            errorHandler.handleLoginError(context, e);
            print(e);
            setState(() {
              showSpinner = false;
            });
          });
          print(user);
        }
        else{
          auth.displayName = name;
          String user = await auth.createUserWithEmailAndPassword(_email, _password).catchError((e){
            print(e);
            errorHandler.handleRegisterError(context, e);
            setState(() {
              showSpinner = false;
            });
          });
          print('Registerd user: $user');
        }
        setState(() {
          showSpinner = false;
        });

      }catch(e){
        print('Error: $e');
      }
    }
    else{
      print('Fail, email: $_email, password: $_password');
    }
  }

  moveToRegister(){
    formKey.currentState.reset();
    setState(() {
      formType = FormType.register;
    });
  }

  moveToLogin(){
    formKey.currentState.reset();
    setState(() {
      formType = FormType.login;
    });
  }

}
