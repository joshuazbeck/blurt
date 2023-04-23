import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

/** REGISTER PAGE */
class RegisterPersonalInfo extends StatefulWidget {
  const RegisterPersonalInfo({super.key});

  @override
  State<RegisterPersonalInfo> createState() => _RegisterPersonalInfoState();
}

class _RegisterPersonalInfoState extends State<RegisterPersonalInfo> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsetsDirectional.all(40),
        child: const RegisterPersonalForm());
  }
}

class RegisterPersonalForm extends StatefulWidget {
  const RegisterPersonalForm({super.key});

  @override
  State<RegisterPersonalForm> createState() => _RegisterPersonalFormState();
}

class _RegisterPersonalFormState extends State<RegisterPersonalForm> {
  final _formKey = GlobalKey<FormState>();
  bool _checked = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Spacer(flex: 3),
            Text("personal information",
                style: Theme.of(context).textTheme.headlineSmall),
            Spacer(),
            Text("we don’t sell this stuff",
                style: Theme.of(context).textTheme.labelLarge),
            Spacer(),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "enter your first name",
                labelText: "first name",
                hintStyle: TextStyle(color: Colors.white),
                labelStyle: TextStyle(color: Colors.white),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter your first name';
                }

                return null;
              },
            ),
            Spacer(),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "enter your last name",
                labelText: "last name",
                hintStyle: TextStyle(color: Colors.white),
                labelStyle: TextStyle(color: Colors.white),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter your last name';
                }

                return null;
              },
            ),
            Spacer(),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "enter your email",
                hintStyle: TextStyle(color: Colors.white),
                labelText: "email",
                labelStyle: TextStyle(color: Colors.white),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter your email';
                }

                return null;
              },
            ),
            Spacer(),
            TextFormField(
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: "enter your phone #",
                labelText: "phone #",
                hintStyle: TextStyle(color: Colors.white),
                labelStyle: TextStyle(color: Colors.white),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter your phone number';
                }

                return null;
              },
            ),
            Spacer(),
            DateTimeField(
              format: DateFormat("yyyy-MM-dd"),
              decoration: InputDecoration(
                labelText: 'Birthday',
                hintText: 'Enter your birthday',
                hintStyle: TextStyle(color: Colors.white),
                labelStyle: TextStyle(color: Colors.white),
              ),
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
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
                // _date = value;
                return null;
              },
            ),
            CheckboxFormField(
              value: _checked,
            ),
            ElevatedButton(
                onPressed: _submitForm, child: const Text("Add Info")),
          ]),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adding info')),
      );
    }
  }
}

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField(
      {FormFieldValidator<bool>? validator,
      bool value = false,
      bool autovalidate = false})
      : super(builder: (FormFieldState<bool> state) {
          return Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Checkbox(
                    value: value,
                    onChanged: state.didChange,
                  ),
                  Expanded(
                      child: Text(
                          "i agree to the terms of condition and the privacy policy"))
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
