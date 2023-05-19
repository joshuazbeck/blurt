import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../assets/style/theme.dart';
import '../../main.dart';
import '../../controllers/auth_service.dart';
import '../main/dashboard.dart';
import '../templates/template_form.dart';

/** REGISTER PAGE */
class RegisterInfo extends StatefulWidget {
  const RegisterInfo({super.key});

  @override
  State<RegisterInfo> createState() => _RegisterInfoState();
}

class _RegisterInfoState extends State<RegisterInfo> {
  @override
  Widget build(BuildContext context) {
    return RegisterPersonalForm();
  }
}

class RegisterPersonalForm extends StatefulWidget {
  const RegisterPersonalForm({super.key});

  //Store the static keys for tests
  static const usernameKey = Key("username");
  static const firstNameKey = Key("firstName");
  static const lastNameKey = Key("lastName");
  static const phoneNumKey = Key("phone#");
  static const bdayKey = Key("bday");
  static const addInfoBnt = Key("addRegisterInfo");

  @override
  State<RegisterPersonalForm> createState() => _RegisterPersonalFormState();
}

class _RegisterPersonalFormState extends State<RegisterPersonalForm> {
  final _formKey = GlobalKey<FormState>();

  //Hold the values for the form
  String? _firstName;
  String? _lastName;
  String? _phoneNumber;
  String? _username;
  DateTime? _date;

  // Hold the value for whether the privacy policy is checked
  bool _checked = false;

  /*********** INPUT DECORATORS **********/
  final InputDecoration _usernameDecorator = InputDecoration(
    hintText: "enter username",
    filled: true,
    fillColor: Colors.grey[200],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
  );
  final InputDecoration _firstNameDecorator = InputDecoration(
    hintText: "enter first name",
    filled: true,
    fillColor: Colors.grey[200],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
  );
  final InputDecoration _lastNameDecorator = InputDecoration(
    hintText: "enter last name",
    filled: true,
    fillColor: Colors.grey[200],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
  );
  final InputDecoration _phoneNumberDecorator = InputDecoration(
    hintText: "enter phone number",
    filled: true,
    fillColor: Colors.grey[200],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
  );
  final InputDecoration _dateTimeDecorator = InputDecoration(
    hintText: "enter birthday",
    filled: true,
    fillColor: Colors.grey[200],
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.pink)),
  );

  /*********** BUILD THE FORM **********/
  @override
  Widget build(BuildContext context) {
    return TemplateForm(
      formKey: _formKey,
      bottomButton: IconButton(
        key: RegisterPersonalForm.addInfoBnt,
        icon: Icon(Icons.check_rounded),
        onPressed: _addInfo,
        color: BlurtTheme.white,
        iconSize: 40,
      ),
      child: Column(children: <Widget>[
        SizedBox(
            height: 200,
            child: Column(children: [
              const Spacer(),
              Text("personal information",
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 17),
              Opacity(
                  opacity: 0.5,
                  child: Text("we don’t sell this stuff",
                      style: Theme.of(context).textTheme.labelLarge))
            ])),
        const Spacer(flex: 1),
        TextFormField(
          key: RegisterPersonalForm.usernameKey,
          style: TextStyle(
              color: Colors.black,
              fontFamily: GoogleFonts.josefinSlab().fontFamily),
          decoration: _usernameDecorator,
          validator: (value) {
            _username = value;
            if (value == null || value.isEmpty) {
              return 'please enter a username';
            }

            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          key: RegisterPersonalForm.firstNameKey,
          style: TextStyle(
              color: Colors.black,
              fontFamily: GoogleFonts.josefinSlab().fontFamily),
          decoration: _firstNameDecorator,
          validator: (value) {
            _firstName = value;
            if (value == null || value.isEmpty) {
              return 'please enter your first name';
            }

            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          key: RegisterPersonalForm.lastNameKey,
          style: TextStyle(
              color: Colors.black,
              fontFamily: GoogleFonts.josefinSlab().fontFamily),
          decoration: _lastNameDecorator,
          validator: (value) {
            _lastName = value;
            if (value == null || value.isEmpty) {
              return 'please enter your last name';
            }

            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          key: RegisterPersonalForm.phoneNumKey,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            MaskedTextInputFormatter('(###) ###-####')
          ],
          style: TextStyle(
              color: Colors.black,
              fontFamily: GoogleFonts.josefinSlab().fontFamily),
          decoration: _phoneNumberDecorator,
          keyboardType: TextInputType.phone,
          validator: (value) {
            _phoneNumber = value;
            if (value == null || value.isEmpty) {
              return 'please enter your phone number';
            }

            return null;
          },
        ),
        const SizedBox(height: 20),
        DateTimeField(
          key: RegisterPersonalForm.bdayKey,
          style: TextStyle(
              color: Colors.black,
              fontFamily: GoogleFonts.josefinSlab().fontFamily),
          decoration: _dateTimeDecorator,
          format: DateFormat("yyyy-MM-dd"),
          onShowPicker: (context, currentValue) async {
            final date = await showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2100));
            _date = date;
            if (date != null) {
              return date;
            } else {
              return currentValue;
            }
          },
          validator: (value) {
            if (value == null) {
              return 'Please enter a date';
            }
            return null;
          },
        ),
        const Spacer(flex: 2),
        CheckboxFormField(
          value: _checked,
          context: context,
        ),
      ]),
    );
  }

  /*********** BUTTON METHODS **********/

  ///Open the dashboard
  void _openDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Main(page: const Dashboard())),
    );
  }

  /// Submit the form and add the additional information to the authenticated user
  void _addInfo() {
    // Get the logged in user
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    AuthService _auth = AuthService();

    if (user == null) {
      //TODO: redirect to the login
    } else {
      // If the form is valid
      if (_formKey.currentState?.validate() ?? false) {
        if (_firstName == null ||
            _lastName == null ||
            _phoneNumber == null ||
            _date == null ||
            _username == null) {
          // Catch the empty fields
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Some fields are empty')),
          );

          return;
        }
        // Add the additional information
        _auth.addFullUser(user, _username!, _firstName!, _lastName!,
            _phoneNumber!, _date.toString());

        // Open the dashboard feed
        _openDashboard();
      }
    }
  }
}

