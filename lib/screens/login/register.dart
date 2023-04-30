import 'package:blurt/screens/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';
import '../../services/auth_service.dart';
import '../templates/template_form.dart';
import 'register_info.dart';

/** REGISTER PAGE */
class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return const RegisterForm();
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  String _emailError = "";
  String _passwordError = "";

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

  InputDecoration _confirmPasswordDecorator = InputDecoration(
    hintText: "(re)enter password",
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
              RichText(
                  text: TextSpan(
                      text: 'share your first',
                      style: Theme.of(context).textTheme.headlineSmall,
                      children: [
                    TextSpan(
                        text: ' blurt',
                        style: TextStyle(color: Theme.of(context).primaryColor))
                  ])),
              SizedBox(height: 17),
              Text("create an account to start",
                  style: Theme.of(context).textTheme.labelLarge),
            ])),
        Spacer(
          flex: 1,
        ),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: _emailDecorator,
          style: TextStyle(
              color: Colors.black,
              fontFamily: GoogleFonts.josefinSlab().fontFamily),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'The email field was empty';
            }
            final RegExp emailRegex =
                RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
            if (!emailRegex.hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            _email = value;
            if (_emailError != "") {
              String _emailErrorCopy = _emailError;
              _emailError = "";
              return _emailErrorCopy;
            }
            return null;
          },
        ),
        SizedBox(height: 20),
        TextFormField(
          obscureText: true,
          style: TextStyle(
              color: Colors.black,
              fontFamily: GoogleFonts.josefinSlab().fontFamily),
          decoration: _passwordDecorator,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'The password field was empty';
            }
            _password = value;
            return null;
          },
        ),
        SizedBox(height: 20),
        TextFormField(
          obscureText: true,
          style: TextStyle(
              color: Colors.black,
              fontFamily: GoogleFonts.josefinSlab().fontFamily),
          decoration: _confirmPasswordDecorator,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'The password confirmation field is empty';
            }
            _confirmPassword = value;
            if (_confirmPassword != _password) {
              return 'Passwords do not match';
            }
            if (_passwordError != "") {
              String _passwordErrorCopy = _passwordError;
              _passwordError = "";
              return _passwordErrorCopy;
            }
            return null;
          },
        ),
        Spacer(
          flex: 2,
        ),
        TextButton(
            onPressed: _openLogin,
            child: Text("i already have an account",
                style: Theme.of(context).textTheme.labelSmall))
      ]),
      bottomButton: Container(
        child: IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: _registerUser,
          color: Colors.white,
        ),
        // iconSize: 40,
      ),
    );
  }

  void _openLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainAuth(page: Login())),
    );
  }

  void _registerUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        AuthService _auth = AuthService();
        User? _user = await _auth.registerNewUser(_email, _password);

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MainAuth(page: RegisterInfo())),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          _passwordError = 'The password provided is too weak.';
          _formKey.currentState!.validate();
        } else if (e.code == 'email-already-in-use') {
          _emailError = 'The account already exists for that email.';
          _formKey.currentState!.validate();
        }
        return null;
      } catch (e) {
        print(e.toString());
        return null;
      }
    }
  }
}
