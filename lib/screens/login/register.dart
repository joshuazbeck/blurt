import 'package:flutter/material.dart';

/** REGISTER PAGE */
class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsetsDirectional.all(40), child: const RegisterForm());
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  String _password = "";
  String _confirmPassword = "";
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Spacer(flex: 10),
            Text("share your first blurt",
                style: Theme.of(context).textTheme.headlineSmall),
            Spacer(),
            Text("create an account to start",
                style: Theme.of(context).textTheme.labelLarge),
            Spacer(flex: 10),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Enter Username",
                labelText: "Username",
                hintStyle: TextStyle(color: Colors.white),
                labelStyle: TextStyle(color: Colors.white),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'The username field was empty';
                }

                return null;
              },
            ),
            Spacer(),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Enter Password",
                labelText: "Password",
                hintStyle: TextStyle(color: Colors.white),
                labelStyle: TextStyle(color: Colors.white),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'The password field was empty';
                }
                _password = value;
                return null;
              },
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "(Re)enter Password",
                labelText: "Password Confirm",
                hintStyle: TextStyle(color: Colors.white),
                labelStyle: TextStyle(color: Colors.white),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'The password confirmation field is empty';
                }
                _confirmPassword = value;
                if (_confirmPassword != _password) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            Spacer(flex: 10),
            ElevatedButton(
                onPressed: _submitForm, child: const Text("Create Account")),
          ]),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Creating account')),
      );
    }
  }
}
/**
 * 
 *  Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Enter Username",
                labelText: "Username",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  //TODO: Actual opinionated validation will be needed
                  return "Must include a username";
                }
                return null;
              },
              onChanged: (text) => {
                //TODO: Validate username is valid
                print("The username was entered as $text")
              },
            ),
            TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter Password',
                  labelText: "Password",
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    //TODO: Actually validate
                    return "Must include a password";
                  }
                  return null;
                },
                onChanged: (text) => {
                      //TODO: Validate password is valid
                      print("The password was entered as $text")
                    }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Process form data
                    print("THE FORM IS VALID");
                  }
                },
                child: Text('Create Account'),
              ),
            ),
          ]),
        )
 */