//A custom checkbox form field
class CheckboxFormField extends FormField<bool> {
  CheckboxFormField(
      {super.key,
      FormFieldValidator<bool>? validator,
      bool value = false,
      bool autovalidate = false,
      ValueChanged<bool>? onChanged,
      required BuildContext context})
      : super(builder: (FormFieldState<bool> state) {
          return Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Checkbox(
                    value: value,
                    onChanged: (value) {
                      state.didChange(value);
                    },
                  ),
                  Expanded(
                      child: Text(
                          "i agree to the terms of condition and the privacy policy",
                          style: Theme.of(context).textTheme.labelSmall))
                ],
              ),
              Text(
                state.errorText ?? '',
                style: TextStyle(
                  color: Theme.of(state.context).colorScheme.error,
                ),
              )
            ],
          );
        });
}

// Based off an online source to format a phone number
class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;

  MaskedTextInputFormatter(this.mask);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var selectionIndex = newValue.selection.end;
    var maskedText = applyMask(newValue.text);
    var maskedSelectionIndex = getMaskedSelectionIndex(selectionIndex);

    return TextEditingValue(
      text: maskedText,
      selection: TextSelection.collapsed(offset: maskedSelectionIndex),
    );
  }

  String applyMask(String text) {
    var maskedText = '';
    var textIndex = 0;

    for (var i = 0; i < mask.length; i++) {
      if (textIndex >= text.length) {
        break;
      }

      var maskChar = mask[i];
      var textChar = text[textIndex];

      if (maskChar == '#') {
        maskedText += textChar;
        textIndex++;
      } else {
        maskedText += maskChar;
      }
    }

    return maskedText;
  }

  int getMaskedSelectionIndex(int selectionIndex) {
    var maskedSelectionIndex = selectionIndex;

    for (var i = 0; i < mask.length; i++) {
      if (maskedSelectionIndex <= 0) {
        break;
      }

      var maskChar = mask[i];

      if (maskChar != '#') {
        maskedSelectionIndex++;
      }
    }

    return maskedSelectionIndex;
  }
}
