import 'package:blurt/view/auth/register.dart';
import 'package:blurt/controllers/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../assets/style/theme.dart';
import '../../main.dart';
import '../../controllers/shared.dart';
import '../main/dashboard.dart';
import '../templates/template_form.dart';

/** REGISTER PAGE */
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return LoginForm();
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  //Store the static keys for tests
  static const emailFieldKey = Key("email");
  static const passwordFieldKey = Key("password");
  static const loginBntKey = Key("login");

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  //Hold the values for the form
  String _email = "";
  String _password = "";
  String _confirmPassword = "";

  /*********** INPUT DECORATORS **********/
  final InputDecoration _emailDecorator = InputDecoration(
    hintText: "enter email",
    filled: true,
    fillColor: Colors.grey[200],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
  );
  final InputDecoration _passwordDecorator = InputDecoration(
    hintText: "enter password",
    filled: true,
    fillColor: Colors.grey[200],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
  );

  /*********** BUILD THE FORM **********/
  @override
  Widget build(BuildContext context) {
    return TemplateForm(
      formKey: _formKey,
      bottomButton: IconButton(
        key: LoginForm.loginBntKey,
        icon: Icon(Icons.add),
        onPressed: _submitForm,
        color: BlurtTheme.white,
        iconSize: 40,
      ),
      child: Column(children: <Widget>[
        SizedBox(
            height: 200,
            child: Column(children: [
              Spacer(),
              Text("login", style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: 17),
              Opacity(
                  opacity: 0.5,
                  child: Text("we’re excited you’re back",
                      style: Theme.of(context).textTheme.labelLarge)),
            ])),
        const Spacer(
          flex: 1,
        ),
        TextFormField(
          key: LoginForm.emailFieldKey,
          style: TextStyle(
              color: Colors.black,
              fontFamily: GoogleFonts.josefinSlab().fontFamily),
          decoration: _emailDecorator,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'The email field was empty';
            }
            _email = value;
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          key: LoginForm.passwordFieldKey,
          style: TextStyle(
              color: Colors.black,
              fontFamily: GoogleFonts.josefinSlab().fontFamily),
          obscureText: true,
          decoration: _passwordDecorator,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'The password field was empty';
            }
            _password = value;
            return null;
          },
        ),
        const Spacer(
          flex: 2,
        ),
        TextButton(
            onPressed: _openRegister,
            child: Text("i need to create an account",
                style: Theme.of(context).textTheme.labelSmall))
      ]),
    );
  }

/*********** HANDLE BUTTON EVENTS **********/

  /// Open the registeration page
  void _openRegister() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainAuth(page: Register())),
    );
  }

  /// Attempt to login
  void _submitForm() async {
    //Check that the form is validated
    if (_formKey.currentState?.validate() ?? false) {
      //Create a new instance of the authentication service
      AuthService _auth = AuthService();

      //Attempt to login the user
      User? _user = await _auth.signInWithEmailAndPassword(_email, _password);
      if (_user != null) {
        //Save the user to the user defaults
        Shared.saveLogin(_email, _password);

        //Open the dashboard feed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Main(page: const Dashboard())),
        );
      } else {
        //If the context is still mounted, show a login failure
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login failed')),
          );
        }
      }
    }
  }
}
