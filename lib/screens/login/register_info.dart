import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../services/auth_service.dart';
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

  @override
  State<RegisterPersonalForm> createState() => _RegisterPersonalFormState();
}

class _RegisterPersonalFormState extends State<RegisterPersonalForm> {
  final _formKey = GlobalKey<FormState>();
  String? _firstName;
  String? _lastName;
  String? _phoneNumber;
  DateTime? _date;

  bool _checked = false;

  InputDecoration _firstNameDecorator = InputDecoration(
    hintText: "enter first name",
    filled: true,
    fillColor: Colors.grey[200],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
  );
  InputDecoration _lastNameDecorator = InputDecoration(
    hintText: "enter last name",
    filled: true,
    fillColor: Colors.grey[200],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
  );
  InputDecoration _phoneNumberDecorator = InputDecoration(
    hintText: "enter phone number",
    filled: true,
    fillColor: Colors.grey[200],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
  );
  InputDecoration _dateTimeDecorator = InputDecoration(
    hintText: "enter birthday",
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
              Text("personal information",
                  style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: 17),
              Text("we don’t sell this stuff",
                  style: Theme.of(context).textTheme.labelLarge)
            ])),
        Spacer(flex: 1),
        TextFormField(
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
        SizedBox(height: 20),
        TextFormField(
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
        SizedBox(height: 20),
        TextFormField(
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
        SizedBox(height: 20),
        DateTimeField(
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
        Spacer(flex: 2),
        CheckboxFormField(
          value: _checked,
          context: context,
        ),
      ]),
      bottomButton: IconButton(
        icon: Icon(Icons.check_rounded),
        onPressed: _addInfo,
        color: Colors.white,
        iconSize: 40,
      ),
    );
  }

  void _openDashboard() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Main(page: Dashboard())),
    );
  }

  void _addInfo() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    AuthService _auth = AuthService();
    if (user == null) {
      //TODO: redirect to the login
    } else {
      if (_formKey.currentState?.validate() ?? false) {
        if (_firstName == null ||
            _lastName == null ||
            _phoneNumber == null ||
            _date == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Some fields are empty')),
          );

          return;
        }
        _auth.addFullUser(
            user, _firstName!, _lastName!, _phoneNumber!, _date.toString());
        _openDashboard();
      }
    }
  }
}

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField(
      {FormFieldValidator<bool>? validator,
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
//display error in matching theme
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
