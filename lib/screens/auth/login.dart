import 'package:blurt/screens/auth/register.dart';
import 'package:blurt/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';
import '../../services/shared.dart';
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

  static const emailFieldKey = Key("email");
  static const passwordFieldKey = Key("password");
  static const loginBntKey = Key("login");

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String _email = "";
  String _password = "";
  String _confirmPassword = "";
  InputDecoration _emailDecorator = InputDecoration(
    hintText: "enter email",
    filled: true,
    fillColor: Colors.grey[200],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
  );
  InputDecoration _passwordDecorator = InputDecoration(
    hintText: "enter password",
    filled: true,
    fillColor: Colors.grey[200],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
  );
  @override
  Widget build(BuildContext context) {
    return TemplateForm(
      formKey: _formKey,
      child: Column(children: <Widget>[
        Container(
            height: 200,
            child: Column(children: [
              Spacer(),
              Text("login", style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: 17),
              Text("we’re excited you’re back",
                  style: Theme.of(context).textTheme.labelLarge),
            ])),
        Spacer(
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
        SizedBox(height: 20),
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
        Spacer(
          flex: 2,
        ),
        TextButton(
            onPressed: _openRegister,
            child: Text("i need to create an account",
                style: Theme.of(context).textTheme.labelSmall))
      ]),
      bottomButton: IconButton(
        key: LoginForm.loginBntKey,
        icon: Icon(Icons.add),
        onPressed: _submitForm,
        color: Colors.white,
        iconSize: 40,
      ),
    );
  }

  void _openRegister() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainAuth(page: Register())),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      AuthService _auth = AuthService();
      User? _user = await _auth.signInWithEmailAndPassword(_email, _password);
      if (_user != null) {
        Shared.saveLogin(_email, _password);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Main(page: Dashboard())),
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login failed')),
          );
        }
      }
    }
  }
}
